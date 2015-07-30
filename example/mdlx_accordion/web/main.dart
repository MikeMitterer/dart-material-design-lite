import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

main() async {
    configLogging();

    registerMdl();

    await componentFactory().run();

    final dom.ButtonElement btn = new dom.ButtonElement()
        ..text = "Click me"
        ..id = "mybutton"
    ;

    btn.className = "mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored";
    btn.style.marginTop = "12px";

    await componentHandler().upgradeElement(btn);
    dom.querySelector(".demo-section").append(btn);

    final MaterialButton button = MaterialButton.widget(dom.querySelector("#mybutton"));
    button.disable();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}