part of mdldialog;

enum MdlDialogStatus {
    CLOSED_BY_ESC, CLOSED_BY_BACKDROPCLICK,
    CLOSED_ON_TIMEOUT, CLOSED_VIA_NEXT_SHOW,
    OK,
    YES, NO,
    CANCEL,

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

    /// In most cased a newly created Dialog replaces the previous one. This
    /// is not the case, for example, with Notifications
    final bool appendNewDialog;

    /// Sets the [MdlAnimation] if the user clicks on close or if the dialog has and "auto-close" timer
    final MdlAnimation closeAnimation;

    DialogConfig({ final String rootTagInTemplate: "mdl-dialog",
                   final bool closeOnBackDropClick: true,
                   final bool acceptEscToClose: true,
                   final String parentSelector: _DEFAULT_PARENT_SELECTOR,
                   final bool autoClosePossible: false,
                   final bool appendNewDialog: false,
                   final MdlAnimation closeAnimation: null })

    : this.rootTagInTemplate = rootTagInTemplate,
      this.closeOnBackDropClick = closeOnBackDropClick,
      this.acceptEscToClose = acceptEscToClose,
      this.parentSelector = parentSelector,
      this.autoClosePossible = autoClosePossible,
      this.appendNewDialog = appendNewDialog,
      this.closeAnimation = closeAnimation {

        Validate.notBlank(rootTagInTemplate);
    }
}

/// HTML-Part of MdlDialog.
abstract class MaterialDialog extends Object with TemplateComponent implements ScopeAware {
    final Logger _logger = new Logger('mdldialog.DialogElement');

    static const _MaterialDialogCssClasses _cssClasses = const _MaterialDialogCssClasses();

    static int idCounter = 0;
    int _autoIncrementID = 0;

    /// AutoClose-Timer
    Timer _autoCloseTimer = null;

    /// usually the html body
    dom.Element _parent;

    /// Wraps wskDialogElement. Darkens the background and
    /// is used for backdrop click
    dom.DivElement _dialogContainer;

    /// Informs about open and close actions
    Completer<MdlDialogStatus> _completer = null;

    /// Listens to Keyboard-Events
    StreamSubscription _keyboardEventSubscription;

    /// Configuration for this DialogElement
    final DialogConfig _config;

    Scope _scope;

    MaterialDialog(this._config) {
        Validate.notNull(_config);
        _scope = new Scope(this,null);
    }

