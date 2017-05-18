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

abstract class MdlComponent extends Object with MdlEventListener {
    final Logger _logger = new Logger('mdlcore.MdlComponent');

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
     *               final Model model = injector.getInstance(Model);
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
     *          <label class="mdl-switch mdl-ripple-effect" for="switch-1">
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

    /// Searches for child of [element] based on the given [selector]
    ///
    /// Shortcut to [element.querySelector]
    /// You can turn off error logging by setting [logError] to false
    dom.Element query(final String selector,{ final bool logError: true }) {
        final dom.Element result = element.querySelector(selector);
        if(result == null && logError) {
            _logger.warning("Could not find '$selector' within $element!");
        }
        return result;
    }

    /// Waits until the first descendant element of [element] that matches the
    /// specified selector is available.
    ///
    /// [wait] defines the time between DOM-queries
    /// If the child is not ready within [maxIterations] the function stops
    /// with a [TimeoutException]
    /// 
    ///     try {
    ///         final dom.CanvasElement canvas = await waitForChild<dom.CanvasElement>("canvas");
    ///         _chart = new Chart(canvas , _chartConfig);
    ///     
    ///     } on TimeoutException catch(e) {
    ///         _logger.shout(e.message);
    ///     }
    ///     
    FutureOr<T> waitForChild<T>(final String selector,{
        final Duration wait: const Duration(milliseconds: 100),
        final int maxIterations: 10 }) async {

        Validate.notBlank(selector);

        // Maybe the child is already in the DOM then return it ASAP
        T child = element.querySelector(selector) as T;
        if(child != null) {
            return child;
        }

        int iterationCounter = 0;
        await Future.doWhile( () async {
            await new Future.delayed(wait, () {
                child = query(selector) as T;
                iterationCounter++;
            });

            return child == null && iterationCounter < maxIterations;
        });

        if(iterationCounter >= maxIterations) {
            throw new TimeoutException(
                "Could not find '$selector' within ${element}, "
                    "gave up after $maxIterations retries!");
        }
        return child;
    }

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
