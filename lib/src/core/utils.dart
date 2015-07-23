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

part of mdlcore;

class WrongComponentTypeException implements Exception {
    factory WrongComponentTypeException([var message]) => new Exception(message);
}

/**
 * [element] The element where a MDL-Component is registered
 *
 * Returns the upgraded MDL-Component. If {element} is null it returns a null-MDLComponent
 * [type] The requested type. If [type] is null it returns the first available type.
 *
 * If [type] is null and if there are more than one types available it throws and error!
 *
 * Sample:
 *      static MaterialAccordion widget(final dom.HtmlElement element) =>
 *          mdlComponent(MaterialAccordion,element) as MaterialAccordion;
 */
MdlComponent mdlComponent(final dom.HtmlElement element,final Type type) {
    //final Logger _logger = new Logger('mdlcore.mdlComponent');

    if(element == null) {
        return element as MdlComponent;
    }
    var jsElement = new JsObject.fromBrowserObject(element);

    void _listNames(var jsElement) {
        final Logger _logger = new Logger('mdlcore.mdlComponent._listNames');

        final List<String> componentsForElement = (jsElement[MDL_COMPONENT_PROPERTY] as String).split(",");

        _logger.info("Registered Component for $element:");
        componentsForElement.forEach((final String name) {
            _logger.warning(" -> $name");
        });
    }

    // If element has not MDL_WIDGET_PROPERTY it is not a MDLComponent
    if (!jsElement.hasProperty(MDL_COMPONENT_PROPERTY)) {
        String id = "<not set>";
        if(element.id != null && element.id.isNotEmpty) {
            id = element.id;
        }
        throw "$element is not a MdlComponent!!! (ID: $id, ${element.classes}, ${element.dataset['upgraded']})";
    }

    String typeAsString;
    if(type != null) {
        typeAsString = type.toString();
        //_logger.fine("Looking for $typeAsString!");

    } else if(jsElement.hasProperty(_MDL_WIDGET_PROPERTY)) {

        typeAsString = jsElement[_MDL_WIDGET_PROPERTY] as String;

    } else {
        // If there is not "type" but more then one components - throw exception!
        final List<String> componentsForElement = (jsElement[MDL_COMPONENT_PROPERTY] as String).split(",");
        if(componentsForElement.length > 1) {
            throw new WrongComponentTypeException("$element has more than one components registered. ($componentsForElement)\n"
            "Please specify the requested type.\n"
            "Usually this is a 'MdlComponent.parent' problem...");
        }
        typeAsString = componentsForElement.first;
    }

    // OK we found the right type - return the component
    if(jsElement.hasProperty(typeAsString)) {
        //_logger.fine("Found $typeAsString");
        return (jsElement[typeAsString] as MdlComponent);
    }

    // Show the available names
    _listNames(jsElement);

    throw "$element is not a ${typeAsString}-Component!!!\n(ID: ${element.id}, class: ${element.classes})\n"
        "These components are available: ${jsElement[MDL_COMPONENT_PROPERTY] as String}";
}

/// Checks if [element] is a "Widget" (usually this means a UI-Element)
/// MdlConfig.isWidget...
bool isMdlWidget(final dom.HtmlElement element) {
    Validate.notNull(element);
    var jsElement = new JsObject.fromBrowserObject(element);
    return jsElement.hasProperty(_MDL_WIDGET_PROPERTY);
}