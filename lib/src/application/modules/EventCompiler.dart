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

typedef void _ElementFunction(final Symbol function,final List params);

/**
 * Connects data-mdl-[event] attributes with object-functions
 *
 * Needed in mdltemplatecomponents!
 */
@di.Injectable()
class EventCompiler {
    final Logger _logger = new Logger('mdlapplication.EventCompiler');

    static const List<String> datasets = const [ "mdl-click", "mdl-keyup"];

    /**
     * {scope} represents an object/class where the functions are located,
     * {element} has children with data-mdl-[eventname] attributes.
     * Sample:
     *      <tag ... data-mdl-click="check({{id}})"></tag>
     *
     *      <tag ... data-mdl-keyup="handleKeyUp(\$event)"></tag>
     *      <tag ... data-mdl-keyup="handleKeyUp()"></tag>
     *
     * compileElement connects these definitions
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
                        element.onClick.listen( (final dom.MouseEvent event) =>
                            _invokeFunction(myClassInstanceMirror,getFunctionName(),getParams(),event)
                        );
                       break;

                    case "mdl-keyup":
                        element.onKeyUp.listen( (final dom.KeyboardEvent event) =>
                            _invokeFunction(myClassInstanceMirror,getFunctionName(),getParams(),event)
                        );
                        break;
                }
            });

        });
        _logger.info("Events compiled...");
    }

    //- private -----------------------------------------------------------------------------------

    bool _hasEvent(final List params) => (params != null && params.contains("\$event") ? true : false);
    bool _hasNoEvent(final List params) => !_hasEvent(params);

    /// Replaces $event with {event}
    List _replaceEventInParams(final List params,final dom.Event event) {
        if(_hasEvent(params)) {
            final int index = params.indexOf("\$event");
            params.replaceRange(index,index + 1, [ event ] );
        }
        return params;
    }

    /// Calls the defined function. If there is a $event param defined for the function it will be replace
    /// with {event}. If no $event param is defined then preventDefault and stopPropagation is called on this {event}
    void _invokeFunction(final InstanceMirror myClassInstanceMirror,final Symbol function, final List params, final dom.Event event) {
        if(_hasNoEvent(params)) {
            event.preventDefault();
            event.stopPropagation();
        }
        myClassInstanceMirror.invoke(function, _replaceEventInParams(params,event));
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