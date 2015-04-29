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

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdlcomponets.dart';
import 'package:mdl/mdldemo.dart';

import 'package:mdl/mdlremote.dart';

import 'package:route_hierarchical/client.dart';
import 'package:prettify/prettify.dart';

import "package:mdl/mdldialog.dart";

import "package:mdl_styleguide/customdialog.dart";

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

    registerAllMdlComponents();
    registerAllMdlRemoteComponents();

    // registerDemoAnimation and import wskdemo.dart is on necessary for animation sample
    registerDemoAnimation();

    upgradeAllRegistered().then((_) {
        configRouter();

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

        final dom.HtmlElement element = dom.querySelector("#usage");
        if(element != null) {
            final MaterialInclude usage = MaterialInclude.widget(element);
            if(usage != null) {
                usage.onLoadEnd.listen((_) => prettyPrint());
            }
        } else {
            prettyPrint();
        }
    }
    // - private ------------------------------------------------------------------------------------------------------
}

class BadgeController extends DemoController {
    final Logger _logger = new Logger('main.BadgeController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialBadge badge1 = MaterialBadge.widget(dom.querySelector("#el1"));
        int counter = 1;
        new Timer.periodic(new Duration(milliseconds: 100), (_) {
            if(counter > 999) {
                counter = 1;
            }
            badge1.value = counter.toString();
            _logger.info("Current Badge-Value: ${badge1.value}");

            counter++;
        });
    }
    // - private ------------------------------------------------------------------------------------------------------
}

class IconToggleController extends DemoController {
    final Logger _logger = new Logger('main.IconToggleController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialIconToggle toggle = MaterialIconToggle.widget(dom.querySelector("#public-checkbox-1"));
        new Timer.periodic(new Duration(milliseconds: 500), (final Timer timer) {
            toggle.checked = !toggle.checked;
        });

    }
// - private ------------------------------------------------------------------------------------------------------
}

class MenuController extends DemoController {
    final Logger _logger = new Logger('main.MenuController');

    static const int TIMEOUT_IN_SECS = 5;

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialMenu menu1 = MaterialMenu.widget(dom.querySelector("#menu1"));
        final dom.DivElement message = dom.querySelector("#message");

        void _showMessage(final int secsToClose) {
            message.text = "Menu closes in ${secsToClose} seconds...";
            if(secsToClose <= 0) {
                message.text = "";
            }
        }

        menu1.show();
        _showMessage(TIMEOUT_IN_SECS);
        int tick = 0;
        new Timer.periodic(new Duration(milliseconds: 1000) , (final Timer timer) {

            _showMessage(TIMEOUT_IN_SECS - tick - 1);
            if(tick >= TIMEOUT_IN_SECS - 1) {
                timer.cancel();
                menu1.hide();
            }
            tick++;
        });

    }
// - private ------------------------------------------------------------------------------------------------------
}

class ProgressController extends DemoController {
    final Logger _logger = new Logger('main.ProgressController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        // 1
        new MaterialProgress(dom.querySelector("#p1")).progress = 44;

        // 2
        MaterialProgress.widget(dom.querySelector("#p3")).progress = 33;
        MaterialProgress.widget(dom.querySelector("#p3")).buffer = 87;

        (dom.querySelector("#slider") as dom.RangeInputElement).onInput.listen((final dom.Event event) {
            final int value = int.parse((event.target as dom.RangeInputElement).value);

            final component = new MaterialProgress(dom.querySelector("#p1"))
                ..progress = value
                ..classes.toggle("test");

            _logger.info("Value: ${component.progress}");
        });

    }
}

class RadioController extends DemoController {
    final Logger _logger = new Logger('main.RadioController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        MaterialRadio.widget(dom.querySelector("#wifi2")).disable();

    }
}

class SpinnerController extends DemoController {
    final Logger _logger = new Logger('main.SpinnerController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialSpinner spinner = MaterialSpinner.widget(dom.querySelector("#first"));
        final MaterialButton button = MaterialButton.widget(dom.querySelector("#button"));

        button.onClick.listen((_) {
            spinner.active = !spinner.active;
        });

    }
}

class DialogController extends DemoController {
    final Logger _logger = new Logger('main.DialogController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialButton btnAlertDialog = MaterialButton.widget(dom.querySelector("#alertdialog"));
        final MaterialButton btnConfirmDialog = MaterialButton.widget(dom.querySelector("#confirmdialog"));
        final MaterialButton btnCustomDialog = MaterialButton.widget(dom.querySelector("#customdialog"));

        final MaterialAlertDialog alertDialog = new MaterialAlertDialog();
        final MdlConfirmDialog confirmDialog = new MdlConfirmDialog();
        final CustomDialog customDialog = new CustomDialog();

        int mangoCounter = 0;

        btnAlertDialog.onClick.listen((_) {
            _logger.info("Click on AlertButton");
            alertDialog("Testmessage").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
        });

        btnConfirmDialog.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            confirmDialog("Testmessage").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
        });

        btnCustomDialog.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog(title: "Mango #${mangoCounter} (Fruit)",
            yesButton: "I buy it!", noButton: "Not now").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                mangoCounter++;
            });
        });
    }
}

