import "dart:html" as dom;
import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdlcomponets.dart';
import 'package:mdl/mdldemo.dart';

main() {
    const int TIMEOUT_IN_SECS = 5;

    configLogging();

    registerAllWskComponents();

    upgradeAllRegistered().then((_) {
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
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}