import "dart:html" as dom;
import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_material/wskdemo.dart';

main() {
    final Logger _logger = new Logger('main.MaterialContent');

    configLogging();

    registerAllWskComponents();

    upgradeAllRegistered().then((_) {
        final MaterialContent main = MaterialContent.widget(dom.querySelector("#main"));

        int counter = 1;
        new Timer.periodic(new Duration(milliseconds: 1000), (final Timer timer) {

            final String id = "dyn${counter}";
            main.setContent('''
                <div id="${id}outer">
                    <div class="innerdiv">Content $counter</div>
                    <div id="${id}" class="wsk-js-progress"></div>
                </div>
            '''.trim()).then((_) {

                final MaterialProgress progress = MaterialProgress.widget(dom.querySelector("#$id"));
                progress.progress = 50;
            });

            _logger.info("Tick...");

            counter++;
            if(counter > 5) {
                timer.cancel();
            }
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