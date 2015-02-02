import 'dart:html' as html;
import 'dart:js';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_material/wskcomponets.dart';

final Logger _logger = new Logger('example.Styleguide');

main() {
    configLogging();
    loadDemos();

    registerAllWskComponents();
    upgradeAllRegistered();
}

void loadDemos() {
    final html.HtmlElement navList = html.querySelector('#main-navigation');
    int totalDemosPendingLoading = 0;

    void _sizeDemo(final html.HtmlElement rootDemoElement) {
        final html.IFrameElement iframe = rootDemoElement.querySelector("iframe");
        if (iframe == null) {
            totalDemosPendingLoading--;
            return;
        }

        iframe.onLoad.listen((final html.Event event) {

            var jsIFrame = new JsObject.fromBrowserObject(iframe);
            // contentDocument.documentElement is not implemented in Dart!!!!!
            final int contentHeight = jsIFrame["contentDocument"]["documentElement"]["scrollHeight"];

            iframe.style.height = "${contentHeight}px";
            iframe.classes.add("heightSet");
            totalDemosPendingLoading--;
            if (totalDemosPendingLoading <= 0) {
                html.querySelector("body").classes.add("demosLoaded");
            }
        });
    }

    void _sizeDemos() {
        final List<html.HtmlElement> demos = html.querySelectorAll('.styleguide-demo');
        totalDemosPendingLoading = demos.length;

        for (int i = 0;i < demos.length;i++) {
            final String demoTitle = (demos[i].querySelector('h1') as html.HtmlElement).text ;
            final String anchorLink = 'demo-$i';

            // Add list item
            final html.AnchorElement navAnchor = new html.AnchorElement();
            navAnchor.classes.add('wsk-navigation__link');
            navAnchor.href = '#' + anchorLink;
            navAnchor.append(new html.Text("${demoTitle}"));
            navList.append(navAnchor);

            final html.AnchorElement anchor = new html.AnchorElement();
            anchor.id = anchorLink;
            demos[i].insertBefore(anchor, demos[i].querySelector('h1'));

            // Size iframe
            _sizeDemo(demos[i]);
        }
    }

    _sizeDemos();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}