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

part of mdlcore;

class WrongComponentTypeException implements Exception {
    final message;
    WrongComponentTypeException([this.message]);
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
        throw "$element is not a MdlComponent!!! (ID: $id, Classes: ${element.classes}, Dataset: ${element.dataset['upgraded']})";
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

/// Checks if [element] is a "MDLComponent"
/// [type] is optional - if given a stricter check is made
bool isMdlComponent(final dom.HtmlElement element,[ final Type type ]) {
    Validate.notNull(element);
    var jsElement = new JsObject.fromBrowserObject(element);
    final bool isComponent = jsElement.hasProperty(MDL_COMPONENT_PROPERTY);

    if(isComponent && type != null) {
        return mdlComponentNames(element).contains(type.toString());
    }

    return isComponent;
}

/// Gives you all the component names registered for this [element]
List<String> mdlComponentNames(final dom.HtmlElement element) {
    Validate.notNull(element);

    final List<String> names = new List<String>();

    var jsElement = new JsObject.fromBrowserObject(element);
    if(!jsElement.hasProperty(MDL_COMPONENT_PROPERTY)) {
        return names;
    }

    names.addAll((jsElement[MDL_COMPONENT_PROPERTY] as String).split(","));
    return names;
}

/// Returns all the MDL-Components registered for this [element]
List<MdlComponent> mdlComponents(final dom.HtmlElement element) {
    Validate.notNull(element);

    final List<MdlComponent> components = new List<MdlComponent>();
    if(!isMdlComponent(element)) {
        return components;
    }

    var jsElement = new JsObject.fromBrowserObject(element);
    final List<String> names = mdlComponentNames(element);
    names.forEach((final String name) {
        if(jsElement.hasProperty(name)) {
            components.add(jsElement[name] as MdlComponent);
        }
    });

    return components;
}

void refreshComponentsInSubtree(final dom.HtmlElement element) {
    if(element != null && element is dom.HtmlElement) {
        element.children.forEach((final dom.Element element) => refreshComponentsInSubtree(element));
        if(isMdlComponent(element)) {
            mdlComponents(element).forEach((final MdlComponent component) {
                if(component is RefreshableComponent) {
                    (component as RefreshableComponent).refresh();
                }
            });
        }
    }
}

/// Returns all MdlComponents in subtree
List<MdlComponent> getAllMdlComponents(final dom.HtmlElement element) {
    Validate.notNull(element);

    final List<MdlComponent> components = new List<MdlComponent>();

    _iterateOverAllHTMLElements(final dom.HtmlElement element) {
        if(element is dom.HtmlElement) {
            element.children.forEach((final dom.Element element) => _iterateOverAllHTMLElements(element));
            //_logger.info("E: $element ID: ${element.id} - classes: ${element.classes}");
            if(isMdlComponent(element)) {
                //_logger.shout("E: $element ID: ${element.id} - classes: ${element.classes}");
                components.addAll(mdlComponents(element));
            }
        }
    }

    _iterateOverAllHTMLElements(element);
    //_logger.info("#${counter} Elements found");
    //_logger.info("#${components.length} Components found");

    return new UnmodifiableListView(components);
}