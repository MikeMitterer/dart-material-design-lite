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

part of mdlremote;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialContentCssClasses {

    final String DYN_CONTENT    = 'mdl-content__adding_content';

    final String LAODING        = 'mdl-content__loading';

    final String LAODED         = 'mdl-content__loaded';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialContentCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialContentConstant {
    const _MaterialContentConstant();
}

/// registration-Helper
void registerMaterialContent() => componenthandler.register(new MdlWidgetConfig<MaterialContent>(
    "mdl-js-content", (final html.HtmlElement element) => new MaterialContent.fromElement(element)));

class MaterialContent extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialContent');

    static const _MaterialContentConstant _constant = const _MaterialContentConstant();
    static const _MaterialContentCssClasses _cssClasses = const _MaterialContentCssClasses();

    MaterialContent.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialContent widget(final html.HtmlElement element) => mdlComponent(element) as MaterialContent;

    // Central Element - by default this is where mdl-js-content was found (element)
    // html.Element get hub => inputElement;

    Future render(final String content) {
        _logger.info("Content: $content");

        final Completer completer = new Completer();

        new Future(() {
            element.classes.remove(_cssClasses.LAODED);
            element.classes.add(_cssClasses.LAODING);

            final html.Element child = new html.Element.html(content,validator: _validator());
            element.childNodes.first.remove();

            child.classes.add(_cssClasses.DYN_CONTENT);
            element.append(child);

            /// check if child is in DOM
            new Timer.periodic(new Duration(milliseconds: 10),(final Timer timer) {

                _logger.info("Check for dyn-content...");
                final html.Element dynContent = element.querySelector(".${_cssClasses.DYN_CONTENT}");

                if( dynContent != null) {
                    timer.cancel();
                    dynContent.classes.remove(_cssClasses.DYN_CONTENT);

                    element.classes.remove(_cssClasses.LAODING);
                    element.classes.add(_cssClasses.LAODED);

                    upgradeAllRegistered().then((_) => completer.complete());
                }
            });
        });

        return completer.future;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialContent - init");
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    html.NodeValidator _validator() {
        final html.NodeValidator validator = new html.NodeValidatorBuilder.common()  // html5 + Templating
            ..allowNavigation()
            ..allowImages()
            ..allowTextElements()
            ..allowInlineStyles()
            ..allowSvg()
            ..add(new _AllowAllAttributesNodeValidator());

        return validator;
    }
}


class _AllowAllAttributesNodeValidator implements html.NodeValidator {

    bool allowsAttribute(html.Element element, String attributeName, String value) {
        if (attributeName == 'is' || attributeName.startsWith('on')) {
            return false;
        }
        return true;
    }

    @override
    bool allowsElement(html.Element element) {
        return true;
    }
}
