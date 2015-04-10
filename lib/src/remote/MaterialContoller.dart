part of mdlremote;

abstract class MaterialController {
    void loaded(final Route route);
}

class DummyController extends MaterialController {
    final Logger _logger = new Logger('mdlremote.DummyController');

    @override
    void loaded(final Route route) {
        _logger.info("View loaded! (Route: ${route.name})");
    }
}