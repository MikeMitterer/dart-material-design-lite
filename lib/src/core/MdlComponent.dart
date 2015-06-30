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

const String MDL_WIDGET_PROPERTY = "mdlwidget";
const String MDL_RIPPLE_PROPERTY = "mdlripple";

class WrongComponentTypeException implements Exception {
    factory WrongComponentTypeException([var message]) => new Exception(message);
}

/**
 * [element] The element where a MDL-Component is registered
 *
 * Returns the upgraded MDL-Component. If {element} is null it returns a null-MDLComponent
 * [type] The requested type. If [type] is null it returns the first available type.
 * If [type] is null and if there are more than one types available it throws and error!
 *
 * Sample:
 *      static MaterialAccordion widget(final dom.HtmlElement element) =>
 *          mdlComponent(MaterialAccordion,element) as MaterialAccordion;
 */
MdlComponent mdlComponent(final dom.HtmlElement element,final Type type) {
    final Logger _logger = new Logger('mdlcore.mdlComponent');

    if(element == null) {
        return element as MdlComponent;
    }
    var jsElement = new JsObject.fromBrowserObject(element);

    void _listNames(var jsElement) {
        final List<String> componentsForElement = (jsElement[MDL_WIDGET_PROPERTY] as String).split(",");
        componentsForElement.forEach((final String name) {
            _logger.warning("Registered Component $name for $element");
        });
    }

    // If element has not MDL_WIDGET_PROPERTY it is not a MDLComponent
    if (!jsElement.hasProperty(MDL_WIDGET_PROPERTY)) {
        String id = "<not set>";
        if(element.id != null && element.id.isNotEmpty) {
            id = element.id;
        }
        throw "$element is not a MdlComponent!!! (ID: $id)";

    }

    String typeAsString;
    if(type != null) {
        typeAsString = type.toString();
        _logger.info("Looking for $typeAsString!");

    } else {
        // If there is not "type" but more then one components - throw exception!
        final List<String> componentsForElement = (jsElement[MDL_WIDGET_PROPERTY] as String).split(",");
        if(componentsForElement.length > 1) {
            throw new WrongComponentTypeException("$element has more than one components registered. ($componentsForElement)\n"
                "Please specify the requested type.\n"
                "Usually this is a 'MdlComponent.parent' problem...");
        }
        typeAsString = componentsForElement.first;
    }

    // OK we found the right type - return the component
    if(jsElement.hasProperty(typeAsString)) {
        _logger.info("Found $typeAsString");
        return (jsElement[typeAsString] as MdlComponent);
    }

    // Show the available names
    _listNames(jsElement);

    throw "$element is not a ${typeAsString}-Component!!!\n(ID: ${element.id}, class: ${element.classes})\n"
        "These components are available: ${jsElement[MDL_WIDGET_PROPERTY] as String}";
}

abstract class MdlComponent {
    final Logger _logger = new Logger('mdlcore.MdlComponent');

    /// All the registered Events - helpful for automatically downgrading the element
    final List<StreamSubscription> eventStreams = new List<StreamSubscription>();

    /**
     * If you want to you DI define your bindings like this:
     *      class StyleguideModule extends di.Module {
     *          StyleguideModule() {
     *              bind( Model,toValue: new Model() );
     *          }
     *      }
     *
     * and use it like the following sample: (in main method)
     *
     *     componentFactory().addModule(new StyleguideModule())
     *          .run().then(( final di.Injector injector) {
     *               final Model model = injector.get(Model);
     *         });
     *      });
     *
     */
    final di.Injector injector;

    /// This is the element witch has the mdl-js- class
    final dom.Element element;

    /// If an error occurs in the Component and {visualDebugging} is true
    /// a red border will be drawn around the Component
    /// {visualDebugging} is set in {_upgradeElement}
    bool visualDebugging = false;

    MdlComponent(this.element,this.injector);

    /**
     * Main element. If there is no child element like in mdl-button
     *      <button class="mdl-button mdl-js-button">Flat</button>
     * hub = button = element
     *
     * but if there is a child element like in
     *          <label class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="switch-1">
     *              <input type="checkbox" id="switch-1" class="mdl-switch__input" />
     *              <span class="mdl-switch__label">Switch me</span>
     *          </label>
     * hub = input
     */
    dom.Element get hub => element;

    dom.CssClassSet     get classes => element.classes;
    Map<String, String> get attributes => element.attributes;

    dom.ElementStream<dom.Event>        get onChange => hub.onChange;
    dom.ElementStream<dom.Event>        get onInput =>  hub.onInput;
    dom.ElementStream<dom.MouseEvent>   get onClick =>  hub.onClick;

    /// Cancels all the registered streams
    void downgrade() {
        eventStreams.forEach((final StreamSubscription stream) => cancelStream(stream));
        eventStreams.clear();
    }

    /// Helper for cancelling streams - checks for null
    void cancelStream(final StreamSubscription stream) {
        if(stream != null) {
            stream.cancel();
        }
    }

    MdlComponent get parent => _getMdlParent(element);

    //- private -----------------------------------------------------------------------------------

    MdlComponent _getMdlParent(final dom.HtmlElement element) {
        MdlComponent parent;

        try {
            // null means return the first available component.
            // If there are more than one component - it throws an Exception
            parent = mdlComponent(element.parent,null);

        } on WrongComponentTypeException catch(wct) {
            throw wct;
        }

        catch(e) {
            // Exception means there is a parent (dom.Element) but this parent is not
            // a MdlComponent - so continue the search for the next parent
            return _getMdlParent(element.parent);
        }

        if(parent != null) {
            return parent;
        }
        return null;
    }
}
