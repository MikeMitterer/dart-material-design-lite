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

part of mdlapplication;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _RendererCssClasses {

    final String LOADING        = 'mdl-content__loading';

    final String LOADED         = 'mdl-content__loaded';

    const _RendererCssClasses();
}

typedef void _DomRenderFunction();

/**
 *  DomRenderer converts a String into HtmlNodes
 *
 */
@di.Injectable()
class DomRenderer {
    final Logger _logger = new Logger('mdlapplication.DomRenderer');

    static const _RendererCssClasses _cssClasses = const _RendererCssClasses();

    final List<_DomRenderFunction> _renderFunctions = new List<_DomRenderFunction>();

    /// Renders the {content} String into the given {parent} - {content} must have ONE! top level element.
    /// If {replaceNode} is false {content} will be added to {parent} otherwise th new
    /// {content} replaces the old content
    ///
    /// Returns the rendered child
    Future<dom.Element> render(final dom.Element parent, final String content,{ final bool replaceNode: true}) {
        Validate.notNull(parent);
        Validate.notBlank(content);

        _logger.fine("Start with rendering process...");

        final Completer completer = new Completer();

        // add the render-function to the list where the "new Future" can pick it
        _renderFunctions.insert(0, () {

            parent.classes.remove(_cssClasses.LOADED);
            parent.classes.add(_cssClasses.LOADING);

            try {
                final dom.Element child = new dom.Element.html(content, validator: _validator());
                //final dom.Element child = new dom.DocumentFragment.html(content, validator: _validator());

                componentFactory().upgradeElement(child).then( (_) {

                    dom.window.requestAnimationFrame( (_) {

                        if(replaceNode && parent.childNodes.length > 0 && parent.childNodes.last != null) {
                            var oldElement = parent.childNodes.last;
                            if(oldElement is dom.Element) {
                                oldElement.style.display = "none";
                                componentHandler().downgradeElement(oldElement);
                            }
                            oldElement.remove();
                            //_logger.info("Old element removed!");
                        }

                        //element.append(child);
                        parent.insertAdjacentElement("beforeEnd",child);

                        _callAttached(child);

                        parent.classes.remove(_cssClasses.LOADING);
                        parent.classes.add(_cssClasses.LOADED);

                        completer.complete(child);

                    });

                });

            } on Error catch (e) {
                _logger.shout("Invalid content:\n\t$content\n(Orig. Error: $e)\n");

                if(parent is dom.TableCaptionElement) {
                    _logger.shout("At the moment adding table-rows dynamically to the DOM is not supported!");
                } else {
                    _logger.shout("Usually this error occures if content has not just ONE single root element.");
                }
            }
        });

        new Future(() {
            final _DomRenderFunction renderfunction = _renderFunctions.last;
            _renderFunctions.remove(renderfunction);
            renderfunction();
        });

        return completer.future;
    }

    /// Renders {content} and inserts the generated node before {reference}
    /// If {reference} is null the new node will be added as last child to its {parent}
    Future<dom.Element> renderBefore(final dom.Element parent,final dom.Element reference, final String content) {
        Validate.notNull(parent);
        Validate.notBlank(content);

        //_logger.info("Content: $content");

        final Completer completer = new Completer();

        // add the render-function to the list where the "new Future" can pick it
        _renderFunctions.insert(0, () {

            parent.classes.remove(_cssClasses.LOADED);
            parent.classes.add(_cssClasses.LOADING);

            final dom.Element child = new dom.Element.html(content,validator: _validator());

            componentFactory().upgradeElement(child).then( (_) {

                dom.window.requestAnimationFrame( (_) {

                    if(reference != null) {
                        parent.insertBefore(child,reference);
                    } else {
                        parent.insertAdjacentElement("beforeEnd",child);
                    }

                    _callAttached(child);

                    parent.classes.remove(_cssClasses.LOADING);
                    parent.classes.add(_cssClasses.LOADED);

                    completer.complete(child);

                });

            });

        });

        new Future(() {
            final _DomRenderFunction renderfunction = _renderFunctions.last;
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

    /// Calls the MdlComponents attached-function for the given [element] and all it's children.
    void _callAttached(final dom.Element element) {
        //final Logger _logger = new Logger('mdlcore.callAttached');

        if(element is dom.HtmlElement) {

            var jsElement = new JsObject.fromBrowserObject(element);
            if(jsElement.hasProperty(MDL_COMPONENT_PROPERTY)) {
                final List<String> componentsForElement = (jsElement[MDL_COMPONENT_PROPERTY] as String).split(",");
                componentsForElement.forEach((final String componentName) {

                    final MdlComponent component = jsElement[componentName] as MdlComponent;
                    component.attached();
                    //_logger.info("Attached ${component}");
                });
            }

        }

        // Iterate through all children
        element.children.forEach( (final dom.Element child)  {
            _callAttached(child);
        });
    }

}

class _AllowAllAttributesNodeValidator implements dom.NodeValidator {

    bool allowsAttribute(dom.Element element, String attributeName, String value) {
        // if (attributeName == 'is' || attributeName.startsWith('on')) {
        //     return false;
        // }
        return true;
    }

    @override
    bool allowsElement(dom.Element element) {
        return true;
    }
}