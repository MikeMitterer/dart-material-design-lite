/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdlcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialAccordionCssClasses {

    final String ACCORDION_TYPE     = "mdl-accordion--radio-type";

    final String ACCORDION_LABEL    = "mdl-accordion__label";
    final String RIPPLE_CONTAINER   = 'mdl-accordion__ripple-container';

    final String RIPPLE_EFFECT      = 'mdl-js-ripple-effect';
    final String RIPPLE             = 'mdl-ripple';

    final String RIPPLE_EFFECT_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';

    final String IS_UPGRADED        = 'is-upgraded';

    const _MaterialAccordionCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialAccordionConstant {

    final String CHECKBOX_NAME      = "mdl-accordion";

    const _MaterialAccordionConstant();
}

/// creates MdlConfig for MaterialAccordion
MdlConfig materialAccordionConfig() => new MdlWidgetConfig<MaterialAccordion>(
    "mdl-js-accordion", (final html.HtmlElement element) => new MaterialAccordion.fromElement(element));

/// registration-Helper
void registerMaterialAccordion() => componenthandler.register(materialAccordionConfig());

/**
 * Sample:
 *   <div class="mdl-accordion-group mdl-js-accordion mdl-js-ripple-effect">
 *    <!-- Panel 1 -->
 *   <div class="mdl-accordion">
 *       <input type="checkbox" name="mdl-accordion" id="panel-1-check">
 *       <label class="mdl-accordion__label" for="panel-1-check">Panel 1<i class="fa fa-chevron-right indicator"></i></label>
 *       <div class="mdl-accordion--content">
 *           <h5 class="mdl-accordion--header">Header</h5>
 *           <p class="mdl-accordion--body">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto possimus at a cum saepe molestias modi illo facere ducimus voluptatibus praesentium deleniti fugiat ab error quia sit perspiciatis velit necessitatibus.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Lorem ipsum dolor sit amet.</p>
 *       </div>
 *   </div>
 *    <!-- Panel 2 -->
 *   <div class="mdl-accordion">
 *       <input type="checkbox" name="mdl-accordion" id="panel-2-check">
 *       <label class="mdl-accordion__label" for="panel-2-check">Panel 2<i class="fa fa-chevron-right indicator"></i></label>
 *       <div class="mdl-accordion--content">
 *           <h5 class="mdl-accordion--header">Header</h5>
 *           <p class="mdl-accordion--body">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto possimus at a cum saepe molestias modi illo facere ducimus voluptatibus praesentium deleniti fugiat ab error quia sit perspiciatis velit necessitatibus.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sapiente eligendi nulla illo culpa ab in at adipisci eveniet id itaque maxime soluta recusandae doloribus laboriosam dignissimos est aut cupiditate delectus.</p>
 *       </div>
 *   </div>
 *    </div><!-- .mdl-accordion -->
 */
class MaterialAccordion extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialAccordion');

    static const _MaterialAccordionConstant _constant = const _MaterialAccordionConstant();
    static const _MaterialAccordionCssClasses _cssClasses = const _MaterialAccordionCssClasses();

    //final List<html.HtmlElement> _labels = new List<html.HtmlElement>();

    MaterialAccordion.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialAccordion widget(final html.HtmlElement element) => mdlComponent(element) as MaterialAccordion;


    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialAccordion - init");

        if (element != null) {
            if (element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
                element.classes.add(_cssClasses.RIPPLE_EFFECT_IGNORE_EVENTS);

                final bool isRadio = element.classes.contains(_cssClasses.ACCORDION_TYPE);

                final List<html.Element> labels = element.querySelectorAll('.' + _cssClasses.ACCORDION_LABEL);

                // Select element label
                labels.forEach( (final html.HtmlElement label) {
                    _logger.fine("Found $label");

                    final String id = "accordion-${label.hashCode}";
                    (label as html.LabelElement).htmlFor = id;

                    html.InputElement inputElement = null;
                    if(isRadio) {
                        inputElement = new html.RadioButtonInputElement();
                    } else {
                        inputElement = new html.CheckboxInputElement();
                    }
                    inputElement.name = "${_constant.CHECKBOX_NAME}-group-${element.hashCode}";
                    inputElement.id = id;
                    label.insertAdjacentElement('beforebegin',inputElement);

                    final html.SpanElement rippleContainer = new html.SpanElement();
                    rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
                    rippleContainer.classes.add(_cssClasses.RIPPLE_EFFECT);

                    final html.SpanElement ripple = new html.SpanElement();
                    ripple.classes.add(_cssClasses.RIPPLE);
                    rippleContainer.append(ripple);

                    label.append(rippleContainer);

                });
            }

            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }
}

