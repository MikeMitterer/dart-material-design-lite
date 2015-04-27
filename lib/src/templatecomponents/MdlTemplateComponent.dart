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

part of mdltemplatecomponents;

abstract class TemplateComponent {
    /// Adds data to Dom
    final Renderer _renderer = new Renderer();

    /// changes something like data-mdl-click="check({{id}})" into a callable Component function
    final EventCompiler _eventCompiler = new EventCompiler();

    /// Subclasses must override this getter
    String get template;

    /**
     *  Makes it easy to add functionality to templates
     *  Sample:
     *      Template: "{{lambdas.classes}}
     *
     *  class MyClass extends Object with TemplateComponent {
     *      MyClass() {
     *          lambdas["classes"] = (_) => "is-enabled";
     *      }
     *  }
     */
    final Map<String,LambdaFunction> lambdas = new Map<String,LambdaFunction>();

    Future renderElement(final dom.Element element) async {
        final Template mustacheTemplate = new Template(template,htmlEscapeValues: false);
        await _renderer.render(element,mustacheTemplate.renderString(this));
        _eventCompiler.compileElement(this,element);
    }

}
/// Basis for all MdlComponents with Templates
abstract class MdlTemplateComponent extends MdlComponent with TemplateComponent {
    final Logger _logger = new Logger('mdltemplatecomponents.MdlTemplateComponent');

    /// Holds the old data to compare it with the incoming data
    final List _miniDom = new List();

    MdlTemplateComponent(final dom.Element element) : super(element);

    Future render() => renderElement(element);

    Future renderList(final List items,{ final String listTag: "<ul>", final String itemTag: "<li>" }) async {
        final Template mustacheTemplate = new Template(template,htmlEscapeValues: false);

        /// Empty list - remove all children
        if(items.length == 0) {
            _miniDom.clear();
            //element.childNodes.forEach((final dom.Node node) => new Future(() => node.remove()));
            element.children.clear();
            _logger.info("List 0 length...");
            return;
        }

        /// first rendering
        if(_miniDom.length == 0) {
            Future _addAllItemsToDom() async {
                if(element.childNodes.length == 1 && !(element.childNodes.first is dom.Element)) {
                    element.childNodes.first.remove();
                }
                _miniDom.addAll(items);
                final StringBuffer buffer = new StringBuffer();
                buffer.write(_startTag(listTag));
                items.forEach((final item) {
                    final String renderedTemplate = mustacheTemplate.renderString(item);
                    buffer.write(_startTag(itemTag));
                    buffer.write(renderedTemplate);
                    buffer.write(_endTag(itemTag));
                });
                buffer.write(_endTag(listTag));
                _logger.info("Buffer filled with list elements...");
                await _renderer.render(element,buffer.toString(),replaceNode: false).then((final dom.Element child) {
                _logger.info("compiling events for ${child}...");
                _eventCompiler.compileElement(this,child);
                _logger.info("compiling events for ${child} done!");
                });
                _logger.info("First init for list done...");
            }
            await _addAllItemsToDom();
            return;
        }

        final int domDiff = _miniDom.length - items.length; // if domDiff is positiv items were removed
        int diffCounter = 0;

        // Mark items not in list anymore as removable
         //_tagItemsNotInListAsRemovable()  {
            for(int index = 0;index < _miniDom.length;index++) {
                final domItem = _miniDom[index];
                if(!items.contains(domItem)) {

                    final int index = _miniDom.indexOf(domItem);
                    _logger.info("Index to remove: ${index} - FC ${element.firstChild}, IDX ${element.firstChild.childNodes[index]}");
                    (element.firstChild.childNodes[index] as dom.Element).classes.add("ready-to-remove");
                    diffCounter++;

                    if(diffCounter == domDiff) {
                        new Future(() {
                            _removeMarkedItems();
                            _updateMiniDom(items);
                        });
                        return;
                    }
                }
            }
        //}
         //_tagItemsNotInListAsRemovable();

        // if parent is not empty - remove contents
        if(element.childNodes.length == 1 && !(element.childNodes.first is dom.Element)) {
            element.childNodes.first.remove();
        }


        if(element.childNodes.length == 0) {
            element.append(new dom.Element.tag(_startTag(itemTag)));
        }

        final dom.Element list = element.childNodes.first;

        items.forEach((final item) {
            if(!_miniDom.contains(item)) {
                _logger.info("Add ${item.item}");
                final String renderedTemplate = mustacheTemplate.renderString(item);

                _renderer.render(list,"${_startTag(itemTag)}${renderedTemplate}${_endTag(itemTag)}",replaceNode: false)
                    .then( (final dom.Element child) {

                    _eventCompiler.compileElement(this,child);

                });
            }
        });

        _removeMarkedItems();
        _updateMiniDom(items);
    }

    String _startTag(final String tag) => tag;
    String _endTag(final String tag) => tag.replaceFirst("<","</");

    void _removeMarkedItems() {
        element.querySelectorAll(".ready-to-remove").forEach((final dom.Element element) {
            element.remove();
        });
    }

    void _updateMiniDom(final List items) {
        _miniDom.clear();
        _miniDom.addAll(items);
    }
}