import "dart:html" as dom;
import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

main() {
    final Logger _logger = new Logger('main.MaterialBadge');

    configLogging();

    registerMdl();

    componentFactory().run().then((_) {
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
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}