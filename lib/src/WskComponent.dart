part of wskcore;

WskComponent wskComponent(final html.HtmlElement element) {
    var jsElement = new JsObject.fromBrowserObject(element);
    if (!jsElement.hasProperty("widget")) {
        throw "$element is not a WskComponent!!!";
    }
    return (jsElement["widget"] as WskComponent);
}

abstract class WskComponent {
    html.Element element;

    WskComponent(this.element);
}

/// CustomComponents...
abstract class WskHtmlComponent extends html.HtmlElement implements WskComponent {
    html.Element element;

    WskHtmlComponent(this.element) : super.created();
    WskHtmlComponent.created() : super.created();

    @override
    void click() {
        // TODO: implement click
    }

    @override
    bool get isContentEditable => false;
}

