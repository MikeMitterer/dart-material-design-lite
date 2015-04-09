part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialAccordionCssClasses {

    final String WSK_ACCORDION_LABEL    = "wsk-accordion__label";
    final String WSK_RIPPLE_CONTAINER   = 'wsk-accordion__ripple-container';

    final String WSK_JS_RIPPLE_EFFECT   = 'wsk-js-ripple-effect';
    final String WSK_RIPPLE             = 'wsk-ripple';

    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    final String IS_UPGRADED            = 'is-upgraded';

    const _MaterialAccordionCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialAccordionConstant {
    const _MaterialAccordionConstant();
}

/// creates WskConfig for MaterialAccordion
WskConfig materialAccordionConfig() => new WskWidgetConfig<MaterialAccordion>(
    "wsk-js-accordion", (final html.HtmlElement element) => new MaterialAccordion.fromElement(element));

/// registration-Helper
void registerMaterialAccordion() => componenthandler.register(materialAccordionConfig());

/**
 * Sample:
 *   <div class="wsk-accordion-group wsk-js-accordion wsk-js-ripple-effect">
 *    <!-- Panel 1 -->
 *   <div class="wsk-accordion">
 *       <input type="checkbox" name="wsk-accordion" id="panel-1-check">
 *       <label class="wsk-accordion__label" for="panel-1-check">Panel 1<i class="fa fa-chevron-right indicator"></i></label>
 *       <div class="wsk-accordion--content">
 *           <h5 class="wsk-accordion--header">Header</h5>
 *           <p class="wsk-accordion--body">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto possimus at a cum saepe molestias modi illo facere ducimus voluptatibus praesentium deleniti fugiat ab error quia sit perspiciatis velit necessitatibus.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Lorem ipsum dolor sit amet.</p>
 *       </div>
 *   </div>
 *    <!-- Panel 2 -->
 *   <div class="wsk-accordion">
 *       <input type="checkbox" name="wsk-accordion" id="panel-2-check">
 *       <label class="wsk-accordion__label" for="panel-2-check">Panel 2<i class="fa fa-chevron-right indicator"></i></label>
 *       <div class="wsk-accordion--content">
 *           <h5 class="wsk-accordion--header">Header</h5>
 *           <p class="wsk-accordion--body">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto possimus at a cum saepe molestias modi illo facere ducimus voluptatibus praesentium deleniti fugiat ab error quia sit perspiciatis velit necessitatibus.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sapiente eligendi nulla illo culpa ab in at adipisci eveniet id itaque maxime soluta recusandae doloribus laboriosam dignissimos est aut cupiditate delectus.</p>
 *       </div>
 *   </div>
 *    </div><!-- .wsk-accordion -->
 */
class MaterialAccordion extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialAccordion');

    static const _MaterialAccordionConstant _constant = const _MaterialAccordionConstant();
    static const _MaterialAccordionCssClasses _cssClasses = const _MaterialAccordionCssClasses();

    //final List<html.HtmlElement> _labels = new List<html.HtmlElement>();

    MaterialAccordion.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialAccordion widget(final html.HtmlElement element) => wskComponent(element) as MaterialAccordion;


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

            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }
}

