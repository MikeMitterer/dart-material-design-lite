part of mdldialog;

/// Store strings for class names defined by this component.
class _MaterialNotificationCssClasses {

    final String NOTIFICATION = "mdl-notification";

    const _MaterialNotificationCssClasses();
}

final MdlAnimation shrinkNotification = new MdlAnimation.fromStock(StockAnimation.MoveUpAndDisappear);

class _NotificationConfig extends DialogConfig {
    static const _MaterialNotificationCssClasses _cssClasses = const _MaterialNotificationCssClasses();

    _NotificationConfig() : super(rootTagInTemplate: _cssClasses.NOTIFICATION,

        closeOnBackDropClick: false,
        autoClosePossible: true,
        appendNewDialog: true,
        acceptEscToClose: false,
        closeAnimation: shrinkNotification
    );
}

enum NotificationType {
    DEBUG, INFO, ERROR, WARNING
}

/// MaterialNotification
@MdlComponentModel @di.Injectable()
class MaterialNotification extends MaterialDialog {
    final Logger _logger = new Logger('mdldialog.MaterialNotification');

    static const int LONG_DELAY = 10000;
    static const int SHORT_DELAY = 6500;

    NotificationType type = NotificationType.INFO;

    String title = "";
    String subtitle = "";
    String content = "";

    int timeout = SHORT_DELAY;

    MaterialNotification() : super(new _NotificationConfig()) {
        lambdas["type"] = _notificationType;
    }

    /**
     * [content] must be set, all other params are optional.
     * [type] - defines if the notification is an Error-, Debug-, Info- or Warning-Message
     * [titel] - The notification headline, [subtitle] - the subtitle
     *
     * Sample:
     *
     *     final MaterialNotification notification = new MaterialNotification();
     *
     *     notification("This is my message",type: NotificationType.INFO,title: "Title", subtitle: "Subheadline")
     *     .show().then((final MdlDialogStatus status) {
     *
     *     });
     *
     */
    MaterialNotification call(final String content,
            { final NotificationType type: NotificationType.INFO, final String title: "", final String subtitle: "" } ) {

        Validate.notNull(type,"Notification-Type must not be null!");
        Validate.notNull(title,"Notification-Title must not be null!");
        Validate.notNull(content,"Notification-Content must not be null!");
        Validate.notNull(subtitle,"Notification-Subtitle must not be null!");

        this.type = type;
        this.title = title;
        this.subtitle = subtitle;
        this.content = content;

        if(type == NotificationType.ERROR || type == NotificationType.WARNING) {
            timeout = LONG_DELAY;
        }

        return this;
    }

    bool get hasTitle => title != null && title.isNotEmpty;
    bool get hasSubTitle => subtitle != null && subtitle.isNotEmpty;
    bool get hasContent => content != null && content.isNotEmpty;

    // - EventHandler -----------------------------------------------------------------------------

    @override
    // TODO: Params are not used - change parent function...
    Future<MdlDialogStatus> show({ final Duration timeout,void dialogIDCallback(final String dialogId) }) {
        return super.show(timeout: new Duration(milliseconds: this.timeout));
        //return super.show();
    }

    void onClose() {
        _logger.info("onClose - Notification");
        close(MdlDialogStatus.CONFIRMED);
    }

    // - private ----------------------------------------------------------------------------------

    String _notificationType(_) {

        switch(type) {
            case NotificationType.DEBUG:
                return "debug";

            case NotificationType.INFO:
                return "info";

            case NotificationType.WARNING:
                return "warning";

            case NotificationType.ERROR:
                return "error";

            default:
                return "info";
        }
    }

    // - Template ---------------------------------------------------------------------------------

    @override
    String template = """
    <div class="mdl-notification mdl-notification--{{lambdas.type}} mdl-shadow--3dp">
            <i class="mdl-icon material-icons mdl-notification__close" data-mdl-click="onClose()">clear</i>
            <div class="mdl-notification__content">
            {{#hasTitle}}
            <div class="mdl-notification__title">
                <div class="mdl-notification__avatar material-icons"></div>
                <div class="mdl-notification__headline">
                    <h1>{{title}}</h1>
                    {{#hasSubTitle}}
                        <h2>{{subtitle}}</h2>
                    {{/hasSubTitle}}
                </div>
            </div>
            {{/hasTitle}}
            {{#hasContent}}
                <div class="mdl-notification__text">
                {{^hasTitle}}
                    <span class="mdl-notification__avatar material-icons"></span>
                {{/hasTitle}}
                <span>
                    {{content}}
                </span>
                </div>
            {{/hasContent}}
            </div>
    </div>
    """;
}
