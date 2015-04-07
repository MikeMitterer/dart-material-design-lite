part of wskcore;

const String WSK_WIDGET_PROPERTY = "widget";

WskComponent wskComponent(final html.HtmlElement element) {
    var jsElement = new JsObject.fromBrowserObject(element);

    if (!jsElement.hasProperty(WSK_WIDGET_PROPERTY)) {
        throw "$element is not a WskComponent!!!";
    }
    return (jsElement[WSK_WIDGET_PROPERTY] as WskComponent);
}

abstract class WskComponent {
    html.Element element;

    WskComponent(this.element);

    /**
     * Main element. If there is no chile element like in wsk-button
     *      <button class="wsk-button wsk-js-button">Flat</button>
     * hub = button = element
     *
     * but if there is a child element like in
     *          <label class="wsk-switch wsk-js-switch wsk-js-ripple-effect" for="switch-1">
     *              <input type="checkbox" id="switch-1" class="wsk-switch__input" />
     *              <span class="wsk-switch__label">Switch me</span>
     *          </label>
     * hub = input
     */
    html.Element get hub => element;

    html.CssClassSet get classes => element.classes;

    Map<String, String> get attributes => element.attributes;

    html.ElementStream<html.Event> get onChange => hub.onChange;
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

