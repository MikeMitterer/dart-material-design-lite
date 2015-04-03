part of wskcore;

/**
 * A component handler interface using the revealing module design pattern.
 * More details on this pattern design here:
 * https://github.com/jasonmayes/wsk-component-design-pattern
 * (JS-Version: Jason Mayes.)
 *
 * @author Mike Mitterer
 */
class WskComponentHandler {
    final Logger _logger = new Logger('wskcore.ComponentHandler');

    final Map<String, WskConfig> _registeredComponents = new HashMap<String, WskConfig>();

    /**
     * Registers a class for future use and attempts to upgrade existing DOM.
     * Sample:
     *      final ComponentHandler componenthandler = new ComponentHandler();
     *      componenthandler.register(new WskConfig<MaterialButton>("wsk-button"));
     */
    void register(final WskConfig config) {
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
     * [config] The class-config of the WSK component we wish
     * to hook into for any upgrades performed.
     * The [callback]-function to call upon an upgrade. This
     * function should expect 1 parameter - the HTMLElement which got upgraded.
     */
    void registerUpgradedCallback(final WskConfig config,final WskCallback callback) {

        if(_isValidClassName(config.classAsString) && _isRegistered(config)) {
            _registeredComponents[config.classAsString].callbacks.add(callback);
        }
    }

    /**
     * Upgrades all registered components found in the current DOM. This is
     * automatically called on window load.
     * At the beginning of the upgrade-process it adds the csss-classes
     * wsk-js, wsk-dart and wsk-upgrading to the <html>-element.
     * If all components are ready it remove wsk-upgrading.
     */
    Future upgradeAllRegistered() {
        html.querySelector("html")
            ..classes.add("wsk-js")
            ..classes.add("wsk-dart");

        html.querySelector("body").classes.add("wsk-upgrading");

        final Future future = new Future(() {

            // The component with the highest priority comes last
            final List<WskConfig> configs = new List<WskConfig>.from(_registeredComponents.values);
            configs.sort((final WskConfig a, final WskConfig b) {
                return a.priority.compareTo(b.priority);
            });

            configs.forEach((final WskConfig config) {
                _upgradeDom(config);
                _logger.info("${config.cssClass} upgraded with ${config.classAsString}...");
            });

            html.querySelector("body").classes.remove("wsk-upgrading");
            html.querySelector("html").classes.add("wsk-upgraded");
            _logger.info("All components are upgraded...");

        });

        return future;
    }

    void upgradeElement(final html.HtmlElement element, List<WskConfig> wskcomponents() ) {
        Validate.notNull(wskcomponents,"Callback for WskConfig-List must not be null!");

        final List<WskConfig> components = wskcomponents();
        if(components == null || components.isEmpty) {
            _logger.warning("No WskConfig provided for ${element}");
            return;
        }

        components.forEach((final WskConfig config) {
            _upgradeElement(element,config);
        });

        element.classes.add("wsk-upgraded");
        element.classes.remove("wsk-upgrading");
    }

    //- private -----------------------------------------------------------------------------------

    bool _isRegistered(final WskConfig config) => _registeredComponents.containsKey(config.classAsString);

    bool _isValidClassName(final String classname) => (classname != "dynamic");

    /**
     * Searches existing DOM for elements of our component type and upgrades them
     * if they have not already been upgraded!
     */
    void _upgradeDom(final WskConfig config) {
        Validate.notNull(config);

        //final List<Future> futureUpgrade = new List<Future>();
        //return new Future(() {
            final html.ElementList<html.HtmlElement> elements = html.querySelectorAll(".${config.cssClass}");
            elements.forEach((final html.HtmlElement element) {
                _upgradeElement(element, config);
                // futureUpgrade.add(_upgradeElement(element, config));
            });
        //});
        //return Future.wait(futureUpgrade);
    }

    /**
     * Upgrades a specific element rather than all in the DOM.
     * [element] is the element we wish to upgrade.
     * [config] the Dart-Class/Css-Class configuration of the class we want to upgrade
     * the element to.
     */
    void _upgradeElement(final html.HtmlElement element, final WskConfig config) {
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
                final WskComponent component = config.newComponent(element);
                config.callbacks.forEach((final WskCallback callback) => callback(element));

                _markAsUpgraded();
                _logger.fine("${config.classAsString} -> ${component}");

                //element.xtag = component as html.Element;
                var jsElement = new JsObject.fromBrowserObject(element);
                jsElement["widget"] = component;

            }
            catch (exception, stacktrace) {
                _logger.severe("Registration for: ${config.cssClass} not possible. Check if ${config.classAsString} is correctly imported");
                _logger.severe(exception, stacktrace);
            }
        }
    }
}

