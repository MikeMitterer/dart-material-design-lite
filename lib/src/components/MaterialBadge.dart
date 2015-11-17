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
class _MaterialBadgeCssClasses {
    static const String MAIN_CLASS  = "mdl-js-badge";

    final String IS_UPGRADED        = 'is-upgraded';

    const _MaterialBadgeCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialBadgeConstant {
    const _MaterialBadgeConstant();
}

/// creates MdlConfig for MaterialBadge
MdlConfig materialBadgeConfig() => new MdlWidgetConfig<MaterialBadge>(
    _MaterialBadgeCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
        => new MaterialBadge.fromElement(element,injector));

/// registration-Helper
void registerMaterialBadge() => componentHandler().register(materialBadgeConfig());

class MaterialBadge extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialBadge');

    static const _MaterialBadgeConstant _constant = const _MaterialBadgeConstant();
    static const _MaterialBadgeCssClasses _cssClasses = const _MaterialBadgeCssClasses();

    MaterialBadge.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialBadge widget(final dom.HtmlElement element) => mdlComponent(element,MaterialBadge) as MaterialBadge;

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

