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
class _RendererCssClasses {

    final String LOADING        = 'mdl-content__loading';

    final String LOADED         = 'mdl-content__loaded';

    const _RendererCssClasses();
}

typedef void RenderFunction();

/// Renderer converts a String into HtmlNodes
class Renderer {
    final Logger _logger = new Logger('mdlremote.Renderer');

    static const _RendererCssClasses _cssClasses = const _RendererCssClasses();

    final List<RenderFunction> _renderFunctions = new List<RenderFunction>();

    /// Renders the {content} String - {content} must have ONE! top level element.
    /// If {replaceNode} is false {content} will be added to {element} otherwise th new
    /// {content} replaces the old
    ///
    /// Returns the rendered child
    Future<html.Element> render(final html.Element element, final String content,{ final bool replaceNode: true}) {
        //_logger.info("Content: $content");

        final Completer completer = new Completer();

        // add the render-function to the list where the "new Future" can pick it
        _renderFunctions.insert(0, () {

            element.classes.remove(_cssClasses.LOADED);
            element.classes.add(_cssClasses.LOADING);

            final html.Element child = new html.Element.html(content,validator: _validator());

            componenthandler.upgradeElement(child).then((_) {

                html.window.requestAnimationFrame( (_) {

                if(replaceNode && element.childNodes.length > 0 && element.childNodes.first != null) {
                    var oldElement = element.childNodes.first;
                    if(oldElement is html.Element) {
                        oldElement.style.display = "none";
                    }
                    oldElement.remove();
                }

                element.append(child);

                element.classes.remove(_cssClasses.LOADING);
                element.classes.add(_cssClasses.LOADED);

                completer.complete(child);
                });

            });

        });

        new Future(() {
            final RenderFunction renderfunction = _renderFunctions.last;
            _renderFunctions.remove(renderfunction);
            renderfunction();
        });

        return completer.future;
    }

    //- private -----------------------------------------------------------------------------------

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