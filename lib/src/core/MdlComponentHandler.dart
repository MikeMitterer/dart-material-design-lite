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

/// Thrown if you try to register more than one widget per element
/// Multiple components per element are allowed but not multiple widgets!
class MultipleWidgetException implements Exception {
    final message;
    MultipleWidgetException([this.message]);
}

/// Property for the Components JsObject to save/register the component
const String MDL_COMPONENT_PROPERTY     = "mdlcomponent";

/// Property for the Components JsObject to save/register the component it component is a Widget
const String _MDL_WIDGET_PROPERTY       = "mdlwidget";

/// Store strings for class names defined by this component that are used in Dart.
class _MdlComponentHandlerCssClasses {

    final String UPGRADING = "mdl-upgrading";

    final String UPGRADED = "mdl-upgraded";

    final String HTML_JS = "mdl-js";

    final String HTML_DART = "mdl-dart";

    final String DOWNGRADED = "mdl-downgraded";

    final String RIPPLE_EFFECT = "mdl-js-ripple-effect";

    const _MdlComponentHandlerCssClasses();
}

class _MdlComponentHandlerConstant {

    final String TEMPLATE = "template";

    const _MdlComponentHandlerConstant();
}

/**
 * A component handler interface using the revealing module design pattern.
 * More details on this pattern design here:
 * https://github.com/jasonmayes/mdl-component-design-pattern
 * (JS-Version: Jason Mayes.)
 *
 * @author Mike Mitterer
 */
class MdlComponentHandler {
    final Logger _logger = new Logger('mdlcore.ComponentHandler');

    final String _DATA_KEY = "data-upgraded";

    static const _MdlComponentHandlerCssClasses _cssClasses = const _MdlComponentHandlerCssClasses();
    static const _MdlComponentHandlerConstant _constant = const _MdlComponentHandlerConstant();

    final Map<String, MdlConfig> _registeredComponents = new HashMap<String, MdlConfig>();

    final List<di.Module> _modules = new List<di.Module>();

    /// If set to true it
    bool _enableVisualDebugging = false;

    /// The injector for this module.
    /// Can also set via [mockComponentHandler]
    di.Injector _injector;

    /**
     * Registers a class for future use and attempts to upgrade existing DOM.
     * Sample:
     *      final ComponentHandler componenthandler = new ComponentHandler();
     *      componenthandler.register(new MdlConfig<MaterialButton>("mdl-button"));
     */
    void register(final MdlConfig config) {
        Validate.notNull(config);

        if(!_isValidClassName(config.classAsString)) {
            _logger.severe("(${config.classAsString}) is not a valid component for ${config.selector}");
            return;
        }

        if (!_isRegistered(config)) {
            _registeredComponents.putIfAbsent(config.classAsString, () => config);
        }
    }

    /**
     * Allows user to be alerted to any upgrades that are performed for a given
     * component type
     * [config] The class-config of the MDL component we wish
     * to hook into for any upgrades performed.
     * The [callback]-function to call upon an upgrade. This
     * function should expect 1 parameter - the HTMLElement which got upgraded.
     */
    void registerUpgradedCallback(final MdlConfig config,final MdlCallback callback) {

        if(_isValidClassName(config.classAsString) && _isRegistered(config)) {
            _registeredComponents[config.classAsString].callbacks.add(callback);
        }
    }

    @deprecated
    Future upgradeAllRegistered() => run();


    /// Upgrades all children for {element} and returns the current Injector
    Future<di.Injector> upgradeElement(final dom.HtmlElement element) {
        Validate.notNull(_injector,"Injector must not be null - did you call run?");
        Validate.notNull(element,"Component must not be null!");

        return upgradeElements( [ element] );
    }

