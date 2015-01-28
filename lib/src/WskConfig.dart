part of wskcore;

typedef void WskCallback(final html.HtmlElement element);

class WskConfig<T extends WskComponent> {
    final String cssClass;
    final List<WskCallback> callbacks = new List<WskCallback>();

    WskConfig(this.cssClass) {
        Validate.notBlank(cssClass);
    }

    String get classAsString => type.toString();
    Type get type => T;
}