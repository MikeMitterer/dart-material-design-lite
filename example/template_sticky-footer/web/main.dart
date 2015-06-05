import 'dart:html' as html;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

final Logger _logger = new Logger('layout-header-drawer-footer');

void main() {
    configLogging();

    scrollChecker();

    registerMdl();
    componentFactory().run().then((_) {

    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}

void scrollChecker() {
    final html.HtmlElement body = html.querySelector("body");

    // .wsk-layout__content section hat overflow: scroll - kein scroll event
    final html.HtmlElement content = html.querySelector(".wsk-layout__content section");

    final html.HtmlElement shadow = html.querySelector(".addscrollshadow");
    final html.ButtonElement button = html.querySelector("#totop");

    _logger.info(button);
    if(content == null || shadow == null || button == null) {
        return;
    }

    button.onClick.listen((_) {
        content.scrollTop = 0;
    });

    content.onScroll.listen((final html.Event event) {
        final int top = content.scrollTop;
        print(top);
        if(top > 25) {
            shadow.classes.add("wsk-shadow--z2");
        } else {
            shadow.classes.remove("wsk-shadow--z2");
        }

        if(top > 100) {
            body.classes.add("add-back-to-top-button");
        } else {
            body.classes.remove("add-back-to-top-button");
        }

    });
}