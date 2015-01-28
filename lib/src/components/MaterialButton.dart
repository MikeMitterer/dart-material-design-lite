part of wskcomponents;

class MaterialButton extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialButton');

    MaterialButton(final html.HtmlElement element) : super(element) {
        init();
    }

    @override
    void init() {
        _logger.info("MaterialButton - init");
    }
}