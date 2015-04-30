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

const String MDL_WIDGET_PROPERTY = "widget";

MdlComponent mdlComponent(final dom.HtmlElement element) {
    var jsElement = new JsObject.fromBrowserObject(element);

    if (!jsElement.hasProperty(MDL_WIDGET_PROPERTY)) {
        throw "$element is not a MdlComponent!!!";
    }

    return (jsElement[MDL_WIDGET_PROPERTY] as MdlComponent);
}

abstract class MdlComponent {
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
     * Main element. If there is no chile element like in mdl-button
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
}

// CustomComponents...
//abstract class MdlHtmlComponent extends dom.HtmlElement implements MdlComponent {
//    html.Element element;
//
//    MdlHtmlComponent(this.element) : super.created();
//
//    MdlHtmlComponent.created() : super.created();
//
//    @override
//    void click() {
//        // TODO: implement click
//    }
//
//    @override
//    bool get isContentEditable => false;
//}

