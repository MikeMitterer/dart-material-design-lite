import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl/mdldemo.dart';

main() {
    configLogging();

    // registerDemoAnimation and import mdldemo.dart is only necessary for animation sample
    registerDemoAnimation();
    registerMdl();

    componentFactory().run().then((_){

    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}