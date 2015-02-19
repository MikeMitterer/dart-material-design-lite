import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_material/wskcomponets.dart';

main() {
    configLogging();
    registerAllWskComponents();
    upgradeAllRegistered();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}