import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

main() async {
    final Logger _logger = new Logger('mdl_radio.main');

    configLogging();

    registerMdl();

    await componentFactory().run();
    MaterialRadio.widget(dom.querySelector("#wifi2")).disable();

    MaterialButton.widget(dom.querySelector("#show-wifi-value")).onClick.listen((_) {

        final MaterialRadioGroup group = MaterialRadioGroup.widget(dom.querySelector("#wifi"));
        final MaterialAlertDialog alertDialog = new MaterialAlertDialog();

        alertDialog("Value is: ${group.value}").show();
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}