import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdlcomponets.dart';
import 'package:mdl/mdldemo.dart';

main() {
    final Logger _logger = new Logger('example.progress.main');

    configLogging();

    //    dom.document.registerElement('wsk-progress', MaterialProgress);
    //    dom.HtmlElement element = dom.querySelector("#p1");
    //    final MaterialProgress progress = new MaterialProgress();
    //    element.xtag = progress;
    //
    //    progress.init(element);
    //    element = dom.querySelector("#p1");
    //    element.xtag.setProgress(10);

    // registerDemoAnimation and import wskdemo.dart is on necessary for animation sample
    registerDemoAnimation();
    registerAllWskComponents();

    upgradeAllRegistered().then((_) {
        _logger.info("All components upgraded");

        // 1
        new MaterialProgress(dom.querySelector("#p1")).progress = 44;

        // 2
        MaterialProgress.widget(dom.querySelector("#p3")).progress = 33;
        MaterialProgress.widget(dom.querySelector("#p3")).buffer = 87;

        (dom.querySelector("#slider") as dom.RangeInputElement).onInput.listen((final dom.Event event) {
            final int value = int.parse((event.target as dom.RangeInputElement).value);

            final component = new MaterialProgress(dom.querySelector("#p1"))
                ..progress = value
                ..classes.toggle("test");

            _logger.info("Value: ${component.progress}");
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
