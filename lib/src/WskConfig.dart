part of wskcore;

typedef void WskCallback(final html.HtmlElement element);

class WskConfig<T extends WskComponent> {
    final List<WskCallback> callbacks = new List<WskCallback>();

    ClassMirror _clazz;
    String cssClass;

    WskConfig() {
        Validate.isTrue(T != "dynamic","Add a type-information to your WscConfig like new WskConfig<MaterialButton>()");

        _clazz = reflectClass(T);
        cssClass = _getAnnotation(_clazz);
        Validate.notBlank(cssClass,"cssClass must not be null. " +
            "Check if you have annotated ${T} with @WskCssClass('css-class')");
    }

    WskConfig.withClass(this.cssClass) {
        Validate.isTrue(T != "dynamic","Add a type-information to your WscConfig like new WskConfig<MaterialButton>()");
        Validate.notBlank(cssClass);

        _clazz = reflectClass(T);
    }

    String      get classAsString => type.toString();
    Type        get type => T;
    ClassMirror get clazz => _clazz;

    //- private -----------------------------------------------------------------------------------

    String _getAnnotation(final DeclarationMirror declaration) {
        final Type annotation = WskCssClass;
        for (var instance in declaration.metadata) {
            if (instance.hasReflectee) {
                var reflectee = instance.reflectee;
                if (reflectee.runtimeType == annotation) {
                    return (reflectee as WskCssClass).name;
                }
            }
        }

        return "";
    }
}