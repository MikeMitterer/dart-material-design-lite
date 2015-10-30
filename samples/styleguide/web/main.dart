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

import 'package:prettify/prettify.dart';
import 'package:di/di.dart' as di;

import "package:mdl/mdldialog.dart";

import "package:mdl_styleguide/customdialog1.dart";
import "package:mdl_styleguide/customdialog2.dart";

import "package:mdl_styleguide/todo.dart";

/**
 * Used for mdl-model sample
 */
@MdlComponentModel
class ModelTest {
    final ObservableProperty<String> minimodel = new ObservableProperty<String>("test");

    final ObservableProperty<String> os1 = new ObservableProperty<String>("");
    final ObservableProperty<String> os2 = new ObservableProperty<String>("");

    final ObservableProperty<String> wifi = new ObservableProperty<String>("never");

    final List<ObservableProperty<String>> lights = [ new ObservableProperty<String>(""), new ObservableProperty<String>("") ];

    final ObservableProperty<int> intensity = new ObservableProperty<int>(90);
}

/**
 * Application - you can get the Application via injector.getByKey(MDLROOTCONTEXT)
 */
@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    // Observe-Sample + DND
    final ObservableList<_Language>  languages = new ObservableList<_Language>();
    final ObservableProperty<String> time = new ObservableProperty<String>("", interval: new Duration(seconds: 1));
    final ObservableProperty<String> records = new ObservableProperty<String>("");
    final ObservableProperty<_Name>  nameObject = new ObservableProperty<_Name>(null);
    final ObservableProperty<bool>   isNameNull = new ObservableProperty<bool>(true);

    final List<_Name>                names = new List<_Name>();

    // To-Do-Sample
    final ObservableProperty<int> nrOfItems = new ObservableProperty<int>(0);
    final ObservableProperty<int> nrOfItemsDone = new ObservableProperty<int>(0,
        interval: new Duration(milliseconds: 500));
    
    // DND-Sample
    final ObservableList<_Language> natural = new ObservableList<_Language>();
    final ObservableList<_Language> programming = new ObservableList<_Language>();

    // Model-Sample
    final ModelTest modelTest = new ModelTest();

    // Attribute-Sample
    final ObservableProperty<bool> checkAttribute = new ObservableProperty<bool>(false);

    // Class-Sample
    final ObservableProperty<bool> checkBorder = new ObservableProperty<bool>(false);

    // Formatter-Sample
    final ObservableProperty<double> pi = new ObservableProperty<double>(3.14159265359);
    final ObservableProperty<String> name = new ObservableProperty<String>("Mike");
    final ObservableProperty<bool> checkStatus = new ObservableProperty<bool>(false);

    /// Title will be displayed
    final ObservableProperty<String> title = new ObservableProperty<String>("");

    Application() {
        _logger.info("Application created");

        records.observes(() => (languages.isNotEmpty ? languages.length.toString() : "<empty>"));
        time.observes(() => _getTime());
    }

    @override
    void run() {
    }

    /**
     * Observe + Repeat Sample
     * HTML-Part:
     *      <button ... data-mdl-click="remove({{language.name}})">Remove</button>
     */
    void remove(final String language) {
        _logger.info("Remove $language clicked!!!!!");

        final _Language lang = languages.firstWhere(
                (final _Language check) {
                final bool result = (check.name.toLowerCase() == language.toLowerCase());
                _logger.fine("Check: ${check.name} -> $language, Result: $result");

                return result;
            });

        if (language == "German") {
            int index = languages.indexOf(lang);
            languages[index] = new _Natural("Austrian");
        }
        else {
            languages.remove(lang);
        }
    }

    /// DND-Sample
    void addToProgrammingLanguages(final _Language language) {
        if(language.type == "programming") {
            if(!programming.contains(language)) {
                programming.add(language);
            }
        }
    }

    /// DND-Sample
    void addToNaturalLanguages(final _Language language) {
        if(language.type == "natural") {
            if(!natural.contains(language)) {
                natural.add(language);
            }
        }
    }

    /// DND-Sample
    void moveToTrash(final _Language language) {
        if(language.type == "programming" && programming.contains(language)) {
            programming.remove(language);

        } else if(language.type == "natural" && natural.contains(language)) {
            natural.remove(language);
        }
    }
    
    //- private -----------------------------------------------------------------------------------

    String _getTime() {
        final DateTime now = new DateTime.now();
        return "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(
            2, "0")}:${now.second.toString().padLeft(2, "0")}";
    }
}

