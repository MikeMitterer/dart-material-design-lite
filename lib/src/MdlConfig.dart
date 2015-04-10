part of mdlcore;

typedef void MdlCallback(final html.HtmlElement element);

typedef MdlComponent MdlComponentFactory(final html.HtmlElement element);

class MdlConfig<T extends MdlComponent> {
    final List<MdlCallback> callbacks = new List<MdlCallback>();

    final MdlComponentFactory _componentFactory;
    String cssClass;

    /// The higher the priority the later the component will be upgraded.
    /// This is important for the ripple-effect. Must be called as last upgrade process
    /// Default {priority} is 1, materialRippleConfig sets {priority} to 10
    int priority = 1;

    /// Avoids problems with Components and Helpers like MaterialRipple
    final bool isWidget;

    MdlConfig(this.cssClass, T componentFactory(final html.HtmlElement element), { final bool isWidget: false })
    : _componentFactory = componentFactory, this.isWidget = isWidget {

        Validate.isTrue(T != "dynamic", "Add a type-information to your MdlConfig like new MdlConfig<MaterialButton>()");
        Validate.notBlank(cssClass, "cssClass must not be blank.");
        Validate.notNull(_componentFactory);
    }

    String get classAsString => type.toString();

    Type get type => T;

    MdlComponent newComponent(final html.HtmlElement element) {
        return _componentFactory(element);
    }

//- private -----------------------------------------------------------------------------------

}

class MdlWidgetConfig<T extends MdlComponent> extends MdlConfig<T> {
    MdlWidgetConfig(final String cssClass, T componentFactory(final html.HtmlElement element)) :
    super(cssClass, componentFactory, isWidget: true);
}