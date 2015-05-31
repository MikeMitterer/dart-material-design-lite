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

part of mdlapplication;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _RendererCssClasses {

    final String LOADING        = 'mdl-content__loading';

    final String LOADED         = 'mdl-content__loaded';

    const _RendererCssClasses();
}

typedef void RenderFunction();

/**
 *  Renderer converts a String into HtmlNodes
 *  Needed in mdlremote!
 */
@di.Injectable()
class Renderer {
    final Logger _logger = new Logger('mdlapplication.Renderer');

    static const _RendererCssClasses _cssClasses = const _RendererCssClasses();

    final List<RenderFunction> _renderFunctions = new List<RenderFunction>();

    /// Renders the {content} String - {content} must have ONE! top level element.
    /// If {replaceNode} is false {content} will be added to {element} otherwise th new
    /// {content} replaces the old
    ///
    /// Returns the rendered child
    Future<dom.Element> render(final dom.Element element, final String content,{ final bool replaceNode: true}) {
        //_logger.info("Content: $content");

        final Completer completer = new Completer();

        // add the render-function to the list where the "new Future" can pick it
        _renderFunctions.insert(0, () {

            element.classes.remove(_cssClasses.LOADED);
            element.classes.add(_cssClasses.LOADING);

            final dom.Element child = new dom.Element.html(content,validator: _validator());

            componentFactory().upgradeElement(child).then((_) {

                dom.window.requestAnimationFrame( (_) {

                if(replaceNode && element.childNodes.length > 0 && element.childNodes.last != null) {
                    var oldElement = element.childNodes.last;
                    if(oldElement is dom.Element) {
                        oldElement.style.display = "none";
                    }
                    oldElement.remove();
                    //_logger.info("Old element removed!");
                }

                //element.append(child);
                element.insertAdjacentElement("beforeEnd",child);

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

    dom.NodeValidator _validator() {
        final dom.NodeValidator validator = new dom.NodeValidatorBuilder.common()  // html5 + Templating
            ..allowNavigation()
            ..allowImages()
            ..allowTextElements()
            ..allowInlineStyles()
            ..allowSvg()
            ..add(new _AllowAllAttributesNodeValidator());

        return validator;
    }
}

class _AllowAllAttributesNodeValidator implements dom.NodeValidator {

    bool allowsAttribute(dom.Element element, String attributeName, String value) {
        if (attributeName == 'is' || attributeName.startsWith('on')) {
            return false;
        }
        return true;
    }

    @override
    bool allowsElement(dom.Element element) {
        return true;
    }
}