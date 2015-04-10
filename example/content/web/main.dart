import "dart:html" as dom;
import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_material/wskremote.dart';

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

    registerAllWskComponents();
    registerAllWskRemoteComponents();

    upgradeAllRegistered().then((_) {
        final MaterialSlider mainslider = MaterialSlider.widget(dom.querySelector("#mainslider2"));

        mainslider.value = model.sliderValue;

        mainslider.onChange.listen((_) => model.sliderValue = mainslider.value);
        model.onChange.listen((_) {
            mainslider.value = model.sliderValue;
        });
    });
}

class DemoController extends MaterialController {
    final Model _model = new Model();

    MaterialSlider _slider5;
    MaterialSlider _slider2;

    @override
    void loaded(final Route route) {
        _slider5 = MaterialSlider.widget(dom.querySelector("#slider5"));
        _slider2 = MaterialSlider.widget(dom.querySelector("#slider2"));

        _slider5.value = _model.sliderValue;
        _slider2.value = _model.sliderValue;

        _slider5.onChange.listen((_) => _model.sliderValue = _slider5.value);
        _slider2.onChange.listen((_) => _model.sliderValue = _slider2.value);


        _model.onChange.listen((_) => _modelChanged());
    }

    // - private ------------------------------------------------------------------------------------------------------

    void _modelChanged() {
        _slider5.value = _model.sliderValue;
        _slider2.value = _model.sliderValue;
    }

}

void configRouter() {
    final Router router = new Router(useFragment: true);
    final ViewFactory view = new ViewFactory();

    router.root

        ..addRoute(name: 'test', path: '/test',
            enter: view("views/test.html", new DummyController()))

        ..addRoute(name: 'test2', path: '/test2',
            enter: view("views/test2.html", new DummyController()))

        ..addRoute(name: 'slider', path: '/slider',
            enter: view("views/slider.html", new DemoController()))

        ..addRoute(name: 'error', path: '/error',
            enter: view("views/doesnotexist.html", new DemoController()))

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