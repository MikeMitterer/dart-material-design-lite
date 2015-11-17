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

abstract class MdlComponent {
    final Logger _logger = new Logger('mdlcore.MdlComponent');

    /// All the registered Events - helpful for automatically downgrading the element
    /// Sample:
    ///     eventStreams.add(input.onFocus.listen( _onFocus));
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

    //dom.ElementStream<dom.Event>        get onChange => hub.onChange;
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

    /// Called after [DomRenderer] has added this component to the DOM or
    /// if [MdlComponentHandler] hast upgrade the component and it's already in the DOM!
    ///
    /// If you need a components parent then 'init' your component in [attached] instead of
    /// CTOR.fromElement(..)
    ///
    /// In short - if attached is called the DOM is ready for you - this is not the case
    /// for CTOR.fromElement(..)
    void attached() {  /* _logger.info("${this} attached!"); */ }

    /// Called by the framework after styles or attributes are updated from an external
    /// Component like [MaterialAttribute] or [MaterialClass]
    void update() { /* _logger.info("${this} updated!"); */ }

    //- private -----------------------------------------------------------------------------------

    MdlComponent _getMdlParent(final dom.HtmlElement element) {
        MdlComponent parent;

        //_logger.info("Check if $element has a parent: ${element.parent}");
        try {

            // null means return the first available component.
            // If there are more than one component - it throws an Exception
            parent = mdlComponent(element.parent,null);

        } on WrongComponentTypeException catch(wct) {
            _logger.warning(wct);
            throw wct;
        }

        catch(e) {
            // Exception means there is a parent (dom.Element) but this parent is not
            // a MdlComponent - so continue the search for the next parent
            // _logger.warning("Checking $element (ID: ${element.id}) brought: $e");
            return _getMdlParent(element.parent);
        }

        if(parent != null) {
            return parent;
        }
        return null;
    }
}
