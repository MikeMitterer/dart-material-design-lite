part of mdldialog;

enum MdlDialogStatus {
    CLOSED_BY_ESC, CLOSED_BY_BACKDROPCLICK,
    CLOSED_ON_TIMEOUT, CLOSED_VIA_NEXT_SHOW,
    OK,
    YES, NO,

    // Toast sends a "confirmed"
    CONFIRMED
}

/// Called if ESC is pressed or if the user clicks on the backdrop-Container
typedef void OnCloseCallback(final MaterialDialog dialog, final MdlDialogStatus status);

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialDialogCssClasses {

    /// build something like mdl-dialog-container or mdl-toast-container
    final String CONTAINER_POSTFIX = '-container';

    final String IS_VISIBLE = 'is-visible';
    final String IS_HIDDEN = 'is-hidden';

    final String IS_DELETABLE = "is-deletable";
    final String APPENDING = "appending";

    final String WAITING_FOR_CONFIRMATION = 'waiting-for-confirmation';

    const _MaterialDialogCssClasses();
}

/**
 * Configuration for DialogElement
 */
class DialogConfig {
    static const String _DEFAULT_PARENT_SELECTOR = "body";

    /// In most cases this is "mdl-dialog" but can also be "mdl-toast"
    /// _createDialogElementFromString checks the template if this tag exists
    final String rootTagInTemplate;

    /// If set to true a BackDrop-Container is added
    bool closeOnBackDropClick;

    /// true
    bool acceptEscToClose;

    /// Informs the caller about ESC and about onBackDropClick so that the caller can
    /// close this DialogElement an cleanup internal states
    final List<OnCloseCallback> onCloseCallbacks = new List<OnCloseCallback>();

    /// Usually "body" ({_DEFAULT_PARENT_SELECTOR})
    final String parentSelector;

    /// A Toast-Message for example can have a Timer and closes automatically, not so an AlertDialog
    final bool autoClosePossible;

    DialogConfig({ final String rootTagInTemplate: "mdl-dialog",
                   final bool closeOnBackDropClick: true,
                   final bool acceptEscToClose: true,
                   final String parentSelector: _DEFAULT_PARENT_SELECTOR,
                   final bool autoClosePossible: false })

    : this.rootTagInTemplate = rootTagInTemplate,
      this.closeOnBackDropClick = closeOnBackDropClick,
      this.acceptEscToClose = acceptEscToClose,
      this.parentSelector = parentSelector,
      this.autoClosePossible = autoClosePossible {

        Validate.notBlank(rootTagInTemplate);
    }
}

/// HTML-Part of MdlDialog.
class MaterialDialog extends Object with TemplateComponent {
    final Logger _logger = new Logger('mdldialog.DialogElement');

    /// All Dialogs
    static final Map<String,MaterialDialog> _dialogElements = new Map<String,MaterialDialog>();

    static const _MaterialDialogCssClasses _cssClasses = const _MaterialDialogCssClasses();

    /// AutoClose-Timer
    Timer _autoCloseTimer = null;

    /// usually the html body
    dom.Element _parent;

    /// represents the <mdl-dialog> tag
    //dom.Element _htmlWskDialogNode;

    /// Wraps wskDialogElement. Darkens the background and
    /// is used for backdrop click
    dom.DivElement _wskDialogContainer;

    /// Informs about open and close actions
    Completer<MdlDialogStatus> _completer = null;

    /// Listens to Keyboard-Events
    StreamSubscription _keyboardEventSubscription;

    /// Configuration for this DialogElement
    final DialogConfig _config;

    MaterialDialog(this._config) {
        Validate.notNull(_config);
    }

    /// The returned Future informs about how the dialog was closed
    /// If {timeout} is set - the corresponding dialog closes automatically after this period
    /// The callback {dialogIDCallback} can be given to find out the dialogID - useful for Toast that needs confirmation
    Future<MdlDialogStatus> show({ final Duration timeout,void dialogIDCallback(final String dialogId) }) {
        Validate.isTrue(_completer == null);

        _logger.info("show");

        _completer = new Completer<MdlDialogStatus>();

        _parent = dom.document.querySelector(_config.parentSelector);

        _wskDialogContainer = _prepareContainer();

        if(_config.closeOnBackDropClick) {
            _addBackDropClickListener(_wskDialogContainer);
        }

        _wskDialogContainer.classes.add(_cssClasses.APPENDING);

        if (_parent.querySelector(_containerSelector) == null) {
            _parent.append(_wskDialogContainer);
        }

        renderElement(_wskDialogContainer).then((_) {

            _wskDialogContainer.classes.remove(_cssClasses.IS_HIDDEN);
            _wskDialogContainer.classes.add(_cssClasses.IS_VISIBLE);
            _wskDialogContainer.classes.remove(_cssClasses.APPENDING);

            if(_config.acceptEscToClose) {
                _addEscListener();
            }
            if(timeout != null) {
                _startTimeoutTimer(timeout);
            }
            _logger.info("show end");
        });

        return _completer.future;
    }

