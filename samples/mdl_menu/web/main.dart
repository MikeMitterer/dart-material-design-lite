import "dart:html" as dom;
import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

main() {
    const int TIMEOUT_IN_SECS = 5;

    configLogging();

    registerMdl();

    componentFactory().run().then((_) {
        final dom.HtmlElement element = dom.querySelector(".mdl-menu");
        final MaterialMenu menu1 = MaterialMenu.widget(element);

        void _showMessage(final int secsToClose) {
            final dom.DivElement message = dom.querySelector("#message");
            message.text = "Menu closes in ${secsToClose} seconds...";
            if(secsToClose <= 0) {
                message.text = "Closed!";
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