    /// The returned Future informs about how the dialog was closed
    /// If {timeout} is set - the corresponding dialog closes automatically after this period
    /// The callback {dialogIDCallback} can be given to find out the dialogID - useful for Toast that needs confirmation
    Future<MdlDialogStatus> show({ final Duration timeout,void dialogIDCallback(final String dialogId) }) {
        Validate.isTrue(_completer == null || _completer.isCompleted);

        _logger.fine("start MaterialDialog#show...");

        _completer = new Completer<MdlDialogStatus>();

        _parent = dom.document.querySelector(_config.parentSelector);

        _dialogContainer = _prepareContainer();

        if(_config.closeOnBackDropClick) {
            _addBackDropClickListener(_dialogContainer);
        }

        _dialogContainer.classes.add(_cssClasses.APPENDING);

        if (_parent.querySelector(".${_containerClass}") == null) {
            _parent.append(_dialogContainer);
        }

        // Now - add the template into the _dialogContainer
        _renderer.render().then( (_) {
            // _autoIncrementID must be on top of this block! - will be used by _elementID
            _autoIncrementID = idCounter;

            final dom.HtmlElement dialog = _dialogContainer.children.last;
            dialog.id = _elementID;

            // notification + snackbar is not _MaterialDialogComponent
            if(isMdlComponent(dialog,MaterialDialogComponent)) {
                final MaterialDialogComponent dialogComponent = MaterialDialogComponent.widget(dialog);

                Validate.notNull(dialogComponent,"${dialog} must be a '_MaterialDialogComponent' (mdl-dialog class)");

                dialogComponent.parentScope = this;
            }

            if(dialogIDCallback != null) {
                dialogIDCallback(hashCode.toString());
            }

            _dialogContainer.classes.remove(_cssClasses.IS_HIDDEN);
            _dialogContainer.classes.add(_cssClasses.IS_VISIBLE);
            _dialogContainer.classes.remove(_cssClasses.APPENDING);

            if(_config.acceptEscToClose) {
                _addEscListener();
            }
            if(timeout != null && _config.autoClosePossible == true) {
                _startTimeoutTimer(timeout);
            }

            final dom.HtmlElement elementWithAutoFocus = dialog.querySelector("[autofocus]");
            if(elementWithAutoFocus != null) {
                elementWithAutoFocus.focus();
            }

            idCounter++;
            _logger.fine("show end (Dialog is rendered, got ID: ${_elementID})!");
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

    String get id => hashCode.toString();

    bool get hasTimer => _autoCloseTimer != null && _autoCloseTimer.isActive;
    bool get hasNoTimer => !hasTimer;
    bool get isAutoCloseEnabled => hasTimer;

    /// scope is read only
    Scope get scope => _scope;

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

    String get _elementID => "mdl-element-${hashCode.toString()}-${_autoIncrementID}";

    /// identifies the element
    /// <mdl-dialog id="xxxxx">...</mdl-dialog>
    String get _elementSelector => "#${_elementID}";

    /// Hides the dialog and leaves it in the DOM
    Future _hide(final MdlDialogStatus status) {

        // is null if no other Dialog is open
        if(_dialogContainer != null && _dialogContainer.children.length == 0) {
            _dialogContainer.classes.remove(_cssClasses.IS_VISIBLE);
            _dialogContainer.classes.add(_cssClasses.IS_HIDDEN);
        }

        if(_config.closeAnimation != null && _element != null) {

            final MdlAnimation animation = _config.closeAnimation;
            return animation(_element).then((_) => _destroy(status));

        } else {
            return new Future.delayed(new Duration(milliseconds: 200), () {
                return _destroy(status);
            });
        }
    }

    /// The dialog gets removed from the DOM
    Future _destroy(final MdlDialogStatus status) async {
        _logger.fine("_destroy - selector .${_containerClass} brought: $_container");

        /// Check if there is a pending container - it there is one, destroy it!
        void _destroyContainer() {
            dom.document.querySelectorAll(".${_containerClass}").forEach( (final dom.Element container) {

                if (!container.classes.contains(_cssClasses.APPENDING)
                    && container.classes.contains(_cssClasses.IS_DELETABLE) && container.children.length == 0) {
                    container.remove();
                    _logger.fine("Container removed!");
                }

            });
        }

        void _callCallbacksAndQuit() {
            _config.onCloseCallbacks.forEach((final OnCloseCallback callback) {
                callback(this,status);
            });

            _complete(status);
        }

        if (_element != null) {

            await componentFactory().downgradeElement(_element);

            final String id = _element.id;
            _element.remove();
            _logger.fine("Element removed! (ID: ${id})");

            _destroyContainer();
            _callCallbacksAndQuit();
            _logger.fine("${this} is destroyd!");

        } else {

            _logger.info("Could not find element with ID: ${_elementSelector}");
            _destroyContainer();
            _callCallbacksAndQuit();
        }
    }

    /// If there is a container class {dialog} will be added otherwise a container is created
    /// Container class sample: mdl-dialog-container, mdl-toast-container, mdl-notification-container
    dom.DivElement _prepareContainer() {

        dom.HtmlElement container = _container;;
        if(container == null) {
            _logger.fine("Container ${_containerClass} not found, creating a new one...");
            container = new dom.DivElement();
            container.classes.add(_containerClass);
            container.classes.add(_cssClasses.IS_DELETABLE);
        }

        if(container.children.length == 0) {
            container.classes.add(_cssClasses.IS_HIDDEN);
            container.classes.remove(_cssClasses.IS_VISIBLE);
        }

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

            if(event.keyCode == 27) {

                event.preventDefault();
                event.stopPropagation();

                close(MdlDialogStatus.CLOSED_BY_ESC);
            }
        });
    }

    void _complete(final MdlDialogStatus status) {

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

    Renderer get _renderer {
        final TemplateRenderer templateRenderer = componentFactory().injector.get(TemplateRenderer);
        templateRenderer.appendNewNodes = _config.appendNewDialog;

        final Renderer renderer = templateRenderer.call(_dialogContainer,this,() => template);
        return renderer;
    }

}
