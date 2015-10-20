part of mdldialog;

// Store strings for class names defined by this component that are used in
// Dart. This allows us to simply change it in one place should we
// decide to modify at a later date.
//class _MaterialSnackbarCssClasses {
//
//    final String WSK_SNACKBAR_CONTAINER = 'mdl-snackbar__container';
//
//    final String IS_VISIBLE = 'is-visible';
//    final String IS_HIDDEN  = 'is-hidden';
//
//    const _MaterialSnackbarCssClasses();
//}

class _SnackbarConfig extends DialogConfig {
    _SnackbarConfig() : super(rootTagInTemplate: "mdl-snackbar",
    closeOnBackDropClick: false,
    autoClosePossible: true);
}


/// Position on Screen or in container
class SnackbarPosition {
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

/// MaterialSnackbarComponent
@MdlComponentModel @di.Injectable()
class MaterialSnackbar extends MaterialDialog {
    final Logger _logger = new Logger('mdldialog.MaterialSnackbar');

    static const String DEFAULT_CONFIRM_BUTTON = "OK";

    @override
    String template = """
        <div class="mdl-snackbar {{lambdas.classes}}">
            <span class="mdl-snackbar__flex">{{text}}</span>
            {{#hasConfirmButton}}
                <button class="mdl-button mdl-js-button mdl-button--colored" data-mdl-click="onClose()" autofocus>
                    {{confirmButton}}
                </button>
            {{/hasConfirmButton}}
        </div>
    """;

    static const int LONG_DELAY = 3500;
    static const int SHORT_DELAY = 2000;

    /// If Snackbar has a confirmButton this is set to a valid dialog-ID
    String _confirmationID = "";

    /// Position on Screen or in container
    final SnackbarPosition position = new SnackbarPosition();

    String text = "";
    String confirmButton = "";

    int timeout = SHORT_DELAY;

    MaterialSnackbar() : super(new _SnackbarConfig()) {
        _config.onCloseCallbacks.add(_onCloseCallback);
        lambdas["classes"] = _snackbarClasses;
    }

    MaterialSnackbar call(final String text, { final String confirmButton: "" }) {
        Validate.notBlank(text);
        Validate.notNull(confirmButton);
        Validate.isTrue(_confirmationID.isEmpty,"A Snackbar waits for confirmation, but the next one is already in the queue! ($_confirmationID)");

        this.text = text;
        this.confirmButton = confirmButton;

        return this;
    }

    /// The current Snackbar waits for user interaction
    bool get waitingForConfirmation => _confirmationID.isNotEmpty;

    /// The template checks it it should show a button or not
    bool get hasConfirmButton => confirmButton != null && confirmButton.isNotEmpty;

    @override
    /// if there is already a Snackbar open - it will be closed
    Future<MdlDialogStatus> show({ Duration timeout, void dialogIDCallback(final String dialogId) }) {
        Validate.isTrue(!waitingForConfirmation,"There is alread a Snackbar waiting for confirmation!!!!");

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

        close(MdlDialogStatus.CONFIRMED);
    }

    // - private ----------------------------------------------------------------------------------

    void _onCloseCallback(final MaterialDialog dialogElement, final MdlDialogStatus status) {
        _logger.fine("onCloseCallback, ID: ${dialogElement.id}, $status, ConfirmationID: $_confirmationID");
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

    String _snackbarClasses(_) {
        final List<String> classes = new List<String>();

        void _addIf(final List<String> classes,final bool check,final String classToAdd) {
            if(check) {
                classes.add(classToAdd);
            }
        }

        _addIf(classes,position.top,"mdl-snackbar--top");
        _addIf(classes,position.right,"mdl-snackbar--right");
        _addIf(classes,position.left,"mdl-snackbar--left");
        _addIf(classes,position.bottom,"mdl-snackbar--bottom");

        _addIf(classes,waitingForConfirmation,"waiting-for-confirmation");

        return classes.join(" ");
    }
}
