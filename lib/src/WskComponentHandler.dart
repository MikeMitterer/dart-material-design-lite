part of wskcore;


class ComponentHandler {
    final Logger _logger = new Logger('wskcore.ComponentHandler');

    final Map<String, WskConfig> _registeredComponents = new HashMap<String, WskConfig>();

    ComponentHandler() {

    }

    void register(final WskConfig config) {
        Validate.notNull(config);

        bool _isValidClassName(final String classname) => (classname != "dynamic");

        if(!_isValidClassName(config.classAsString)) {
            _logger.severe("(${config.classAsString}) is not a valid component for ${config.cssClass}");
            return;
        }

        if (!_isRegistered(config)) {
            _registeredComponents.putIfAbsent(config.classAsString, () => config);
        }
    }

    Future upgradeAllRegistered() {
        final Future future = new Future(() {
            _registeredComponents.forEach((final String key, final WskConfig config) {
                _upgradeDom(config);
            });
        });

        return future;
    }

    //- private -----------------------------------------------------------------------------------

    bool _isRegistered(final WskConfig config) => _registeredComponents.containsKey(config);

    void _upgradeDom(final WskConfig config) {
        Validate.notNull(config);

        final html.ElementList<html.HtmlElement> elements = html.querySelectorAll(".${config.cssClass}");
        elements.forEach((final html.HtmlElement element) {
            _upgradeElement(element, config);
        });
    }

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
                final ClassMirror cm = reflectClass(config.type);
                final InstanceMirror im = cm.newInstance(new Symbol(''), [element]);

                Validate.isTrue(im.reflectee is WskComponent);
                final WskComponent component = im.reflectee;

                config.callbacks.forEach((final WskCallback callback) => callback(element));

                _markAsUpgraded();
                _logger.info("${config.classAsString} -> ${component}");

            }
            catch (exception, stacktrace) {
                _logger.severe("Registration for: ${config.cssClass} not possible. Check if ${config.classAsString} is correctly imported");
                _logger.severe(exception, stacktrace);
            }
        }
    }
}
