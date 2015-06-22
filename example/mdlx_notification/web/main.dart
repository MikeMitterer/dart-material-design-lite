import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

main() {
    final Logger _logger = new Logger('dialog.Main');

    configLogging();

    registerMdl();

    componentFactory().run().then((_) {
        final MaterialButton btnNotification = MaterialButton.widget(dom.querySelector("#notification"));

        int counter = 0;
        btnNotification.onClick.listen( (_) {
            _logger.info("Click on Notification");

            final MaterialNotification notification = new MaterialNotification();
            notification("Hi ${counter}").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
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