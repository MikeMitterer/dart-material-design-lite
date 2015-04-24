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

class MdlEventCompiler {
    final Logger _logger = new Logger('mdltemplatecomponents.MdlEventCompiler');

    static const List<String> datasets = const [ "mdl-click"];

    Future compile(final MdlComponent component) async {
        final dom.Element element = component.element;
        compileElement(component,element);
    }

    Future compileElement(final MdlComponent component,final dom.Element element) async {

        final InstanceMirror myClassInstanceMirror = reflect(component);

        datasets.forEach((final String dataset) {

            final List<dom.Element> elements = element.querySelectorAll("[data-${dataset}]");

            elements.forEach( (final dom.Element element) {
                //_logger.info("$dataset for $element");

                final Match match = new RegExp(r"([^(]*)\(([^)]*)\)").firstMatch(element.dataset[dataset]);

                Symbol getFunctionName() => new Symbol(match.group(1));

                List getParams() {
                    final List params = new List();
                    if(match.groupCount == 2) {
                        params.addAll(match.group(2).split(","));
                    }
                    return params;
                }

                switch(dataset) {
                    case "mdl-click":
                        element.onClick.listen( (_) {
                            myClassInstanceMirror.invoke(getFunctionName(), getParams());
                        });
                        break;
                }
            });

        });
        _logger.info("Events compiled...");
    }
}