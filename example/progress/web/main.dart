import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_material/wskdemo.dart';

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

        MaterialProgress.widget(dom.querySelector("#p1")).setProgress(44);
        MaterialProgress.widget(dom.querySelector("#p3")).setProgress(33);
        MaterialProgress.widget(dom.querySelector("#p3")).setBuffer(87);
//        _logger.info(p1);

//        var e = new JsObject.fromBrowserObject(p1);
//        (e["widget"] as MaterialProgress).setProgress(44);

    });

}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}