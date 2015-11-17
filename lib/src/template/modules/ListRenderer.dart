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

part of mdltemplate;

@di.Injectable()
class ListRenderer {
    final Logger _logger = new Logger('mdltemplate.ListRenderer');

    /// Adds data to Dom
    DomRenderer _renderer;

    /// changes something like data-mdl-click="check({{id}})" into a callable Component function
    EventCompiler _eventCompiler;

    /// Holds the old data to compare it with the incoming data (only for renderList)
    final List _miniDom = new List();

    String listTag = "<ul>";

    String itemTag = "<li>";

    ListRenderer(this._renderer, this._eventCompiler);

    Renderer call(final dom.Element parent,final Object scope,final List items, String template() ) {
        Validate.notNull(parent);
        Validate.notNull(scope);
        Validate.notNull(items);

        String _template() {
            final String data = template();
            Validate.notNull(data,"Template for ListRenderer must not be null!!!!");

            return data.trim().replaceAll(new RegExp(r"\s+")," ");
        }

        Future _render() async {
            Validate.notNull(parent);
            Validate.notNull(scope);
            Validate.notNull(items);

            _logger.info("Start rendering...");
            final Template mustacheTemplate = new Template(_template(),htmlEscapeValues: false);

            /// Empty list - remove all children
            if(items.length == 0) {
                _miniDom.clear();
                //parent.childNodes.forEach((final dom.Node node) => new Future(() => node.remove()));
                parent.children.clear();
                _logger.info("List 0 length...");
                return;
            }

            /// first rendering
            if(_miniDom.length == 0) {
                Future _addAllItemsToDom() async {
                    if(parent.childNodes.length == 1 && !(parent.childNodes.first is dom.Element)) {
                        parent.childNodes.first.remove();
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
                    await _renderer.render(parent,buffer.toString(),replaceNode: false).then((final dom.Element child) {
                        _logger.info("compiling events for ${child}...");
                        _eventCompiler.compileElement(scope,child);
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
            for(int index = 0;index < _miniDom.length;index++) {
                final domItem = _miniDom[index];
                if(!items.contains(domItem)) {

                    final int index = _miniDom.indexOf(domItem);
                    _logger.info("Index to remove: ${index} - FC ${parent.firstChild}, IDX ${parent.firstChild.childNodes[index]}");
                    (parent.firstChild.childNodes[index] as dom.Element).classes.add("ready-to-remove");
                    diffCounter++;

                    if(diffCounter == domDiff) {
                        new Future( () {
                            _removeMarkedItems(parent);
                            _updateMiniDom(items);
                        });
                        return;
                    }
                }
            }

            _logger.info("Listitems was added - start updating MiniDom...");

            // if parent is not empty - remove contents
            if(parent.childNodes.length == 1 && !(parent.childNodes.first is dom.Element)) {
                parent.childNodes.first.remove();
            }


            if(parent.childNodes.length == 0) {
                parent.append(new dom.Element.tag(_startTag(itemTag)));
            }

            final dom.Element list = parent.childNodes.first;

            items.forEach((final item) {
                if(!_miniDom.contains(item)) {
                    _logger.info("Add ${item.item}");
                    final String renderedTemplate = mustacheTemplate.renderString(item);

                    _renderer.render(list,"${_startTag(itemTag)}${renderedTemplate}${_endTag(itemTag)}",replaceNode: false)
                    .then( (final dom.Element child) {

                        _eventCompiler.compileElement(scope,child);

                    });
                }
            });

            _removeMarkedItems(parent);
            _updateMiniDom(items);
        }

        return new Renderer(_render);
    }


    // - private ----------------------------------------------------------------------------------


    String _startTag(final String tag) => tag;
    String _endTag(final String tag) => tag.replaceFirst("<","</");

    void _removeMarkedItems(final dom.Element parent) {
        parent.querySelectorAll(".ready-to-remove").forEach((final dom.Element element) {
            element.remove();
        });
    }

    void _updateMiniDom(final List items) {
        _miniDom.clear();
        _miniDom.addAll(items);
    }

}