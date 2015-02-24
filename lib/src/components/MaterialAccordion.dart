part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialAccordionCssClasses {
    final String UPGRADED_CLASS         = 'is-upgraded';

    final String WSK_ACCORDION_LABEL    = "wsk-accordion__label";
    final String WSK_RIPPLE_CONTAINER   = 'wsk-accordion__ripple-container';

    final String WSK_JS_RIPPLE_EFFECT   = 'wsk-js-ripple-effect';
    final String WSK_RIPPLE             = 'wsk-ripple';

    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    const _MaterialAccordionCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialAccordionConstant {
    const _MaterialAccordionConstant();
}

/// creates WskConfig for MaterialAccordion
WskConfig materialAccordionConfig() => new WskConfig<MaterialAccordion>(
    "wsk-js-accordion", (final html.HtmlElement element) => new MaterialAccordion(element));

/// registration-Helper
void registerMaterialAccordion() => componenthandler.register(materialAccordionConfig());

class MaterialAccordion extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialAccordion');

    static const _MaterialAccordionConstant _constant = const _MaterialAccordionConstant();
    static const _MaterialAccordionCssClasses _cssClasses = const _MaterialAccordionCssClasses();

    final List<html.HtmlElement> _labels = new List<html.HtmlElement>();

    MaterialAccordion(final html.HtmlElement element) : super(element) {
        _init();
    }


    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialAccordion - init");

        if (element != null) {
            if (element.classes.contains(_cssClasses.WSK_JS_RIPPLE_EFFECT)) {

                element.classes.add(_cssClasses.WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS);

                final List<html.Element> labels = element.querySelectorAll('.' + _cssClasses.WSK_ACCORDION_LABEL);

                // Select element label
                labels.forEach( (final html.HtmlElement label) {

                    _logger.info("Found $label");

                    final html.SpanElement rippleContainer = new html.SpanElement();
                    rippleContainer.classes.add(_cssClasses.WSK_RIPPLE_CONTAINER);
                    rippleContainer.classes.add(_cssClasses.WSK_JS_RIPPLE_EFFECT);

                    final html.SpanElement ripple = new html.SpanElement();
                    ripple.classes.add(_cssClasses.WSK_RIPPLE);
                    rippleContainer.append(ripple);

                    label.append(rippleContainer);

                });
            }

            element.classes.add(_cssClasses.UPGRADED_CLASS);
        }
    }
}

