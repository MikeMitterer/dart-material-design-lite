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

abstract class MdlTemplateComponent extends MdlComponent {
    final Logger _logger = new Logger('mdltemplatecomponents.MdlTemplateComponent');

    final Renderer _renderer = new Renderer();
    final MdlEventManager _eventManager = new MdlEventManager();

    MdlTemplateComponent(final dom.Element element) : super(element);

    String template = "";
    final List miniDom = new List();

    Future render() {
        final Template mustacheTemplate = new Template(template,htmlEscapeValues: false);
        return _renderer.render(element,mustacheTemplate.renderString(this)).then((_) {

            _eventManager.compile(this);

        });
    }

    void renderList(final List items) {
        final Template mustacheTemplate = new Template(template,htmlEscapeValues: false);

        /// Empty list - remove all children
        if(items.length == 0) {
            miniDom.clear();
            //element.childNodes.forEach((final dom.Node node) => new Future(() => node.remove()));
            element.children.clear();
            return;
        }

        /// first rendering
        if(miniDom.length == 0) {
            if(element.childNodes.length == 1 && !(element.childNodes.first is dom.Element)) {
                element.childNodes.first.remove();
            }
            miniDom.addAll(items);
            final StringBuffer buffer = new StringBuffer();
            buffer.write("<ul>");
            items.forEach((final item) {
                final String renderedTemplate = mustacheTemplate.renderString(item);
                buffer.write("<li>");
                buffer.write(renderedTemplate);
                buffer.write("</li>");
            });
            buffer.write("</ul>");
            _renderer.render(element,buffer.toString(),replaceNode: false).then((final dom.Element child) {
                _logger.info("compileElement for ${child}");
                _eventManager.compileElement(this,child);
            });
            return;
        }

        miniDom.forEach((final domItem) {
            if(!items.contains(domItem)) {

                final int index = miniDom.indexOf(domItem);
                _logger.info("Index to remove: ${index} - FC ${element.firstChild}, IDX ${element.firstChild.childNodes[index]}");
                (element.firstChild.childNodes[index] as dom.Element).classes.add("ready-to-remove");
                //element.querySelector("ul li:nth-child(${index - 1})").classes.add("ready-to-remove");
            }
        });

        if(element.childNodes.length == 1 && !(element.childNodes.first is dom.Element)) {
            element.childNodes.first.remove();
        }
        if(element.childNodes.length == 0) {
            element.append(new dom.UListElement());
        }

        final dom.Element list = element.childNodes.first;

        items.forEach((final item) {
            if(!miniDom.contains(item)) {
                _logger.info("Add ${item.item}");
                final String renderedTemplate = mustacheTemplate.renderString(item);

                _renderer.render(list,"<li>${renderedTemplate}</li>",replaceNode: false)
                    .then( (final dom.Element child) {

                    _eventManager.compileElement(this,child);

                });
            }
        });

        element.querySelectorAll(".ready-to-remove").forEach((final dom.Element element) {
            element.remove();
        });

        miniDom.clear();
        miniDom.addAll(items);
    }
}