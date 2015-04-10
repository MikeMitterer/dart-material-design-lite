part of mdlcore;

const String MDL_WIDGET_PROPERTY = "widget";

MdlComponent mdlComponent(final html.HtmlElement element) {
    var jsElement = new JsObject.fromBrowserObject(element);

    if (!jsElement.hasProperty(MDL_WIDGET_PROPERTY)) {
        throw "$element is not a MdlComponent!!!";
    }
    return (jsElement[MDL_WIDGET_PROPERTY] as MdlComponent);
}

abstract class MdlComponent {
    html.Element element;

    MdlComponent(this.element);

    /**
     * Main element. If there is no chile element like in mdl-button
     *      <button class="mdl-button mdl-js-button">Flat</button>
     * hub = button = element
     *
     * but if there is a child element like in
     *          <label class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="switch-1">
     *              <input type="checkbox" id="switch-1" class="mdl-switch__input" />
     *              <span class="mdl-switch__label">Switch me</span>
     *          </label>
     * hub = input
     */
    html.Element get hub => element;

    html.CssClassSet get classes => element.classes;

    Map<String, String> get attributes => element.attributes;

    html.ElementStream<html.Event> get onChange => hub.onChange;
    html.ElementStream<html.MouseEvent> get onClick => hub.onClick;
}

/// CustomComponents...
abstract class MdlHtmlComponent extends html.HtmlElement implements MdlComponent {
    html.Element element;

    MdlHtmlComponent(this.element) : super.created();

    MdlHtmlComponent.created() : super.created();

    @override
    void click() {
        // TODO: implement click
    }

    @override
    bool get isContentEditable => false;
}

