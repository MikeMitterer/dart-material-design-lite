part of mdldialog;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialNotificationCssClasses {

    final String WSK_SNACKBAR_CONTAINER = 'mdl-notification__container';

    final String IS_VISIBLE = 'is-visible';
    final String IS_HIDDEN  = 'is-hidden';

    const _MaterialNotificationCssClasses();
}

class _NotificationConfig extends DialogConfig {
    _NotificationConfig() : super(rootTagInTemplate: "mdl-notification",

        closeOnBackDropClick: false,
        autoClosePossible: true,
        appendNewDialog: true

    );
}


/// MaterialNotification
@MdlComponentModel @di.Injectable()
class MaterialNotification extends MaterialDialog {
    final Logger _logger = new Logger('mdldialog.MaterialNotification');

    @override
    String template = """
        <div class="mdl-notification">
            <i class="mdl-icon material-icons mdl-notification__close" data-mdl-click="onClose()">clear</i>
            <span class="mdl-notification__flex">{{text}}</span>
        </div>
    """;

    static const int LONG_DELAY = 10500;
    static const int SHORT_DELAY = 1000;

    String text = "";

    int timeout = LONG_DELAY;

    MaterialNotification() : super(new _NotificationConfig()) {
        _logger.shout("Constructor MaterialNotification");
    }

    MaterialNotification call(final String text) {
        Validate.notBlank(text);

        this.text = text;

        return this;
    }


    // - EventHandler -----------------------------------------------------------------------------

    @override
    Future<MdlDialogStatus> show() {
        return super.show(timeout: new Duration(milliseconds: timeout));
    }

    void onClose() {
        _logger.info("onClose");
        close(MdlDialogStatus.CONFIRMED);
    }

    // - private ----------------------------------------------------------------------------------


}
