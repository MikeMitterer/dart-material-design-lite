part of mdlcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialBadgeCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialBadgeCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialBadgeConstant {
    const _MaterialBadgeConstant();
}

/// registration-Helper
void registerMaterialBadge() => componenthandler.register(new MdlWidgetConfig<MaterialBadge>(
    "mdl-js-badge", (final html.HtmlElement element) => new MaterialBadge.fromElement(element)));

class MaterialBadge extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialBadge');

    static const _MaterialBadgeConstant _constant = const _MaterialBadgeConstant();
    static const _MaterialBadgeCssClasses _cssClasses = const _MaterialBadgeCssClasses();

    MaterialBadge.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialBadge widget(final html.HtmlElement element) => mdlComponent(element) as MaterialBadge;

    // Central Element - by default this is where mdl-js-badge was found (element)
    // html.Element get hub => element;

    void set value(final String value) {
        if(value == null || value.isEmpty) {
            element.dataset.remove("badge");
            return;
        }
        element.dataset["badge"] = value;
    }

    String get value => element.dataset.containsKey("badge") ? element.dataset["badge"] : "";

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialBadge - init");
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