    Future close(final MdlDialogStatus status) {
        _removeEscListener();

        void _resetTimer() {
            if(_autoCloseTimer != null) {
                _autoCloseTimer.cancel();
                _autoCloseTimer = null;
            }
        }
        _resetTimer();

        // Hide makes it possible to fade out the dialog
        return _hide(status);
    }

/*    /// If the {dialogID} is given - it closes this specific dialog, otherwise all dialog with a timer (autoCloseEnabled)
    /// will be closed. If {onlyIfAutoCloseEnabled} is set to false all Dialogs will be closed regardless if
    /// the have a Timer or not
    Future close(final MdlDialogStatus status, { final String dialogID, bool onlyIfAutoCloseEnabled: true }) {
        //Validate.notEmpty(_dialogElements,"You try to close a dialog but they are all already closed???");

        if(dialogID != null && dialogID.isNotEmpty) {
            if(!_dialogElements.containsKey(dialogID)) {
                _logger.warning("Dialog with ID $dialogID should be close but is already closed.");
                return new Future.value();
            }
            final DialogElement dialogElement = _dialogElements.remove(dialogID);
            return dialogElement.close(status);
        }

        final List<Future> futures = new List<Future>();
        _dialogElements.forEach((final String key, final DialogElement element) {
            if(element.isAutoCloseEnabled || onlyIfAutoCloseEnabled == false || config.autoClosePossible == false) {
                _logger.info("Closing Dialog ${element.id}");
                futures.add(element.close(status));
            }
        });

        return Future.wait(futures);
    }

    /// Shortcut to close(status,onlyIfAutoCloseEnabled: false);
    Future closeAll(final MdlDialogStatus status) {
        return close(status,onlyIfAutoCloseEnabled: false);
    }*/

    int get numberOfDialogs => _dialogElements.length;

    String get id => hashCode.toString();

    bool get hasTimer => _autoCloseTimer != null && _autoCloseTimer.isActive;
    bool get hasNoTimer => !hasTimer;
    bool get isAutoCloseEnabled => hasTimer;

    // - private ----------------------------------------------------------------------------------

    /// This timer is used to close automatically this dialog (Toast, Growl)
    void _startTimeoutTimer(final Duration timeout) {
        Validate.notNull(timeout);

        _autoCloseTimer = new Timer(timeout,() {
            close(MdlDialogStatus.CLOSED_ON_TIMEOUT);
        });
    }

    dom.HtmlElement get _container => dom.document.querySelector(".${_containerClass}");

    dom.Element get _element => dom.document.querySelector(_elementSelector);

    /// mdl-dialog-container or mdl-toast-container
    String get _containerClass => "${_config.rootTagInTemplate}${_cssClasses.CONTAINER_POSTFIX}";

    /// unique ID for dialog-wrapper
    String get _containerID => "mdl-container-${hashCode.toString()}";

    String get _elementID => "mdl-element-${hashCode.toString()}";

    /// identifies the container
    /// <div class="mdl-toast-container" id="dialog9234848">...</div>
    String get _containerSelector => ".${_containerClass}";

    /// identifies the element
    /// <mdl-dialog id="xxxxx">...</mdl-dialog>
    String get _elementSelector => "#${_elementID}";

    /// Hides the dialog and leaves it in the DOM
    Future _hide(final MdlDialogStatus status) {
        _wskDialogContainer.classes.remove(_cssClasses.IS_VISIBLE);
        _wskDialogContainer.classes.add(_cssClasses.IS_HIDDEN);

        return new Future.delayed(new Duration(milliseconds: 200), () {
            _destroy(status);
        });
    }

    /// The dialog gets removed from the DOM
    void _destroy(final MdlDialogStatus status) {
        _logger.info("_destroy - selector ${_containerSelector} brought: $_container");

        if (_element != null) {
            _element.remove();
        }

        dom.document.querySelectorAll(".${_containerClass}").forEach((final dom.Element container) {
//            container.querySelectorAll(_config.rootTagInTemplate).forEach((final dom.Element element) {
//                _logger.info("Element ${element} removed!");
//                if (!element.classes.contains(_cssClasses.WAITING_FOR_CONFIRMATION)) {
//
//                }
//            });

            if (!container.classes.contains(_cssClasses.APPENDING) && container.classes.contains(_cssClasses.IS_DELETABLE)) {
                container.remove();
                _logger.info("Container removed!");
            }

        });

        _config.onCloseCallbacks.forEach((final OnCloseCallback callback) {
            callback(this,status);
        });

        _complete(status);
    }

    /// If there is a container class {dialog} will be added otherwise a container is created
    /// Container class sample: mdl-dialog-container, mdl-toast-container
    dom.DivElement _prepareContainer() {

        dom.HtmlElement container = _container;;
        if(container == null) {
            _logger.info("Container ${_containerClass} not found, create a new one...");
            container = new dom.DivElement();
            container.classes.add(_containerClass);
            container.classes.add(_cssClasses.IS_DELETABLE);
        }
        container.classes.add(_cssClasses.IS_HIDDEN);
        container.classes.remove(_cssClasses.IS_VISIBLE);

        //container.attributes["id"] = _containerID;

        return container;
    }

    void _addBackDropClickListener(final dom.DivElement container) {
        container.onClick.listen((final dom.MouseEvent event) {
            _logger.info("click on container");

            event.preventDefault();
            event.stopPropagation();

            if (event.target == container) {
                close(MdlDialogStatus.CLOSED_BY_BACKDROPCLICK);
            }
        });
    }

    void _addEscListener() {
        _keyboardEventSubscription = dom.document.onKeyDown.listen( (final dom.KeyboardEvent event) {
            event.preventDefault();
            event.stopPropagation();

            if(event.keyCode == 27) {
                close(MdlDialogStatus.CLOSED_BY_ESC);
            }
        });
    }

    void _complete(final MdlDialogStatus status) {
        //Validate.notNull(_completer);
        //Validate.isTrue(_completer.isCompleted == false);
        if(_completer == null) {
            _logger.fine("Completer is null - Status to inform the caller is: $status");
            return;
        }

        if(!_completer.isCompleted) {
            _completer.complete(status);
        }
        _completer = null;
    }

    void _removeEscListener() {
        if(_keyboardEventSubscription != null) {
            _keyboardEventSubscription.cancel();
            _keyboardEventSubscription = null;
        }
    }
}
