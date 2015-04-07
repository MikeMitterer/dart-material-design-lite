import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_material/wskdemo.dart';

main() {
    configLogging();

    registerAllWskComponents();

    upgradeAllRegistered().then((_) {

        final MaterialSlider slider5 = MaterialSlider.widget(dom.querySelector("#slider5"));
        final MaterialSlider slider2 = MaterialSlider.widget(dom.querySelector("#slider2"));

        slider5.onChange.listen((_) {
            slider2.value = slider5.value;
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