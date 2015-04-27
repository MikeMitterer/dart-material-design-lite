part of mdldialog;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialToastCssClasses {

    final String WSK_TOAST_CONTAINER = 'mdl-toast__container';

    final String IS_VISIBLE = 'is-visible';
    final String IS_HIDDEN  = 'is-hidden';

    const _MaterialToastCssClasses();
}

class _ToastConfig extends DialogConfig {
    _ToastConfig() : super(rootTagInTemplate: "mdl-toast",
        closeOnBackDropClick: false,
        autoClosePossible: true);
}

/// Position on Screen or in container
class ToastPosition {
    bool _top = true;
    bool _right = true;
    bool _bottom = false;
    bool left = false;

    bool get top => _top || bottom ? _top : true;
    bool get right => _right || left ? _right : true;
    bool get bottom => _bottom && _top ? false : _bottom;

    set top(bool value) => _top = value;
    set bottom(bool value) => _bottom = value;
    set right(bool value) => _right = value;
}

/// WskToastComponent
class MaterialToast extends MaterialDialog {
    final Logger _logger = new Logger('mdldialog.MaterialToast');

    static const String DEFAULT_CONFIRM_BUTTON = "OK";

    @override
    String template = """
        <div class="mdl-toast {{lambdas.classes}}">
            <span class="mdl-toast__flex">{{text}}</span>
            {{#hasConfirmButton}}
                <button class="mdl-button mdl-js-button mdl-button--colored" data-mdl-click="onClose()" autofocus>
                    {{confirmButton}}
                </button>
            {{/hasConfirmButton}}
        </div>
    """.trim().replaceAll(new RegExp(r"\s+")," ");

    static const int LONG_DELAY = 3500;
    static const int SHORT_DELAY = 2000;

    /// If Toast has a confirmButton this is set to a valid dialog-ID
    String _confirmationID = "";

    /// Position on Screen or in container
    final ToastPosition position = new ToastPosition();

    String text = "";
    String confirmButton = "";

    int timeout = SHORT_DELAY;

    MaterialToast() : super(new _ToastConfig()) {
        _config.onCloseCallbacks.add(_onCloseCallback);
        lambdas["classes"] = _toastClasses;
    }

    MaterialToast call(final String text, { final String confirmButton: "" }) {
        Validate.notBlank(text);
        Validate.notNull(confirmButton);
        Validate.isTrue(_confirmationID.isEmpty,"One Toast waits for confirmation, but the next one is already in the queue! ($_confirmationID)");

        this.text = text;
        this.confirmButton = confirmButton;

        _logger.info("Confirm: ${this.confirmButton}");
        return this;
    }

    /// The current Toast waits for user interaction
    bool get waitingForConfirmation => _confirmationID.isNotEmpty;

    /// The template checks it it should show a button or not
    bool get hasConfirmButton => confirmButton != null && confirmButton.isNotEmpty;

    @override
    /// if there is already a Toast open - it will be closed
    Future<MdlDialogStatus> show({ Duration timeout, void dialogIDCallback(final String dialogId) }) {
        Validate.isTrue(!waitingForConfirmation,"There is alread a Toast waiting for confirmation!!!!");

        return close(MdlDialogStatus.CLOSED_VIA_NEXT_SHOW).then( (_) {

            if(!hasConfirmButton) {
                if(timeout == null) {
                    timeout = new Duration(milliseconds: SHORT_DELAY);
                }
                return super.show(timeout: timeout);
            }

            return super.show(dialogIDCallback: _setConfirmationID );
        });
    }

    // - EventHandler -----------------------------------------------------------------------------

    void onClose() {
        Validate.notBlank(_confirmationID, "onClose must have a _confirmationID set - but was blank");

        _logger.info("onClose");
        close(MdlDialogStatus.CONFIRMED);
    }

    // - private ----------------------------------------------------------------------------------

    void _onCloseCallback(final MaterialDialog dialogElement, final MdlDialogStatus status) {
        _logger.info("onCloseCallback, ID: ${dialogElement.id}, $status, ConfirmationID: $_confirmationID");
        if(_confirmationID.isNotEmpty && dialogElement.id == _confirmationID) {
            _clearConfirmationCheck();
        }
    }

    /// Its important to know the ID of the dialog that needs a confirmation - otherwise another
    /// dialog could reset the {_needsConfirmation} flag
    void _setConfirmationID(final String id) {
        Validate.notBlank(id);
        _confirmationID = id;
    }

    void _clearConfirmationCheck() {
        _confirmationID = "";
    }

    String _toastClasses(_) {
        final List<String> classes = new List<String>();

        void _addIf(final List<String> classes,final bool check,final String classToAdd) {
            if(check) {
                classes.add(classToAdd);
            }
        }

        _addIf(classes,position.top,"mdl-toast--top");
        _addIf(classes,position.right,"mdl-toast--right");
        _addIf(classes,position.left,"mdl-toast--left");
        _addIf(classes,position.bottom,"mdl-toast--bottom");

        _addIf(classes,waitingForConfirmation,"waiting-for-confirmation");

        return classes.join(" ");
    }
}
        