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
class _MaterialItemCssClasses {

    final String MDL_ITEM_RIPPLE_CONTAINER = 'mdl-item--ripple-container';
    final String MDL_RIPPLE = 'mdl-ripple';

    const _MaterialItemCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialItemConstant {
    const _MaterialItemConstant();
}

/// creates MdlConfig for MaterialItem
MdlConfig materialItemConfig() => new MdlWidgetConfig<MaterialItem>(
    "mdl-item", (final html.HtmlElement element) => new MaterialItem.fromElement(element));

/// registration-Helper
void registerMaterialItem() => componenthandler.register(materialItemConfig());

class MaterialItem extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialItem');

    static const _MaterialItemConstant _constant = const _MaterialItemConstant();
    static const _MaterialItemCssClasses _cssClasses = const _MaterialItemCssClasses();

    MaterialItem.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialItem widget(final html.HtmlElement element) => mdlComponent(element) as MaterialItem;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialItem - init");

        if (element != null) {

            final html.SpanElement rippleContainer = new html.SpanElement();
            rippleContainer.classes.add(_cssClasses.MDL_ITEM_RIPPLE_CONTAINER);

            final html.SpanElement ripple = new html.SpanElement();
            ripple.classes.add(_cssClasses.MDL_RIPPLE);
            rippleContainer.append(ripple);

            element.append(rippleContainer);
        }

    }
}

