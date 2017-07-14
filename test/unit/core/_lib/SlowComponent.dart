/*
 * Copyright (c) 2017, Michael Mitterer (office@mikemitterer.at),
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
     
part of test.unit.core.mdlcomponent;
 
/* 
/// Basic DI configuration for this Component or Service
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new SlowComponentModule());
///         }     
///     }
class SlowComponentModule  extends di.Module {
    SlowComponentModule() {
        // bind(DeviceProxy);
    }
} 
*/

/// Controller-View for <test-component></test-component>
///
/// Use this Component to test slow rendering
@MdlComponentModel
class SlowComponent extends MdlTemplateComponent {
    /// Make rendering really! slow
    static const Duration RENDER_DELAY = const Duration(milliseconds: 400);

    static const _SlowComponentCssClasses _cssClasses = const _SlowComponentCssClasses();

    SlowComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }
    
    static SlowComponent widget(final dom.HtmlElement element) => mdlComponent(element,SlowComponent) as SlowComponent;
    
    // Central Element - by default this is where test-component can be found (element)
    // html.Element get hub => inputElement;
    
    // - EventHandler -----------------------------------------------------------------------------

    void handleButtonClick(final dom.Event event) {
        event.preventDefault();
    }
    
    //- private -----------------------------------------------------------------------------------

    void _init() {

        // Recommended - add SELECTOR as class
        element.classes.add(_SlowComponentConstant.WIDGET_SELECTOR);

        // We slow down the rendering process
        new Future.delayed(RENDER_DELAY, () {
            render().then( (_) {
                // DOM for Component is ready!
            });
        });

        element.classes.add(_cssClasses.IS_UPGRADED);
    }
    
    //- Template -----------------------------------------------------------------------------------
    
    @override
    final String template = """
        <div>
            Your SlowComponent-Component works!
            <button class="mdl-button mdl-js-button mdl-button--colored mdl-js-ripple-effect"
                        data-mdl-click="handleButtonClick(\$event)">Click me!</button>
        </div>
    """.trim().replaceAll(new RegExp(r"\s+")," ");    
}

/// Registers the SlowComponent-Component
///
///     main() {
///         registerSlowComponent();
///         ...
///     }
///
void registerSlowComponent() {
    final MdlConfig config = new MdlWidgetConfig<SlowComponent>(
        _SlowComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new SlowComponent.fromElement(element,injector)
    );
    
    // If you want <test-component></test-component> set selectorType to SelectorType.TAG.
    // If you want <div test-component></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="test-component"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _SlowComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _SlowComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _SlowComponentConstant {

    static const String WIDGET_SELECTOR = "slow-component";

    const _SlowComponentConstant();
}    