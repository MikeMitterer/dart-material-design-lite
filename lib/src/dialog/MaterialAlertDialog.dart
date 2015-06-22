part of mdldialog;

@MdlComponentModel @di.Injectable()
class MaterialAlertDialog extends MaterialDialog {
    final Logger _logger = new Logger('mdldialog.MaterialAlertDialog');

    static const String _DEFAULT_OK_BUTTON = "OK";

    String title = "";
    String text = "";
    String okButton = _DEFAULT_OK_BUTTON;

    MaterialAlertDialog() : super(new DialogConfig());

    MaterialAlertDialog call(final String text,{ final String title: "", final String okButton: _DEFAULT_OK_BUTTON }) {
        Validate.notBlank(text);
        Validate.notNull(title);
        Validate.notBlank(okButton);

        this.text = text;
        this.title = title;
        this.okButton = okButton;
        return this;
    }

    bool get hasTitle => (title != null && title.isNotEmpty);

    // - EventHandler -----------------------------------------------------------------------------

    void onClose() {
        _logger.info("onClose");
        close(MdlDialogStatus.OK);
    }

    // - private ----------------------------------------------------------------------------------

    // - Template ---------------------------------------------------------------------------------

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
              <button class="mdl-button mdl-js-button mdl-button--colored" data-mdl-click="onClose()">
                  {{okButton}}
              </button>
          </div>
        </div>
        """;
}