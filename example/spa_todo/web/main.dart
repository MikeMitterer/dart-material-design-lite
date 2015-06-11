import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

import "package:mdl_todo_sample/todo.dart";

main() {
    final Logger _logger = new Logger('main.ToDo');

    configLogging();

    registerMdl();
    registerToDoItemComponent();

    componentFactory().run().then((_) {

        final MaterialButton addButton = MaterialButton.widget(dom.querySelector("#add"));
        final MaterialTextfield item = MaterialTextfield.widget(dom.querySelector("#item"));
        final ToDoItemComponent items = ToDoItemComponent.widget(dom.querySelector("#todo"));
        final dom.SpanElement nrofitems = dom.querySelector("#nrofitems");

        void _setNrOfItems() {
            nrofitems.text = items.items.length.toString();
        }
        _setNrOfItems();

        addButton.onClick.listen((_) {
            _logger.info(item.value);
            items.addItem(new ToDoItem(false,"Cnt ${items.incrementalIndex} (${item.value})"));
            _setNrOfItems();
        });

        items.onModelChange.listen((_) => _setNrOfItems());

    });
}


void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}