    /// Upgrades a specific list of elements rather than all in the DOM.
    Future<di.Injector> upgradeElements(final List<dom.HtmlElement> elements) {
        Validate.notNull(_injector,"Injector must not be null - did you call run?");
        Validate.notNull(elements,"List of elements must not be null!");

        dom.querySelector("html")
            ..classes.add(_cssClasses.HTML_JS)
            ..classes.add(_cssClasses.HTML_DART)
            ..classes.remove(_cssClasses.UPGRADED);

            final Future<di.Injector> future = new Future<di.Injector>( () {

                elements.forEach((final dom.HtmlElement element) {

                    element.classes.add(_cssClasses.UPGRADING);

                    _configs.forEach((final MdlConfig config) {
                        _upgradeDom(element,config);
                        _logger.finer("${config.selector} upgraded with ${config.classAsString}...");
                    });

                    element.classes.remove(_cssClasses.UPGRADING);
                    element.classes.add(_cssClasses.UPGRADED);

                });


            dom.querySelector("body").classes.remove(_cssClasses.UPGRADING);
            dom.querySelector("html").classes.add(_cssClasses.UPGRADED);

            _logger.fine("All components are upgraded...");

            return _injector;
        });

        return future;
    }

    /// downgrade() will be called for the given Component and it's children
    Future downgradeElement(final dom.HtmlElement element) {
        Validate.notNull(element,"Element to downgrade must not be null!");

        final Completer completer = new Completer();

        void _downgradeChildren(final dom.HtmlElement element) {
            if(element != null) {
                element.children.forEach((final dom.Element element) {
                    if(element is dom.HtmlElement) {
                        _downgradeChildren(element);
                    }
                });
            _deconstructComponent(element);
            }
        }

        new Future(() {
            if(element is dom.HtmlElement) {

//            final List<dom.Element> children = element.querySelectorAll('[class*="mdl-"]');
//
//            // Children first
//            children.forEach((final dom.Element element) => _deconstructComponent(element));
//
//            _deconstructComponent(element);
                _downgradeChildren(element);
            }

            completer.complete();
        });

        return completer.future;
    }

    //- DI ----------------------------------------------------------------------------------------

    /**
     * Upgrades all registered components found in the current DOM. This
     * should be called in your main-function.
     * At the beginning of the upgrade-process it adds the css-classes
     * mdl-js, mdl-dart and mdl-upgrading to the <html>-element.
     * If all components are ready it removes mdl-upgrading.
     *
     * Sample:
     *        main() {
     *        registerMdl();
     *
     *        componentFactory().run().then( (_) {
     *
     *              });
     *        }
     */
    Future<MaterialApplication> run( { final enableVisualDebugging: false } ) {
        final dom.Element body = dom.querySelector("body");

        _enableVisualDebugging = enableVisualDebugging;
        //_modules.add(new di.Module()..bind(DomRenderer));

        _injector = _createInjector();

        return upgradeElement(body).then((_) => new Future<MaterialApplication>(() {
                return _injector.get(MaterialApplication) as MaterialApplication;
        }));
    }

    /**
     * In most cases this is your AppController
     *
     * Sample:
     *        @MdlComponentModel @di.Injectable()
     *        class AppController {
     *
     *        }
     *
     *        main() {
     *        registerMdl();
     *
     *        componentFactory().rootContext(AppController).run().then( (final di.Injector injector) {
     *                  new AppController();
     *              });
     *        }
     */
    MdlComponentHandler rootContext(final Type rootContext) {
        _modules.add(new di.Module()..bind(MaterialApplication, toImplementation: rootContext));
        return this;
    }

    /// Add your App-specific modules
    MdlComponentHandler addModule(final di.Module module) {
        if(_modules.indexOf(module) == -1) {
            _modules.add(module);
        }
        return this;
    }

    /// Returns the injector for this module.
    di.Injector get injector {
        if(_injector == null) {
            _injector = _createInjector();
        }
        return _injector;
    }

    /**
     * Returns your Application-Object.
     *
     * Define it like this:
     *
     *     @MdlComponentModel @di.Injectable()
     *     class Application extends MaterialApplication {
     *         Application() { }
     *
     *         @override
     *         void run() {
     *             // App logic
     *         }
     *     }
     *
     *     main() {
     *         registerMdl();
     *
     *         componentFactory().rootContext(Application).run()
     *             .then((final MaterialApplication application) {
     *                 application.run();
     *         });
     *     }
     *
     */
    MaterialApplication get application {
        return injector.get(MaterialApplication);
    }

    //- private -----------------------------------------------------------------------------------

