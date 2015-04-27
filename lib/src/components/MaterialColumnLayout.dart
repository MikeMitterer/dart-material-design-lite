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
class _MaterialColumnLayoutCssClasses {
    final String INVISIBLE_WRAPPING_ELEMENT = 'mdl-column-layout__wrap-hack';

    const _MaterialColumnLayoutCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialColumnLayoutConstant {
    final int INVISIBLE_WRAPPING_ELEMENT_COUNT = 3;

    const _MaterialColumnLayoutConstant();
}

/// creates MdlConfig for MaterialColumnLayout
MdlConfig materialColumnsLayoutConfig() => new MdlWidgetConfig<MaterialColumnLayout>(
    "mdl-column-layout", (final dom.HtmlElement element) => new MaterialColumnLayout.fromElement(element));

/// registration-Helper
void registerMaterialColumnLayout() => componenthandler.register(materialColumnsLayoutConfig());

class MaterialColumnLayout extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialColumnLayout');

    static const _MaterialColumnLayoutConstant _constant = const _MaterialColumnLayoutConstant();
    static const _MaterialColumnLayoutCssClasses _cssClasses = const _MaterialColumnLayoutCssClasses();

    MaterialColumnLayout.fromElement(final dom.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialColumnLayout widget(final dom.HtmlElement element) => mdlComponent(element) as MaterialColumnLayout;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialColumnLayout - init");

        if (element != null) {
            // Add some hidden elements to make sure everything aligns correctly. See
            // CSS file for details.

            for (int j = 0; j < _constant.INVISIBLE_WRAPPING_ELEMENT_COUNT ; j++) {

                final dom.DivElement hiddenHackDiv = new dom.DivElement();
                hiddenHackDiv.classes.add(_cssClasses.INVISIBLE_WRAPPING_ELEMENT);
                element.append(hiddenHackDiv);
            }
        }

    }
}