class StyleguideModule extends di.Module {
    StyleguideModule() {
       // Nothing interesting here - just a reminder how to use a Module
    }
}

main() {
    final Logger _logger = new Logger('main.MaterialContent');

    configLogging();
    enableTheming();

    registerMdl();
    registerMdlDND();

    // registerDemoAnimation and import wskdemo.dart is on necessary for animation sample
    registerDemoAnimation();

    // register this Demo-Specific Component
    registerToDoItemComponent();

    componentFactory().rootContext(Application)
    .addModule(new StyleguideModule()).run()
    .then((final MaterialApplication application) {

        configRouter();

        application.run();
    });
}

/// Default Controller!!! PrettyPrints the source that comes within the "Usage" block
class DemoController extends MaterialController {
    final Logger _logger = new Logger('main.DemoController');

    @override
    void loaded(final Route route) {

        final Application app = componentFactory().application;
        app.title.value = route.name;

        final dom.HtmlElement element = dom.querySelector("#usage");

        if (element != null) {
            final MaterialInclude usage = MaterialInclude.widget(element);
            if (usage != null) {
                usage.onLoadEnd.listen((_) => prettyPrint());
            }
        }
        else {
            prettyPrint();
        }
        _logger.info("DemoController loaded!");
    }
// - private ------------------------------------------------------------------------------------------------------
}

class BadgeController extends DemoController {
    final Logger _logger = new Logger('main.BadgeController');

    bool stopTimer = false;

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialBadge badge1 = MaterialBadge.widget(dom.querySelector("#el1"));
        int counter = 1;
        new Timer.periodic(new Duration(milliseconds: 100), (final Timer timer) {
            if (counter > 199 || stopTimer) {
                counter = 1;
                timer.cancel();
                stopTimer = false;
            }
            badge1.value = counter.toString();
            _logger.info("Current Badge-Value: ${badge1.value}");

            counter++;
        });
    }

    @override
    void unload() {
        stopTimer = true;
    }
    // - private ------------------------------------------------------------------------------------------------------
}

class DialogController extends DemoController {
    final Logger _logger = new Logger('main.DialogController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialButton btnAlertDialog = MaterialButton.widget(dom.querySelector("#alertdialog"));
        final MaterialButton btnConfirmDialog = MaterialButton.widget(dom.querySelector("#confirmdialog"));
        final MaterialButton btnCustomDialog1 = MaterialButton.widget(dom.querySelector("#customdialog1"));
        final MaterialButton btnCustomDialog2 = MaterialButton.widget(dom.querySelector("#customdialog2"));

        final MaterialAlertDialog alertDialog = new MaterialAlertDialog();
        final MdlConfirmDialog confirmDialog = new MdlConfirmDialog();
        final CustomDialog1 customDialog1 = new CustomDialog1();
        final CustomDialog2 customDialog2 = new CustomDialog2();

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

        btnCustomDialog1.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog1(title: "Mango #${mangoCounter} (Fruit)",
                yesButton: "I buy it!", noButton: "Not now").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                mangoCounter++;
            });
        });

        btnCustomDialog2.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog2(title: "Form-Sample").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                if(status == MdlDialogStatus.OK) {
                    _logger.info("You entered: ${customDialog2.name.value}");
                }
            });
        });
    }
}

class DNDController extends DemoController {
    final Logger _logger = new Logger('main.DNDController');

    @override
    void loaded(final Route route) {
        super.loaded(route);
        
        _addLanguages();
    }

    @override
    void unload() {
        final Application  app = componentFactory().application;
        app.languages.clear();
        app.programming.clear();
        app.natural.clear();
    }

    // - private ------------------------------------------------------------------------------------------------------

    _addLanguages() {
        final Application  app = componentFactory().application;
        app.languages.add(new _Natural("English"));
        app.languages.add(new _Natural("German"));
        app.languages.add(new _Natural("Italian"));
        app.languages.add(new _Natural("French"));
        app.languages.add(new _Natural("Spanish"));

        app.languages.add(new _Programming("CPP"));
        app.languages.add(new _Programming("Dart"));
        app.languages.add(new _Programming("Java"));
    }
}

class FormatterController extends DemoController {
    final Logger _logger = new Logger('main.FormatterController');

