part of wskcore;

abstract class WskComponent {
    final html.HtmlElement element;

    WskComponent(this.element) {
        Validate.notNull(element);
    }

}

