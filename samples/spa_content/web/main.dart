import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:di/di.dart' as di;

import 'package:route_hierarchical/client.dart';

class ModelChangedEvent { }

/// Model is a Singleton
@MdlComponentModel
class Model {
    static Model _model;

    final StreamController _controller = new StreamController<ModelChangedEvent>.broadcast();

    Stream<ModelChangedEvent> onChange;

    int _sliderValue = 20;

    List<int> randomValues = new List<int>();

    factory Model() {
        if(_model == null) {  _model = new Model._internal(); }
        return _model;
    }

    int get sliderValue => _sliderValue;

    set sliderValue(final int value) {
        _sliderValue = value;
        randomValues.clear();
        for(int counter = 0;counter < _sliderValue;counter++) {
            randomValues.add(new Math.Random().nextInt(1000));
        }
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
    registerMdl();

    componentFactory().run().then((_) {
        configRouter(componentFactory().injector.get(ViewFactory));

        final MaterialSlider mainslider = MaterialSlider.widget(dom.querySelector("#mainslider2"));
        final MaterialContent list = MaterialContent.widget(dom.querySelector("#list"));
        final MaterialMustache mustache = MaterialMustache.widget(dom.querySelector("#mustache"));

        mustache.template = """
            <div>
                Slider value: {{sliderValue}}
                    <ol>
                    {{#randomValues}}
                        <li>{{ . }},</li>
                    {{/randomValues}}
                    {{^randomValues }}
                        <li>No values</li>
                    {{/randomValues }}
                    </ol>
            </div>""";

        mainslider.value = model.sliderValue;

        mainslider.onInput.listen((_) => model.sliderValue = mainslider.value);

        model.onChange.listen((_) {

            String items() {
                final StringBuffer line = new StringBuffer();
                for(int counter = 0; counter < model.sliderValue; counter++) {
                    final String id = "${counter + 1}";

                    line.write("<li>");
                    line.write("Item #${id}");
                    line.write('<button id="btn$id" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored mdl-js-ripple-effect">Button #${id}</button>');
                    line.write("</li>");
                }
                return line.toString();
            }

            new Future(() {
                mainslider.value = model.sliderValue;
                _logger.info("Model ${model.sliderValue}");

                list.render("<ul>" + items() + "</ul>").then((_) {
                    for(int counter = 0; counter < model.sliderValue; counter++) {
                        final dom.Element element  = list.element.querySelector("#btn${counter+1}");

                        // check for null - if elements are added to fast it could be possible that
                        // the element you are searching for was already removed
                        if(element != null) {
                            element.onClick.listen((final dom.MouseEvent event) {
                                dom.window.alert("Clicked on Button #${counter+1}");
                            });

                        }
                    }
                });
            });

            mustache.render(model);
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

        if(_slider5 == null) {
            // ERROR-PAGE not slider 5
            return;
        }

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

void configRouter(final ViewFactory view) {
    final Router router = new Router(useFragment: true);

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