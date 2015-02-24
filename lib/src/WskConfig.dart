part of wskcore;

typedef void WskCallback(final html.HtmlElement element);
typedef WskComponent WskComponentFactory(final html.HtmlElement element);

class WskConfig<T extends WskComponent> {
    final List<WskCallback> callbacks = new List<WskCallback>();

    final WskComponentFactory _componentFactory;
    String cssClass;

    /// The higher the priority the later the component will be upgraded.
    /// This is important for the ripple-effect. Must be called as last upgrade process
    /// Default {priority} is 1, materialRippleConfig sets {priority} to 10
    int priority = 1;

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