import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

import 'package:prettify/prettify.dart';

main() {
    final Logger _logger = new Logger('main.MaterialInclude');

    configLogging();

    registerMdl();

    componentFactory().run().then((_) {
        final MaterialInclude include = MaterialInclude.widget(dom.querySelector("#main"));

        include.onLoadEnd.listen((_) {

            prettyPrint();
            _logger.info("Loaded");
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