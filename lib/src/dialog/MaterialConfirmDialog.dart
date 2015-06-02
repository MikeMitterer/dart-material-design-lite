part of mdldialog;

@MdlComponentModel  @di.Injectable()
class MdlConfirmDialog extends MaterialDialog {
    final Logger _logger = new Logger('mdldialog.MdlConfirmDialog');

    static const String _DEFAULT_YES_BUTTON = "Yes";
    static const String _DEFAULT_NO_BUTTON = "No";

    @override
    String template = """
        <div class="mdl-dialog">
          <div class="mdl-dialog__content">
            {{#hasTitle}}
            <h5>{{title}}</h5>
            {{/hasTitle}}
            <p>{{text}}</p>
          </div>
          <div class="mdl-dialog__actions" layout="row">
              <button class="mdl-button mdl-js-button" data-mdl-click="onNo()">
                  {{noButton}}
              </button>
              <button class="mdl-button mdl-js-button mdl-button--colored" data-mdl-click="onYes()">
                  {{yesButton}}
              </button>
          </div>
        </div>
        """;


    String title = "";
    String text = "";
    String yesButton = _DEFAULT_YES_BUTTON;
    String noButton = _DEFAULT_NO_BUTTON;

    MdlConfirmDialog() : super(new DialogConfig());

    MdlConfirmDialog call(final String text,{ final String title: "",
        final String yesButton: _DEFAULT_YES_BUTTON, final String noButton: _DEFAULT_NO_BUTTON }) {
        Validate.notBlank(text);
        Validate.notNull(title);
        Validate.notBlank(yesButton);
        Validate.notBlank(noButton);

        this.text = text;
        this.title = title;
        this.yesButton = yesButton;
        this.noButton = noButton;

        return this;
    }

    bool get hasTitle => (title != null && title.isNotEmpty);

    // - EventHandler -----------------------------------------------------------------------------

    void onYes() {
        close(MdlDialogStatus.YES);
    }

    void onNo() {
        close(MdlDialogStatus.NO);
    }

    // - private ----------------------------------------------------------------------------------

}