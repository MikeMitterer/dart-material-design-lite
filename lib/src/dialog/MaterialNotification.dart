part of mdldialog;

/// Store strings for class names defined by this component.
class _MaterialNotificationCssClasses {

    final String NOTIFICATION = "mdl-notification";

    const _MaterialNotificationCssClasses();
}

class _NotificationConfig extends DialogConfig {
    static const _MaterialNotificationCssClasses _cssClasses = const _MaterialNotificationCssClasses();

    _NotificationConfig() : super(rootTagInTemplate: _cssClasses.NOTIFICATION,

        closeOnBackDropClick: false,
        autoClosePossible: true,
        appendNewDialog: true

    );
}

enum NotificationType {
    DEBUG, INFO, ERROR, WARNING
}

/// MaterialNotification
@MdlComponentModel @di.Injectable()
class MaterialNotification extends MaterialDialog {
    final Logger _logger = new Logger('mdldialog.MaterialNotification');

    static const int LONG_DELAY = 6500;
    static const int SHORT_DELAY = 3000;

    NotificationType type = NotificationType.INFO;

    String title = "";
    String subtitle = "";
    String content = "";

    int timeout = SHORT_DELAY;

    MaterialNotification() : super(new _NotificationConfig()) {
        lambdas["type"] = _notificationType;
    }

    MaterialNotification call(final String title, final String content,
            { final NotificationType type: NotificationType.INFO, final String subtitle: "" } ) {

        Validate.notNull(type);
        Validate.notBlank(title);
        Validate.notNull(content);
        Validate.notNull(subtitle);

        this.type = type;
        this.title = title;
        this.subtitle = subtitle;
        this.content = content;

        if(type == NotificationType.ERROR) {
            timeout = LONG_DELAY;
        }

        return this;
    }

    bool get hasSubTitle => subtitle != null && subtitle.isNotEmpty;
    bool get hasContent => content != null && content.isNotEmpty;

    // - EventHandler -----------------------------------------------------------------------------

    @override
    Future<MdlDialogStatus> show() {
        return super.show(timeout: new Duration(milliseconds: timeout));
    }

    void onClose() {
        _logger.info("onClose - Notification");
        close(MdlDialogStatus.CONFIRMED);
    }

    // - private ----------------------------------------------------------------------------------

    String _notificationType(_) {
        return type.toString().replaceFirst("${type.runtimeType.toString()}.","").toLowerCase();
    }

    // - Template ---------------------------------------------------------------------------------

    @override
    String template = """
    <div class="mdl-notification mdl-notification--{{lambdas.type}} mdl-shadow--2dp">
            <i class="mdl-icon material-icons mdl-notification__close" data-mdl-click="onClose()">clear</i>
            <div class="mdl-notification__content">
            <div class="mdl-notification__title">
                <div class="mdl-notification__avatar material-icons"></div>
                <div class="mdl-notification__headline">
                    <h1>{{title}}</h1>
                    {{#hasSubTitle}}
                        <h2>{{subtitle}}</h2>
                    {{/hasSubTitle}}
                </div>
            </div>
            {{#hasContent}}
                <div class="mdl-notification__text">
                    {{content}}
                </div>
            {{/hasContent}}
            </div>
    </div>
    """;
}
