/*
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

    static const String MAIN_CLASS  = "mdl-js-accordion";

    final String GROUP              = "mdl-accordion-group";

    final String ACCORDION_TYPE     = "mdl-accordion--radio-type";
    final String NAVIGATION         = "mdl-accordion--navigation";

    final String ACCORDION          = "mdl-accordion";
    final String ACCORDION_LABEL    = "mdl-accordion__label";
    final String RIPPLE_CONTAINER   = 'mdl-accordion__ripple-container';

    final String RIPPLE_EFFECT      = 'mdl-js-ripple-effect';
    final String RIPPLE             = 'mdl-ripple';

    final String LINK               = "mdl-navigation__link";

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
    _MaterialAccordionCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
        => new MaterialAccordion.fromElement(element,injector));

/// registration-Helper
void registerMaterialAccordion() => componentHandler().register(materialAccordionConfig());

/**
 * Sample:
 *   <div class="mdl-accordion-group mdl-js-accordion mdl-js-ripple-effect">
 *    <!-- Panel 1 -->
 *   <div class="mdl-accordion">
 *       <label class="mdl-accordion__label" for="panel-1-check">Panel 1<i class="fa fa-chevron-right indicator"></i></label>
 *       <div class="mdl-accordion--content">
 *           <h5 class="mdl-accordion--header">Header</h5>
 *           <p class="mdl-accordion--body">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto possimus at a cum saepe molestias modi illo facere ducimus voluptatibus praesentium deleniti fugiat ab error quia sit perspiciatis velit necessitatibus.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Lorem ipsum dolor sit amet.</p>
 *       </div>
 *   </div>
 *    <!-- Panel 2 -->
 *   <div class="mdl-accordion">
 *       <label class="mdl-accordion__label" for="panel-2-check">Panel 2<i class="fa fa-chevron-right indicator"></i></label>
 *       <div class="mdl-accordion--content">
 *           <h5 class="mdl-accordion--header">Header</h5>
 *           <p class="mdl-accordion--body">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto possimus at a cum saepe molestias modi illo facere ducimus voluptatibus praesentium deleniti fugiat ab error quia sit perspiciatis velit necessitatibus.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sapiente eligendi nulla illo culpa ab in at adipisci eveniet id itaque maxime soluta recusandae doloribus laboriosam dignissimos est aut cupiditate delectus.</p>
 *       </div>
 *   </div>
 *   </div><!-- .mdl-accordion -->
 */
class MaterialAccordion extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialAccordion');

    static const _MaterialAccordionConstant _constant = const _MaterialAccordionConstant();
    static const _MaterialAccordionCssClasses _cssClasses = const _MaterialAccordionCssClasses();

    dom.HtmlElement _group = null;

    MaterialAccordion.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        //_init();
    }

    static MaterialAccordion widget(final dom.HtmlElement element) => mdlComponent(element,MaterialAccordion) as MaterialAccordion;

    @override
    void attached() {
        _init();
    }
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialAccordion - init");

        bool hasRipples = false;
        if (element != null) {
            if (group.classes.contains(_cssClasses.RIPPLE_EFFECT) ||
                element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {

                group.classes.add(_cssClasses.RIPPLE_EFFECT_IGNORE_EVENTS);
                hasRipples = true;

                element.classes.add(_cssClasses.RIPPLE_EFFECT);
            }

            final bool isRadio = group.classes.contains(_cssClasses.ACCORDION_TYPE);

            //final List<dom.Element> panels = element.querySelectorAll(".${_cssClasses.ACCORDION}");

            // Select element label
            //panels.forEach( (final dom.HtmlElement panel) {
            final dom.HtmlElement panel = element;
                final dom.Element label = panel.querySelector(".${_cssClasses.ACCORDION_LABEL}");

                final String id = "accordion-${label.hashCode}";
                (label as dom.LabelElement).htmlFor = id;

                final dom.CheckboxInputElement inputElement = new dom.CheckboxInputElement();
                if(isRadio) {
                    eventStreams.add(
                        inputElement.onClick.listen((final dom.Event event) {
                            if(inputElement.checked) {
                                _uncheckOthers(inputElement);
                            }
                    }));

                }

                inputElement.name = _groupName;
                inputElement.id = id;

                label.insertAdjacentElement('beforebegin',inputElement);

                if(_isNavigation) {
                    final Uri uri = Uri.parse(dom.document.baseUri.toString());
                    if(uri.fragment.isNotEmpty) {
                        //_logger.info("URI-Fragment: ${uri.fragment}");
                        if(_getLinkFragments(panel).contains(uri.fragment)) {
                            //_logger.info("Checked");
                            inputElement.checked = true;
                        }
                    }
                }

                if(hasRipples) {
                    final dom.SpanElement rippleContainer = new dom.SpanElement();
                    rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
                    rippleContainer.classes.add(_cssClasses.RIPPLE_EFFECT);

                    final dom.SpanElement ripple = new dom.SpanElement();
                    ripple.classes.add(_cssClasses.RIPPLE);
                    rippleContainer.append(ripple);

                    label.append(rippleContainer);
                }

            //});

            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Searches for a parent element with mdl-accordion-group
    dom.HtmlElement get group {
        dom.HtmlElement _findAccordionGroup(final dom.HtmlElement el) {
            if(el == null) {
                throw new ArgumentError("${_MaterialAccordionCssClasses.MAIN_CLASS} must have a ${_cssClasses.GROUP} set!");
            }
            if(el.classes.contains(_cssClasses.GROUP)) {
                return el;
            }
            return _findAccordionGroup(el.parent);
        }
        if(_group == null) {
            _group = _findAccordionGroup(element);
        }
        return _group;
    }

    /// Returns a unique group name
    String get _groupName => "${_constant.CHECKBOX_NAME}-group-${group.hashCode}";

    /// Check if this is a "menu" (if parent has mdl-accordion--navigation set)
    bool get _isNavigation => group.classes.contains(_cssClasses.NAVIGATION);

    List<String> _getLinkFragments(final dom.Element panel) {
        final List<String> fragments = new List<String>();
        final List<dom.Element> links = panel.querySelectorAll(".${_cssClasses.LINK}");

        links.forEach((final dom.Element link) {
            final String href = (link as dom.AnchorElement).href;
            final String fragment = Uri.parse(href).fragment;

            //_logger.info("Href: $href, Fragment: $fragment");
            if(fragment.isNotEmpty) {
                fragments.add(fragment);
            }
        });

        return fragments;
    }

    /// If this is a radio-style-accordion [_uncheckOthers] closes (unchecks) siblings
    void _uncheckOthers(final dom.InputElement elementToExclude) {
        final List<dom.InputElement> checkboxes = group.querySelectorAll("[name=${_groupName}]") as List<dom.InputElement>;
        checkboxes.forEach((final dom.InputElement checkbox) {
            if(checkbox != elementToExclude) {
                checkbox.checked = false;
            }
        });
    }
}

