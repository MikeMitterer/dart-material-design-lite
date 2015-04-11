import "dart:html" as dom;
import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdlcomponets.dart';
import 'package:mdl/mdldemo.dart';

import 'package:mdl/mdlremote.dart';

import 'package:route_hierarchical/client.dart';

class ModelChangedEvent {

}

/// Model is a Singleton
class Model {
    static Model _model;

    final StreamController _controller = new StreamController<ModelChangedEvent>.broadcast();

    Stream<ModelChangedEvent> onChange;

    int _sliderValue = 20;

    factory Model() {
        if(_model == null) {  _model = new Model._internal(); }
        return _model;
    }

    int get sliderValue => _sliderValue;

    set sliderValue(final int value) {
        _sliderValue = value;
        _controller.add(new ModelChangedEvent());
    }

    //- private -----------------------------------------------------------------------------------

    Model._internal() {
        onChange = _controller.stream;
    }
}


main() {
    final Logger _logger = new Logger('main.MaterialContent');
    final Model model = new Model();

    configLogging();
    configRouter();

    registerAllMdlComponents();
    registerAllMdlRemoteComponents();

    // registerDemoAnimation and import wskdemo.dart is on necessary for animation sample
    registerDemoAnimation();


    upgradeAllRegistered().then((_) {

    });
}

class DemoController extends MaterialController {
    final Model _model = new Model();


    @override
    void loaded(final Route route) {

    }

    // - private ------------------------------------------------------------------------------------------------------

}

void configRouter() {
    final Router router = new Router(useFragment: true);
    final ViewFactory view = new ViewFactory();

    router.root

        ..addRoute(name: 'accordion', path: '/accordion',
                    enter: view("views/accordion.html", new DummyController()))

        ..addRoute(name: 'animation', path: '/animation',
                    enter: view("views/animation.html", new DummyController()))

        ..addRoute(name: 'badge', path: '/badge',
                    enter: view("views/badge.html", new DummyController()))

        ..addRoute(name: 'button', path: '/button',
                    enter: view("views/button.html", new DummyController()))

        ..addRoute(name: 'card', path: '/card',
                    enter: view("views/card.html", new DummyController()))

        ..addRoute(name: 'checkbox', path: '/checkbox',
                    enter: view("views/checkbox.html", new DummyController()))

        ..addRoute(name: 'column-layout', path: '/column-layout',
                    enter: view("views/column-layout.html", new DummyController()))

        ..addRoute(name: 'footer', path: '/footer',
                    enter: view("views/footer.html", new DummyController()))

        ..addRoute(name: 'icon-toggle', path: '/icon-toggle',
                    enter: view("views/icon-toggle.html", new DummyController()))

        ..addRoute(name: 'layout', path: '/layout',
                    enter: view("views/layout.html", new DummyController()))

        ..addRoute(name: 'list', path: '/list',
                    enter: view("views/list.html", new DummyController()))

        ..addRoute(name: 'menu', path: '/menu',
                    enter: view("views/menu.html", new DummyController()))

        ..addRoute(name: 'nav-pills', path: '/nav-pills',
            enter: view("views/nav-pills.html", new DummyController()))

        ..addRoute(name: 'palette', path: '/palette',
                    enter: view("views/palette.html", new DummyController()))

        ..addRoute(name: 'panel', path: '/panel',
            enter: view("views/panel.html", new DummyController()))

        ..addRoute(name: 'progress', path: '/progress',
                    enter: view("views/progress.html", new DummyController()))

        ..addRoute(name: 'radio', path: '/radio',
                    enter: view("views/radio.html", new DummyController()))

        ..addRoute(name: 'shadow', path: '/shadow',
                    enter: view("views/shadow.html", new DummyController()))

        ..addRoute(name: 'slider', path: '/slider',
                    enter: view("views/slider.html", new DummyController()))

        ..addRoute(name: 'spinner', path: '/spinner',
                    enter: view("views/spinner.html", new DummyController()))

        ..addRoute(name: 'switch', path: '/switch',
                    enter: view("views/switch.html", new DummyController()))

        ..addRoute(name: 'tabs', path: '/tabs',
                    enter: view("views/tabs.html", new DummyController()))

        ..addRoute(name: 'textfield', path: '/textfield',
                    enter: view("views/textfield.html", new DummyController()))

        ..addRoute(name: 'tooltip', path: '/tooltip',
                    enter: view("views/tooltip.html", new DummyController()))

        ..addRoute(name: 'typography', path: '/typography',
            enter: view("views/typography.html", new DummyController()))
    

        ..addRoute(name: 'home', defaultRoute: true, path: '/',
            enter: view("views/home.html" ,new DummyController()))

    ;

    router.listen();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}