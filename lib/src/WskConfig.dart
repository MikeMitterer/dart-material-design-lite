part of wskcore;

typedef void WskCallback(final html.HtmlElement element);
typedef WskComponent WskComponentFactory(final html.HtmlElement element);

class WskConfig<T extends WskComponent> {
    final List<WskCallback> callbacks = new List<WskCallback>();

    final WskComponentFactory _componentFactory;
    String cssClass;

    WskConfig(this.cssClass,T componentFactory(final html.HtmlElement element))
        : _componentFactory = componentFactory {

        Validate.isTrue(T != "dynamic","Add a type-information to your WscConfig like new WskConfig<MaterialButton>()");
        Validate.notBlank(cssClass,"cssClass must not be blank.");
        Validate.notNull(_componentFactory);
    }


    String      get classAsString => type.toString();
    Type        get type => T;

    WskComponent newComponent(final html.HtmlElement element) {
        return _componentFactory(element);
    }

    //- private -----------------------------------------------------------------------------------

}