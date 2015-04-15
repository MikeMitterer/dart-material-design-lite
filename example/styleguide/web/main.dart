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

    String _title = "";

    factory Model() {
        if(_model == null) {  _model = new Model._internal(); }
        return _model;
    }

    String get title => _title;

    set title(final String value) {
        _title = value;
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
    enableTheming();
    configRouter();

    registerAllMdlComponents();
    registerAllMdlRemoteComponents();

    // registerDemoAnimation and import wskdemo.dart is on necessary for animation sample
    registerDemoAnimation();

    upgradeAllRegistered().then((_) {
        model.onChange.listen((_) {
            dom.querySelector("#title").text = model.title;
        });
    });
}

class DemoController extends MaterialController {
    final Model _model = new Model();

    @override
    void loaded(final Route route) {
        _model.title = route.name;
    }
    // - private ------------------------------------------------------------------------------------------------------
}

void configRouter() {
    final Router router = new Router(useFragment: true);
    final ViewFactory view = new ViewFactory();

    router.root

        ..addRoute(name: 'accordion', path: '/accordion',
                    enter: view("views/accordion.html", new DemoController()))

        ..addRoute(name: 'animation', path: '/animation',
                    enter: view("views/animation.html", new DemoController()))

        ..addRoute(name: 'badge', path: '/badge',
                    enter: view("views/badge.html", new DemoController()))

        ..addRoute(name: 'button', path: '/button',
                    enter: view("views/button.html", new DemoController()))

        ..addRoute(name: 'card', path: '/card',
                    enter: view("views/card.html", new DemoController()))

        ..addRoute(name: 'checkbox', path: '/checkbox',
                    enter: view("views/checkbox.html", new DemoController()))

        ..addRoute(name: 'column-layout', path: '/column-layout',
                    enter: view("views/column-layout.html", new DemoController()))

        ..addRoute(name: 'footer', path: '/footer',
                    enter: view("views/footer.html", new DemoController()))

        ..addRoute(name: 'icons', path: '/icons',
            enter: view("views/icons.html", new DemoController()))

        ..addRoute(name: 'icon-toggle', path: '/icon-toggle',
                    enter: view("views/icon-toggle.html", new DemoController()))

        ..addRoute(name: 'layout', path: '/layout',
                    enter: view("views/layout.html", new DemoController()))

        ..addRoute(name: 'list', path: '/list',
                    enter: view("views/list.html", new DemoController()))

        ..addRoute(name: 'menu', path: '/menu',
                    enter: view("views/menu.html", new DemoController()))

        ..addRoute(name: 'nav-pills', path: '/nav-pills',
            enter: view("views/nav-pills.html", new DemoController()))

        ..addRoute(name: 'palette', path: '/palette',
                    enter: view("views/palette.html", new DemoController()))

        ..addRoute(name: 'panel', path: '/panel',
            enter: view("views/panel.html", new DemoController()))

        ..addRoute(name: 'progress', path: '/progress',
                    enter: view("views/progress.html", new DemoController()))

        ..addRoute(name: 'radio', path: '/radio',
                    enter: view("views/radio.html", new DemoController()))

        ..addRoute(name: 'shadow', path: '/shadow',
                    enter: view("views/shadow.html", new DemoController()))

        ..addRoute(name: 'slider', path: '/slider',
                    enter: view("views/slider.html", new DemoController()))

        ..addRoute(name: 'spinner', path: '/spinner',
                    enter: view("views/spinner.html", new DemoController()))

        ..addRoute(name: 'switch', path: '/switch',
                    enter: view("views/switch.html", new DemoController()))

        ..addRoute(name: 'tabs', path: '/tabs',
                    enter: view("views/tabs.html", new DemoController()))

        ..addRoute(name: 'textfield', path: '/textfield',
                    enter: view("views/textfield.html", new DemoController()))

        ..addRoute(name: 'theming', path: '/theming',
            enter: view("views/theming.html", new DemoController()))

        ..addRoute(name: 'tooltip', path: '/tooltip',
                    enter: view("views/tooltip.html", new DemoController()))

        ..addRoute(name: 'typography', path: '/typography',
            enter: view("views/typography.html", new DemoController()))
    

        ..addRoute(name: 'home', defaultRoute: true, path: '/',
            enter: view("views/home.html" ,new DemoController()))

    ;

    router.listen();
}

void enableTheming() {
    final Uri uri = Uri.parse(dom.document.baseUri.toString());
    if(uri.queryParameters.containsKey("theme")) {
        final dom.LinkElement link = new dom.LinkElement();
        link.rel = "stylesheet";
        link.id = "theme";

        final String theme = uri.queryParameters['theme'].replaceFirst("/","");
        bool isThemeOK = false;

        // dev/testing
        //link.href = "https://rawgit.com/MikeMitterer/dart-mdl-theme/master/${theme}/material.css";

        // production
        link.href = "https://cdn.rawgit.com/MikeMitterer/dart-mdl-theme/master/${theme}/material.css";

        isThemeOK = true;

        if(isThemeOK) {
            final dom.LinkElement defaultTheme = dom.querySelector("#theme");
            if(defaultTheme != null) {
                defaultTheme.replaceWith(link);

                //dom.querySelector("#themename").text = theme;
            }

        }
    }
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}