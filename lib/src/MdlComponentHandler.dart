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

/// Store strings for class names defined by this component that are used in Dart.
class _MdlComponentHandlerCssClasses {

    final String UPGRADING = "mdl-upgrading";

    final String UPGRADED = "mdl-upgraded";

    final String HTML_JS = "mdl-js";

    final String HTML_DART = "mdl-dart";

    const _MdlComponentHandlerCssClasses();
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

    static const _MdlComponentHandlerCssClasses _cssClasses = const _MdlComponentHandlerCssClasses();

    final Map<String, MdlConfig> _registeredComponents = new HashMap<String, MdlConfig>();

    /**
     * Registers a class for future use and attempts to upgrade existing DOM.
     * Sample:
     *      final ComponentHandler componenthandler = new ComponentHandler();
     *      componenthandler.register(new MdlConfig<MaterialButton>("mdl-button"));
     */
    void register(final MdlConfig config) {
        Validate.notNull(config);

        if(!_isValidClassName(config.classAsString)) {
            _logger.severe("(${config.classAsString}) is not a valid component for ${config.cssClass}");
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

    /**
     * Upgrades all registered components found in the current DOM. This is
     * automatically called on window load.
     * At the beginning of the upgrade-process it adds the csss-classes
     * mdl-js, mdl-dart and mdl-upgrading to the <html>-element.
     * If all components are ready it remove mdl-upgrading.
     */
    Future upgradeAllRegistered() {
        final html.Element body = html.querySelector("body");
        return upgradeElement(body);
    }

    Future upgradeElement(final html.HtmlElement element) {
        Validate.notNull(element,"Component must not be null!");

        html.querySelector("html")
            ..classes.add(_cssClasses.HTML_JS)
            ..classes.add(_cssClasses.HTML_DART)
            ..classes.remove(_cssClasses.UPGRADED);

        final Future future = new Future(() {
            element.classes.add(_cssClasses.UPGRADING);

            _configs.forEach((final MdlConfig config) {
                _upgradeDom(element,config);
                _logger.fine("${config.cssClass} upgraded with ${config.classAsString}...");
            });

            html.querySelector("body").classes.remove(_cssClasses.UPGRADING);
            html.querySelector("html").classes.add(_cssClasses.UPGRADED);
            _logger.info("All components are upgraded...");

        });

        return future;
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

    /**
     * Searches existing DOM for elements of our component type and upgrades them
     * if they have not already been upgraded!
     * {queryBaseElement} defines where the querySelector starts to search - can be any element.
     * upgradeAllRegistered uses "body" as {queryBaseElement}
     */
    void _upgradeDom(final html.Element queryBaseElement, final MdlConfig config) {
        Validate.notNull(queryBaseElement);
        Validate.notNull(config);

//        final List<Future> futureUpgrade = new List<Future>();
//        final Future future = new Future(() {
            final html.ElementList<html.HtmlElement> elements = queryBaseElement.querySelectorAll(".${config.cssClass}");
            elements.forEach((final html.HtmlElement element) {
                _upgradeElement(element, config);
                // futureUpgrade.add(_upgradeElement(element, config));
            });
//        });
//        futureUpgrade.add(future);
//        Future.wait(futureUpgrade);
    }

    /**
     * Upgrades a specific element rather than all in the DOM.
     * [element] is the element we wish to upgrade.
     * [config] the Dart-Class/Css-Class configuration of the class we want to upgrade
     * the element to.
     */
    void _upgradeElement(final html.HtmlElement element, final MdlConfig config) {
        Validate.notNull(element);
        Validate.notNull(config);

        const String DATA_KEY = "data-upgraded";
        if (!element.attributes.containsKey(DATA_KEY) || element.attributes[DATA_KEY].contains(config.classAsString) == false) {

            void _markAsUpgraded() {
                final List<String> registeredClasses = element.attributes.containsKey(DATA_KEY)
                ? element.attributes[DATA_KEY].split(",") : new List<String>();

                registeredClasses.add(config.classAsString);
                element.attributes[DATA_KEY] = registeredClasses.join(",");
            }

            try {
                final MdlComponent component = config.newComponent(element);
                config.callbacks.forEach((final MdlCallback callback) => callback(element));

                _markAsUpgraded();
                _logger.fine("${config.classAsString} -> ${component}");

                if(config.isWidget) {

                    // Makes it possible to query for the main element in this component.
                    var jsElement = new JsObject.fromBrowserObject(component.hub);
                    jsElement[MDL_WIDGET_PROPERTY] = component;

                    //element.xtag = component as html.Element;
                }

            }
            catch (exception, stacktrace) {
                _logger.severe("Registration for: ${config.cssClass} not possible. Check if ${config.classAsString} is correctly imported");
                _logger.severe(exception, stacktrace);
            }
        }
    }
}