    final List<String> xmen = ['Angel/Archangel', 'Apocalypse', 'Bishop', 'Beast','Caliban','Colossus',
    'Cyclops','Firestar','Emma Frost','Gambit','High Evolutionary','Dark Phoenix',
    'Marvel Girl','Iceman','Juggernaut','Magneto','Minos','Mr. Sinister','Mystique',
    'Nightcrawler','Professor X','Pyro','Psylocke','Rogue','Sabretooth','Shadowcat','Storm',
    'Talker','Wolverine','X-23' ];

    final Math.Random rnd = new Math.Random();

    bool cancelTimer = false;

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final Application app = componentFactory().application;

        cancelTimer = false;
        new Timer.periodic(new Duration(milliseconds: 500),(final Timer timer) {
            if(cancelTimer) {
                timer.cancel();
                return;
            }
            final int index = rnd.nextInt(xmen.length);
            app.name.value = xmen[index];

            app.checkStatus.value = index % 2;
            app.checkStatus.value = index % 2;
        });
    }

    @override
    void unload() {
        cancelTimer = true;
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

        final dom.HtmlElement element = dom.querySelector(".mdl-menu"); // first menu
        final MaterialMenu menu1 = MaterialMenu.widget(element);

//        void _addMessageDiv() {
//            final dom.HtmlElement element = dom.querySelectorAll(".mdl-menu__container").last.parent;
//            final dom.DivElement message = new dom.DivElement();
//
//            message.id = "message";
//            element.insertAdjacentElement("beforeEnd", message);
//        }

        void _showMessage(final int secsToClose) {
            final dom.DivElement message = dom.querySelector("#message");
            message.text = "Menu closes in ${secsToClose} seconds...";
            if (secsToClose <= 0) {
                message.text = "Closed!";
            }
        }

        menu1.show();
//        _addMessageDiv();
        _showMessage(TIMEOUT_IN_SECS);
        int tick = 0;
        new Timer.periodic(new Duration(milliseconds: 1000), (final Timer timer) {
            _showMessage(TIMEOUT_IN_SECS - tick - 1);
            if (tick >= TIMEOUT_IN_SECS - 1) {
                timer.cancel();
                menu1.hide();
            }
            tick++;
        });
    }
// - private ------------------------------------------------------------------------------------------------------
}

class NotificationController extends DemoController {
    final Logger _logger = new Logger('main.NotificationController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialButton btnNotification = MaterialButton.widget(dom.querySelector("#notification"));
        final MaterialTextfield title = MaterialTextfield.widget(dom.querySelector("#notification-title"));
        final MaterialTextfield subtitle = MaterialTextfield.widget(dom.querySelector("#notification-subtitle"));
        final MaterialTextfield content = MaterialTextfield.widget(dom.querySelector("#notification-content"));
        final MaterialRadioGroup notificationtype = MaterialRadioGroup.widget(dom.querySelector("#notification-type"));

        void _checkIfButtonShouldBeEnabled(_) {
            btnNotification.enabled = (title.value.isNotEmpty || content.value.isNotEmpty);
        }

        title.hub.onKeyUp.listen(_checkIfButtonShouldBeEnabled);
        content.hub.onKeyUp.listen(_checkIfButtonShouldBeEnabled);

        int counter = 0;
        btnNotification.onClick.listen((_) {
            _logger.info("Click on Notification");

            NotificationType type = NotificationType.INFO;
            if (notificationtype.hasValue) {
                switch (notificationtype.value) {
                    case "debug":
                        type = NotificationType.DEBUG;
                        break;
                    case "info":
                        type = NotificationType.INFO;
                        break;
                    case "warning":
                        type = NotificationType.WARNING;
                        break;
                    case "error":
                        type = NotificationType.ERROR;
                        break;
                    default:
                        type = NotificationType.INFO;
                }
            }
            _logger.info("NT ${notificationtype.value} - ${notificationtype.hasValue}");

            final MaterialNotification notification = new MaterialNotification();
            final String titleToShow = title.value.isNotEmpty ? "${title.value} (#${counter})" : "";

            notification(content.value, type: type, title: titleToShow, subtitle: subtitle.value)
            .show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
            counter++;
        });
    }

    // - private ------------------------------------------------------------------------------------------------------
}

@MdlComponentModel
class _Language {
    final String name;
    final String type;

