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

import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl/mdldemo.dart';
import 'package:mdl/mdlobservable.dart';

import 'package:route_hierarchical/client.dart';
import 'package:route_hierarchical/link_matcher.dart';

import 'package:di/di.dart' as di;

import "package:mdl/mdldialog.dart";

/**
 * Application - you can get the Application via injector.getByKey(MDLROOTCONTEXT)
 */
@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    /// Title will be displayed
    final ObservableProperty<String> title = new ObservableProperty<String>("");

    Application() {
        _logger.info("Application created");
    }

    @override
    void run() {
    }

    //- private -----------------------------------------------------------------------------------
}

class StyleguideModule extends di.Module {
    StyleguideModule() {
       // Nothing interesting here - just a reminder how to use a Module
    }
}

main() {
    final Logger _logger = new Logger('main.MaterialContent');

    configLogging();

    registerMdl();
    registerMdlDND();

    componentFactory().rootContext(Application)
    .addModule(new StyleguideModule()).run()
    .then((final MaterialApplication application) {

        configRouter();
        application.run();
    });
}

/// Default Controller!!!
class DefaultController extends MaterialController {
    final Logger _logger = new Logger('main.DefaultController');

    @override
    void loaded(final Route route) {

        final Application app = componentFactory().application;
        app.title.value = route.name;

        _logger.info("DefaultController loaded!");
    }
// - private ------------------------------------------------------------------------------------------------------
}

class ControllerView1 extends DefaultController {
    final Logger _logger = new Logger('main.ControllerView1');

    @override
    void loaded(final Route route) {
        super.loaded(route);
        _logger.info("ControllerView1 loaded!");
    }

    @override
    void unload() {
        _logger.info("ControllerView1 unloaded!");

    }
    // - private ------------------------------------------------------------------------------------------------------
}

class ControllerView2 extends DefaultController {
    final Logger _logger = new Logger('main.ControllerView2');

    @override
    void loaded(final Route route) {
        super.loaded(route);
        _logger.info("ControllerView2 loaded!");
    }

    @override
    void unload() {
        _logger.info("ControllerView2 unloaded!");

    }
    // - private ------------------------------------------------------------------------------------------------------
}

class ControllerView3 extends DefaultController {
    final Logger _logger = new Logger('main.ControllerView3');

    @override
    void loaded(final Route route) {
        super.loaded(route);
        _logger.info("ControllerView3 loaded!");
    }

    @override
    void unload() {
        _logger.info("ControllerView3 unloaded!");

    }
// - private ------------------------------------------------------------------------------------------------------
}



void configRouter() {
    final Router router = new Router(useFragment: true);
    final ViewFactory view = new ViewFactory();

    router.root

        ..addRoute(name: 'view1', path: '/view1',
            enter: view("views/view1.html", new ControllerView1()))

        ..addRoute(name: 'view2', path: '/view2',
            enter: view("views/view2.html", new ControllerView2()))

        ..addRoute(name: 'view3', path: '/view3',
            enter: view("views/view3.html", new ControllerView2()))
        
        ..addRoute(name: 'home', defaultRoute: true, path: '/',
            enter: view("views/home.html", new DefaultController()))

    ;

    router.listen();
}

void enableTheming() {
    final Uri uri = Uri.parse(dom.document.baseUri.toString());
    if (uri.queryParameters.containsKey("theme")) {
        final dom.LinkElement link = new dom.LinkElement();
        link.rel = "stylesheet";
        link.id = "theme";

        final String theme = uri.queryParameters['theme'].replaceFirst("/", "");
        bool isThemeOK = false;

        // dev/testing
        //link.href = "https://rawgit.com/MikeMitterer/dart-mdl-theme/master/${theme}/material.css";

        // production
        link.href = "https://cdn.rawgit.com/MikeMitterer/dart-mdl-theme/master/${theme}/material.min.css";

        isThemeOK = true;

        if (isThemeOK) {
            final dom.LinkElement defaultTheme = dom.querySelector("#theme");
            if (defaultTheme != null) {
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