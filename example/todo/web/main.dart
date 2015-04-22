import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlremote.dart';

import 'package:route_hierarchical/client.dart';

import "package:mdl_todo_sample/todo.dart";

main() {
    final Logger _logger = new Logger('main.ToDo');

    configLogging();

    registerMdl();
    registerToDoItemComponent();

    upgradeAllRegistered().then((_) {
        final MaterialButton addButton = MaterialButton.widget(dom.querySelector("#add"));
        final MaterialTextfield item = MaterialTextfield.widget(dom.querySelector("#item"));
        final ToDoItemComponent items = ToDoItemComponent.widget(dom.querySelector("#todo"));

        addButton.onClick.listen((_) {
            _logger.info(item.value);
            items.addItem(new ToDoItem(false,item.value));
        });

    });
}


void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}