    _Language(this.name, this.type);
}

class _Natural extends _Language {
    _Natural(final String name) : super(name, "natural");
}

class _Programming extends _Language {
    _Programming(final String name) : super(name,"programming");
}

@MdlComponentModel
class _Name {
    final String first;
    final String last;
    _Name(this.first, this.last);

    @override
    String toString() {
        return "$first $last";
    }
}

class ObserverController extends DemoController {
    final Logger _logger = new Logger('main.ObserverController');
    bool stopTimer = false;

    @override
    void loaded(final Route route) {
        super.loaded(route);
        stopTimer = false;

        _addLanguages();
        _addNames();
    }


    // - private ------------------------------------------------------------------------------------------------------

    void unload() {
        final Application app = componentFactory().application;
        stopTimer = true;

        app.languages.clear();
        app.names.clear();

    }

    void _addLanguages() {
        final Application app = componentFactory().application;

        app.languages.add(new _Natural("English"));
        app.languages.add(new _Natural("German"));
        app.languages.add(new _Natural("Italian"));
        app.languages.add(new _Natural("French"));
        app.languages.add(new _Natural("Spanish"));

        new Timer(new Duration(seconds: 2), () {
            for (int index = 0; index < 10; index++) {
                app.languages.add(new _Natural("Sample - $index"));
            }
        });
    }

    void _addNames() {
        final Application app = componentFactory().application;

        app.names.add(new _Name("Bill","Gates"));
        app.names.add(new _Name("Steven","Jobs"));
        app.names.add(new _Name("Larry","Page"));
        app.names.add(null);

        int counter = 0;
        new Timer.periodic(new Duration(milliseconds: 1000),(final Timer timer) {
            if(stopTimer) {
                timer.cancel();
                return;
            }

            app.nameObject.value = app.names[counter % 4]; // 0,1,2,...
            app.isNameNull.value = app.nameObject.value == null;

            counter++;
        });
    }

}

