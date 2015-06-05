import 'dart:html' as html;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

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
    final html.HtmlElement content = html.querySelector(".mdl-layout__content");
    final html.HtmlElement shadow = html.querySelector(".addscrollshadow");
    final html.ButtonElement button = html.querySelector("#totop");

    if(content == null || shadow == null || button == null) {
        return;
    }

    button.onClick.listen((_) {
        content.scrollTop = 0;
    });

    content.onScroll.listen((final html.Event event) {
        final int top = content.scrollTop;

        if(top > 25) {
            shadow.classes.add("mdl-shadow--z2");
        } else {
            shadow.classes.remove("mdl-shadow--z2");
        }

        if(top > 100) {
            body.classes.add("add-back-to-top-button");
        } else {
            body.classes.remove("add-back-to-top-button");
        }

    });
}