class ToastController extends DemoController {
    final Logger _logger = new Logger('main.ToastController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialButton btnToast = MaterialButton.widget(dom.querySelector("#toast"));
        final MaterialButton btnWithAction = MaterialButton.widget(dom.querySelector("#withAction"));

        final MaterialToast toast = new MaterialToast();

        int mangoCounter = 0;

        void _makeSettings() {
            toast.position.left = MaterialCheckbox.widget(dom.querySelector("#checkbox-left")).checked;
            toast.position.top = MaterialCheckbox.widget(dom.querySelector("#checkbox-top")).checked;
            toast.position.right = MaterialCheckbox.widget(dom.querySelector("#checkbox-right")).checked;
            toast.position.bottom = MaterialCheckbox.widget(dom.querySelector("#checkbox-bottom")).checked;

            dom.querySelector("#container").classes.toggle("mdl-toast-container",
            MaterialCheckbox.widget(dom.querySelector("#checkbox-use-container")).checked);
        }

        btnToast.onClick.listen( (_) {
            _logger.info("Click on Toast");

            _makeSettings();
            toast("Toast message").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
        });

        btnWithAction.onClick.listen( (_) {
            _logger.info("Click on withAction");

            _makeSettings();
            toast("Toast message",confirmButton: "OK").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });

        });

    }
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
                    enter: view("views/badge.html", new BadgeController()))

        ..addRoute(name: 'button', path: '/button',
                    enter: view("views/button.html", new DemoController()))

        ..addRoute(name: 'card', path: '/card',
                    enter: view("views/card.html", new DemoController()))

        ..addRoute(name: 'checkbox', path: '/checkbox',
                    enter: view("views/checkbox.html", new DemoController()))

        ..addRoute(name: 'dialog', path: '/dialog',
            enter: view("views/dialog.html", new DialogController()))

        ..addRoute(name: 'footer', path: '/footer',
                    enter: view("views/footer.html", new DemoController()))

        ..addRoute(name: 'getting started', path: '/gettingstarted',
            enter: view("views/gettingstarted.html", new DemoController()))

        ..addRoute(name: 'grid', path: '/grid',
            enter: view("views/grid.html", new DemoController()))

        ..addRoute(name: 'icons', path: '/icons',
            enter: view("views/icons.html", new DemoController()))

        ..addRoute(name: 'icon-toggle', path: '/icon-toggle',
                    enter: view("views/icon-toggle.html", new IconToggleController()))

        ..addRoute(name: 'layout', path: '/layout',
                    enter: view("views/layout.html", new DemoController()))

        ..addRoute(name: 'list', path: '/list',
                    enter: view("views/list.html", new DemoController()))

        ..addRoute(name: 'menu', path: '/menu',
                    enter: view("views/menu.html", new MenuController()))

        ..addRoute(name: 'nav-pills', path: '/nav-pills',
            enter: view("views/nav-pills.html", new DemoController()))

        ..addRoute(name: 'palette', path: '/palette',
                    enter: view("views/palette.html", new DemoController()))

        ..addRoute(name: 'panel', path: '/panel',
            enter: view("views/panel.html", new DemoController()))

        ..addRoute(name: 'progress', path: '/progress',
                    enter: view("views/progress.html", new ProgressController()))

        ..addRoute(name: 'radio', path: '/radio',
                    enter: view("views/radio.html", new RadioController()))

        ..addRoute(name: 'shadow', path: '/shadow',
                    enter: view("views/shadow.html", new DemoController()))

        ..addRoute(name: 'samples', path: '/samples',
            enter: view("views/samples.html", new DemoController()))

        ..addRoute(name: 'slider', path: '/slider',
                    enter: view("views/slider.html", new DemoController()))

        ..addRoute(name: 'spinner', path: '/spinner',
                    enter: view("views/spinner.html", new SpinnerController()))

        ..addRoute(name: 'switch', path: '/switch',
                    enter: view("views/switch.html", new DemoController()))

        ..addRoute(name: 'tabs', path: '/tabs',
                    enter: view("views/tabs.html", new DemoController()))

        ..addRoute(name: 'templates', path: '/templates',
            enter: view("views/templates.html", new DemoController()))

        ..addRoute(name: 'textfield', path: '/textfield',
                    enter: view("views/textfield.html", new DemoController()))

        ..addRoute(name: 'theming', path: '/theming',
            enter: view("views/theming.html", new DemoController()))

        ..addRoute(name: 'toast', path: '/toast',
            enter: view("views/toast.html", new ToastController()))

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
        link.href = "https://cdn.rawgit.com/MikeMitterer/dart-mdl-theme/master/${theme}/material.min.css";

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