    bool _isRegistered(final MdlConfig config) => _registeredComponents.containsKey(config.classAsString);

    bool _isValidClassName(final String classname) => (classname != "dynamic");

    /// The component with the highest priority comes last
    List<MdlConfig> get _configs {
        final List<MdlConfig> configs = new List<MdlConfig>.from(_registeredComponents.values);

        configs.sort((final MdlConfig a, final MdlConfig b) {
            return a.priority.compareTo(b.priority);
        });

        return configs;
    }

//    /// Returns true if the given element has already been upgraded for the given
//    /// class / Config.
//    /// The [element] we want to check.
//    /// [config] the config we check against [element]
//    bool _isElementUpgraded(final dom.Element element,final MdlConfig config) {
//
//        final bool upgraded = element.dataset.containsKey('upgraded');
//        if(!upgraded) {
//            return false;
//        }
//        return element.dataset['upgraded'].contains(config.classAsString);
//    }

    /**
     * Searches existing DOM for elements of our component type and upgrades them
     * if they have not already been upgraded!
     * [queryBaseElement] defines where the querySelector starts to search - can be any element.
     * upgradeAllRegistered uses "body" as [queryBaseElement]
     */
    void _upgradeDom(final dom.Element queryBaseElement, final MdlConfig config) {
        Validate.notNull(queryBaseElement);
        Validate.notNull(config);

        /// Check if {config.selector} is either the class-name or the tag name of {baseElement}
        /// If so - upgrade
        void _upgradeBaseElementIfSelectorFits(final dom.Element baseElement) {
            bool upgrade = false;
            switch(config.selectorType) {
                case SelectorType.TAG:
                    upgrade = baseElement.tagName.toLowerCase() == config.baseSelector;
                    break;

                case SelectorType.ATTRIBUTE:
                    upgrade = baseElement.attributes.containsKey(config.baseSelector);
                    break;

                case SelectorType.CLASS:
                default:
                    upgrade = baseElement.classes.contains(config.baseSelector);
            }
            if(upgrade) {
                //_logger.warning("Upgrade base-element: ${queryBaseElement} Class: ${config.classAsString}");
                _upgradeElement(baseElement, config);
            }
        }

        _upgradeBaseElementIfSelectorFits(queryBaseElement);

        final dom.ElementList<dom.HtmlElement> elements = queryBaseElement.querySelectorAll(config.selector);
        elements.forEach((final dom.HtmlElement element) {

            _upgradeElement(element, config);

        });

    }

