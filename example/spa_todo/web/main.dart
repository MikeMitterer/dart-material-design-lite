import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';

import "package:mdl_todo_sample/todo.dart";

@MdlComponentModel @di.Injectable()
class AppController extends MdlAppController {
    final Logger _logger = new Logger('main.AppController');

    final ObservableProperty<String> nrOfItems = new ObservableProperty<String>("");

    AppController() {
        _logger.info("AppController");
    }

    void run() {
        final MaterialButton addButton = MaterialButton.widget(dom.querySelector("#add"));
        final MaterialTextfield item = MaterialTextfield.widget(dom.querySelector("#item"));
        final ToDoItemComponent todo = ToDoItemComponent.widget(dom.querySelector("#todo"));

        nrOfItems.observes( () => todo.items.length > 0 ? todo.items.length.toString() : "<no records>");

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

    //- private -----------------------------------------------------------------------------------

    void _addItem() {
        final MaterialTextfield item = MaterialTextfield.widget(dom.querySelector("#item"));
        final ToDoItemComponent todo = ToDoItemComponent.widget(dom.querySelector("#todo"));

        todo.addItem(new ToDoItem(false,"Cnt ${todo.incrementalIndex} (${item.value})"));
    }
}

main() {
    final Logger _logger = new Logger('main.ToDo');

    configLogging();

    registerMdl();
    registerToDoItemComponent();

    componentFactory().rootContext(AppController).run().then( (final MdlAppController controller) {
        controller.run();
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}