class ProgressController extends DemoController {
    final Logger _logger = new Logger('main.ProgressController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        // 1
        MaterialProgress.widget(dom.querySelector("#p1")).progress = 44;

        // 2
        MaterialProgress.widget(dom.querySelector("#p3")).progress = 33;
        MaterialProgress.widget(dom.querySelector("#p3")).buffer = 87;

        (dom.querySelector("#slider") as dom.RangeInputElement).onInput.listen((final dom.Event event) {
            final int value = int.parse((event.target as dom.RangeInputElement).value);

            final component = MaterialProgress.widget(dom.querySelector("#p1"))
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

        MaterialButton.widget(dom.querySelector("#show-wifi-value")).onClick.listen((_) {
            final MaterialRadioGroup group = MaterialRadioGroup.widget(dom.querySelector("#wifi"));
            final MaterialAlertDialog alertDialog = new MaterialAlertDialog();

            alertDialog("Value is: ${group.value}").show();
        });
    }
}

/// For Repeat-Sample
typedef void RemoveCallback(final Name name);

/// For Repeat-Sample
@MdlComponentModel
class Name {
    final Logger _logger = new Logger('main.Name');

    static int _counter = 0;
    int _id = 0;

    final RemoveCallback _callback;

    final String name;

    String get id => _id.toString();

    Name(this.name, this._callback) {
        _id = _counter++;
    }


    void clicked(final String value) {
        _logger.info("Clicked on $value");
    }

    void remove() {
        _logger.info("Remove ID $id");
        _callback(this);
    }
}

class RepeatController extends DemoController {
    final Logger _logger = new Logger('main.RepeatController');

    bool stop = false;

    @override
    void loaded(final Route route) {
        super.loaded(route);

        bool swapping = false;
        stop = false;

        final MaterialRepeat repeater = MaterialRepeat.widget(dom.querySelector(".mdl-repeat"));

        final List<Name> names = new List<Name>();
        final RemoveCallback removeCallback = (final Name nameToRemove) {
            if (swapping) {
                _logger.info("Removing items while swapping is not possible...");
                return;
            }

            _logger.info("Name to remove: ${nameToRemove.name}");
            repeater.remove(nameToRemove);
            names.remove(nameToRemove);
        };

        names.add(new Name("A - Nicki", removeCallback));
        names.add(new Name("B - Mike", removeCallback));
        names.add(new Name("C - Gerda", removeCallback));
        names.add(new Name("D - Sarah", removeCallback));

        for (int i = 0; i < 10; i++) {
            names.add(new Name("Name: $i", removeCallback));
        }

        void _swapItems() {
            final int FPS = (1000 / 5).ceil();
            int index = 0;
            swapping = true;

            int numberOwSwaps = 0;
            final int maxSwaps = names.length * 5;
            for (int i = 0; i < maxSwaps || stop == true; i++) {
                if (index >= names.length) {
                    index = 0;
                }
                final int index1 = index;
                final int index2 = index + 1 < names.length ? index + 1 : 0;

                _logger.fine("Swap $index1 with $index2");

                Timer timer;
                timer = new Timer(new Duration(milliseconds: (i + 1) * FPS), () async {
                    if (stop) {
                        timer.cancel();
                        swapping = false;
                        return new Future(() {});
                    }

                    _logger.fine("InnerSwap $index1 with $index2");

                    final item1 = names[index1];
                    final item2 = names[index2];

                    names[index1] = item2;
                    names[index2] = item1;

                    await repeater.swap(item1, item2);

                    numberOwSwaps++;
                    if (numberOwSwaps >= maxSwaps) {
                        swapping = false;
                    }
                });

                index++;
            }
        }

        Future.forEach(names, (final name) async {
            await repeater.add(name);
        }).then((_) {
            final Name name = names.first; // Nicki
            final String idForCheckbox = "#check-${name.id}";

            final MaterialCheckbox checkbox = MaterialCheckbox.widget(dom.querySelector(idForCheckbox));
            checkbox.check();

            _swapItems();
        });
    }

    @override
    void unload() {
        stop = true;
    }
}

class SliderController extends DemoController {
    final Logger _logger = new Logger('main.SliderController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialSlider slider2 = MaterialSlider.widget(dom.querySelector("#slider2"));
        final MaterialSlider slider4 = MaterialSlider.widget(dom.querySelector("#slider4"));

        slider2.hub.onChange.listen((_) {
            slider4.value = slider2.value;
        });
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

class SnackbarController extends DemoController {
    final Logger _logger = new Logger('main.SnackbarController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final MaterialButton btnToast = MaterialButton.widget(dom.querySelector("#toast"));
        final MaterialButton btnWithAction = MaterialButton.widget(dom.querySelector("#withAction"));

        final MaterialSnackbar snackbar = new MaterialSnackbar();

        int counter = 0;

        void _makeSettings() {
            snackbar.position.left = MaterialCheckbox.widget(dom.querySelector("#checkbox-left")).checked;
            snackbar.position.top = MaterialCheckbox.widget(dom.querySelector("#checkbox-top")).checked;
            snackbar.position.right = MaterialCheckbox.widget(dom.querySelector("#checkbox-right")).checked;
            snackbar.position.bottom = MaterialCheckbox.widget(dom.querySelector("#checkbox-bottom")).checked;

            dom.querySelector("#container").classes.toggle("mdl-snackbar-container",
                MaterialCheckbox.widget(dom.querySelector("#checkbox-use-container")).checked);
        }

        btnToast.onClick.listen((_) {
            _logger.info("Click on Toast");

            _makeSettings();
            snackbar("Snackbar message #${counter}").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
            counter++;
        });

        btnWithAction.onClick.listen((_) {
            _logger.info("Click on withAction");

            _makeSettings();
            snackbar("Snackbar message #${counter}", confirmButton: "OK").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
            counter++;
        });
    }
}

class ToDoController extends DemoController {
    final Logger _logger = new Logger('main.ToDoController');

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final Application app = componentFactory().application;
        final MaterialButton addButton = MaterialButton.widget(dom.querySelector("#add"));
        final MaterialTextfield item = MaterialTextfield.widget(dom.querySelector("#item"));
        final ToDoItemComponent todo = ToDoItemComponent.widget(dom.querySelector("#todo"));

        app.nrOfItems.observes( () => todo.items.length );
        app.nrOfItemsDone.observes(() {
            int done = 0;
            todo.items.forEach((final ToDoItem item) { done += item.checked ? 1 : 0; });
            return done;
        });

        addButton.onClick.listen((_) => _addItem());
        item.hub.onKeyDown.listen((final dom.KeyboardEvent event) {
            if(event.keyCode == 13) {
                event.preventDefault();
                event.stopPropagation();
                _addItem();
                item.value = "";
            }
        });
    }

    @override
    void unload() {
        final Application app = componentFactory().application;

        /// Cleanup - not really necessary but nice style
        app.nrOfItems.pause();
        app.nrOfItemsDone.pause();
    }

    //- private -----------------------------------------------------------------------------------

    void _addItem() {
        final MaterialTextfield item = MaterialTextfield.widget(dom.querySelector("#item"));
        final ToDoItemComponent todo = ToDoItemComponent.widget(dom.querySelector("#todo"));

        todo.addItemOnTop(new ToDoItem(false,"Cnt ${todo.incrementalIndex} (${item.value})"));
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

        ..addRoute(name: 'attribute', path: '/attribute',
            enter: view("views/attribute.html", new DemoController()))

        ..addRoute(name: 'badge', path: '/badge',
            enter: view("views/badge.html", new BadgeController()))

        ..addRoute(name: 'button', path: '/button',
            enter: view("views/button.html", new DemoController()))

        ..addRoute(name: 'card', path: '/card',
            enter: view("views/card.html", new DemoController()))

        ..addRoute(name: 'contribute', path: '/contribute',
            enter: view("views/contribute.html", new DemoController()))

        ..addRoute(name: 'checkbox', path: '/checkbox',
            enter: view("views/checkbox.html", new DemoController()))

        ..addRoute(name: 'class', path: '/class',
            enter: view("views/class.html", new DemoController()))

        ..addRoute(name: 'data-table', path: '/data-table',
            enter: view("views/data-table.html", new DemoController()))

        ..addRoute(name: 'dialog', path: '/dialog',
            enter: view("views/dialog.html", new DialogController()))

        ..addRoute(name: 'dnd', path: '/dnd',
            enter: view("views/dnd.html", new DNDController()))

        ..addRoute(name: 'footer', path: '/footer',
            enter: view("views/footer.html", new DemoController()))

        ..addRoute(name: 'formatter', path: '/formatter',
            enter: view("views/formatter.html", new FormatterController()))

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

        ..addRoute(name: 'materialdesign', path: '/materialdesign',
            enter: view("views/materialdesign.html", new DemoController()))

        ..addRoute(name: 'menu', path: '/menu',
            enter: view("views/menu.html", new MenuController()))

        ..addRoute(name: 'model', path: '/model',
            enter: view("views/model.html", new DemoController()))

        ..addRoute(name: 'nav-pills', path: '/nav-pills',
            enter: view("views/nav-pills.html", new DemoController()))

        ..addRoute(name: 'notification', path: '/notification',
            enter: view("views/notification.html", new NotificationController()))

        ..addRoute(name: 'observe', path: '/observe',
            enter: view("views/observe.html", new ObserverController()))

        ..addRoute(name: 'palette', path: '/palette',
            enter: view("views/palette.html", new DemoController()))

        ..addRoute(name: 'panel', path: '/panel',
            enter: view("views/panel.html", new DemoController()))

        ..addRoute(name: 'progress', path: '/progress',
            enter: view("views/progress.html", new ProgressController()))

        ..addRoute(name: 'quickstart', path: '/quickstart',
            enter: view("views/quickstart.html", new DemoController()))

        ..addRoute(name: 'radio', path: '/radio',
            enter: view("views/radio.html", new RadioController()))

        ..addRoute(name: 'repeat', path: '/repeat',
            enter: view("views/repeat.html", new RepeatController()))

        ..addRoute(name: 'shadow', path: '/shadow',
            enter: view("views/shadow.html", new DemoController()))

        ..addRoute(name: 'samples', path: '/samples',
            enter: view("views/samples.html", new DemoController()))

        ..addRoute(name: 'slider', path: '/slider',
            enter: view("views/slider.html", new SliderController()))

        ..addRoute(name: 'snackbar', path: '/snackbar',
            enter: view("views/snackbar.html", new SnackbarController()))

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

        ..addRoute(name: 'tooltip', path: '/tooltip',
            enter: view("views/tooltip.html", new DemoController()))

        ..addRoute(name: 'todo', path: '/todo',
            enter: view("views/todo.html", new ToDoController()))

        ..addRoute(name: 'typography', path: '/typography',
            enter: view("views/typography.html", new DemoController()))


        ..addRoute(name: 'home', defaultRoute: true, path: '/',
            enter: view("views/home.html", new DemoController()))

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