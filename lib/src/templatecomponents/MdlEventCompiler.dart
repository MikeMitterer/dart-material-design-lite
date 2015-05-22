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

/**
 * Connects data-mdl-[event] attributes with object-functions
 */
class EventCompiler {
    final Logger _logger = new Logger('mdltemplatecomponents.EventCompiler');

    static const List<String> datasets = const [ "mdl-click", "mdl-class"];

    /**
     * {scope} represents an object/class where the functions are located,
     * {element} has children with data-mdl-[eventname] attributes.
     * Sample:
     *      <tag ... data-mdl-click="check({{id}})"></tag>
     *
     * compileElement connects these two definitions
     */
    Future compileElement(final Object scope,final dom.Element element) async {

        final InstanceMirror myClassInstanceMirror = reflect(scope);

        datasets.forEach((final String dataset) {

            final List<dom.Element> elements = element.querySelectorAll("[data-${dataset}]");

            elements.forEach( (final dom.Element element) {
                //_logger.info("$dataset for $element");

                // finds function name and params
                final Match match = new RegExp(r"([^(]*)\(([^)]*)\)").firstMatch(element.dataset[dataset]);

                // from the above sample this would be: check
                Symbol getFunctionName() => new Symbol(match.group(1));

                List getParams() {
                    final List params = new List();

                    // first group is function name, second - params
                    if(match.groupCount == 2) {
                        final List<String> matches = match.group(2).split(",");
                        if(matches.isNotEmpty && matches[0].isNotEmpty) {
                            params.addAll(matches);
                        }
                    }
                    return params;
                }

                switch(dataset) {
                    case "mdl-click":
                        element.onClick.listen( (final dom.MouseEvent event) {
                            event.preventDefault();
                            event.stopPropagation();
                            myClassInstanceMirror.invoke(getFunctionName(), getParams());
                        });
                       break;

                }
            });

        });
        _logger.info("Events compiled...");
    }
}

/// Same as {EventCompiler} but uses MdlComponent as basis.
/// {MdlComponent} already brings it's dom.Element
class MdlEventCompiler extends EventCompiler {
    final Logger _logger = new Logger('mdltemplatecomponents.MdlEventCompiler');

    Future compile(final MdlComponent component) async {
        final dom.Element element = component.element;
        compileElement(component,element);
    }

}