    /**
     * Upgrades a specific element rather than all in the DOM.
     * [element] is the element we wish to upgrade.
     * [config] the Dart-Class/Css-Class configuration of the class we want to upgrade
     * the element to.
     */
    void _upgradeElement(final dom.HtmlElement element, final MdlConfig config) {
        Validate.notNull(element);
        Validate.notNull(config);

        /// If there is a tag with template attribute - ignore this element!
        bool _hasTemplate(final dom.HtmlElement element) {
            if(element == null) {
                return false;
            }
            if(element.attributes.containsKey(_constant.TEMPLATE) ||
                element.tagName.toLowerCase() == _constant.TEMPLATE) {
                return true;
            }
            return _hasTemplate(element.parent);
        }

        /// Check if element is already in DOM (assume that if it finds a 'body' it is in DOM)
        /// Is not the case for dynamically added components ([DomRenderer])
        bool _isInDom(final dom.Element element) {
            if(element.parent != null) {
                if(element.parent.tagName.toLowerCase() == "body") {
                    return true;
                }
                return _isInDom(element.parent);
            }

            return false;
        }

        if (( !element.attributes.containsKey(_DATA_KEY) ||
            element.attributes[_DATA_KEY].contains(config.classAsString) == false) && !_hasTemplate(element)) {

            void _markAsUpgraded() {
                final List<String> registeredClasses = element.attributes.containsKey(_DATA_KEY)
                ? element.attributes[_DATA_KEY].split(",") : new List<String>();

                registeredClasses.add(config.classAsString);
                element.attributes[_DATA_KEY] = registeredClasses.join(",");
            }

            try {
                final MdlComponent component = config.newComponent(element,_injector);

                component.visualDebugging = _enableVisualDebugging;
                config.callbacks.forEach((final MdlCallback callback) => callback(element));

                _markAsUpgraded();
                _logger.finer("${config.classAsString} -> ${component}");

                // Makes it possible to query for the main element in this component.
                var jsElement = new JsObject.fromBrowserObject(component.hub);

                /// Every Widget is a Component but not every Component is a Widget
                void _registerWidget() {
                    if(jsElement.hasProperty(_MDL_WIDGET_PROPERTY)) {
                        final String name = jsElement[_MDL_WIDGET_PROPERTY];
                        throw new MultipleWidgetException("There is already a widget registered for $element, Type: $name!\n"
                        "Only one widget per element is allowed!");
                    }

                    // Store the widget-name as String (registration comes a few lines below)
                    jsElement[_MDL_WIDGET_PROPERTY] = config.classAsString;
                }

                if(config.isWidget) {
                    _registerWidget();
                }

                /// remember all the registered components in MDL_COMPONENT_PROPERTY
                /// Widget names are stored as comma separated list
                /// Every Widget is a Component but not every Component is a Widget
                void _registerComponent() {
                    if(jsElement.hasProperty(config.classAsString)) {
                        throw new ArgumentError("$element has already a ${config.classAsString} registered!");
                    }

                    // Add first element if property is not available
                    if(!jsElement.hasProperty(MDL_COMPONENT_PROPERTY)) {
                        jsElement[MDL_COMPONENT_PROPERTY] = config.classAsString;
                    }

                    final List<String> componentsForElement = (jsElement[MDL_COMPONENT_PROPERTY] as String).split(",");
                    if(!componentsForElement.contains(config.classAsString)) {
                        componentsForElement.add(config.classAsString);
                        jsElement[MDL_COMPONENT_PROPERTY] = componentsForElement.join(",");

                    }

                    // register the component with it's name. It makes no difference if the component is a widget or not
                    jsElement[config.classAsString] = component;
                }

                _registerComponent();

                /// body-check calls attached if the element we register is registered for "body"
                /// Sample:
                ///     <body class="demo-page--{{samplename}}" mdl-class="checkDebug : 'debug'">
                ///
                if(element.tagName.toLowerCase() == "body" || _isInDom(element)) {
                    component.attached();
                }

            }
            catch (exception, stacktrace) {
                _logger.severe("Registration for: ${config.selector} not possible. Check if ${config.classAsString} is correctly imported");
                _logger.severe(exception, stacktrace);
            }
        }
    }

    /**
     * Creates an injector function that can be used for retrieving services as well as for
     * dependency injection.
     */
    di.Injector _createInjector() {
        return new di.ModuleInjector(_modules);
    }

    /// Downgrades the given {element} with all it's components
    void _deconstructComponent(final dom.HtmlElement element) {
        try {
            // Also remove the Widget-Property
            var jsElement = new JsObject.fromBrowserObject(element);

            MdlComponent component;
            if(jsElement.hasProperty(MDL_COMPONENT_PROPERTY)) {

                final List<String> componentsForElement = (jsElement[MDL_COMPONENT_PROPERTY] as String).split(",");
                componentsForElement.forEach((final String componentName) {

                    component = jsElement[componentName] as MdlComponent;

                    component.downgrade();
                    _logger.fine("$componentName downgraded to HTML-Element: $element!");

                    jsElement.deleteProperty(componentName);

                });

                jsElement.deleteProperty(MDL_COMPONENT_PROPERTY);
            }

            if(jsElement.hasProperty(_MDL_WIDGET_PROPERTY)) {
                // Component is already downgraded (All MdlComponents are listed in MDL_COMPONENT_PROPERTY)
                jsElement.deleteProperty(_MDL_WIDGET_PROPERTY);
            }

            // doesn't mater if it is a widget or a ripple...
            if(component != null) {
                component.attributes.remove(_DATA_KEY);
                component.classes.add(_cssClasses.DOWNGRADED);
                component = null;
            }

        } on String catch (e) {
            _logger.severe(e);
        }
    }
}

