import 'dart:html' as html;
import "dart:async";
import 'dart:js';
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_material/wskcomponets.dart';

final Logger _logger = new Logger('example.Styleguide');

const String LOADER_TEXT = "Wait! Loading {{nrofiframes}} iframes...";

main() {
    configLogging();
    loadDemos();

    registerAllWskComponents();
    upgradeAllRegistered();
}

void loadDemos() {
    final html.HtmlElement navList = html.querySelector('#main-navigation');
    int totalDemosPendingLoading = 0;
    html.HtmlElement _drawer = null;

    html.HtmlElement getDrawer() {
        if(_drawer == null) { _drawer = html.querySelector('.wsk-layout__drawer'); }
        return _drawer;
    }

    void _sizeDemo(final html.HtmlElement rootDemoElement) {
        final html.IFrameElement iframe = rootDemoElement.querySelector("iframe");
        if (iframe == null) {
            totalDemosPendingLoading--;
            return;
        }

        _setLoaderInfo(totalDemosPendingLoading);
        iframe.onLoad.listen((final html.Event event) {
            _setLoaderInfo(totalDemosPendingLoading);

            var jsIFrame = new JsObject.fromBrowserObject(iframe);
            // contentDocument.documentElement is not implemented in Dart!!!!!
            int contentHeight = jsIFrame["contentDocument"]["documentElement"]["scrollHeight"];
            // Durch den Loader stimmt die Höhe nicht mehr - default auf 4500!
            contentHeight = Math.max(4500,contentHeight);

            iframe.style.height = "${contentHeight * 1.2}px";
            iframe.classes.add("heightSet");
            totalDemosPendingLoading--;
            _setLoaderInfo(totalDemosPendingLoading);

            if (totalDemosPendingLoading <= 0) {
                html.querySelector("body").classes.add("demosLoaded");
                html.querySelector("body").classes.remove("loadingDemos");
            }
        });
    }

    void _sizeDemos() {
        final List<html.Element> demos = html.querySelectorAll('.styleguide-demo');
        totalDemosPendingLoading = demos.length;

        _setLoaderInfo(totalDemosPendingLoading);
        for (int i = 0;i < demos.length;i++) {
            new Future.delayed(new Duration(milliseconds: 200),() {
            final String demoTitle = (demos[i].querySelector('h5') as html.HtmlElement).text ;
            final String anchorLink = 'demo-$i';

            // Add list item
            final html.AnchorElement navAnchor = new html.AnchorElement();
            navAnchor.classes.add('wsk-navigation__link');
            navAnchor.href = '#' + anchorLink;
            navAnchor.append(new html.Text("${demoTitle}"));
            navList.append(navAnchor);

            navAnchor.onClick.listen((final html.MouseEvent event) {
                print("Test");
                if(getDrawer() != null) {
                    getDrawer().classes.remove("is-visible");
                }
            });


            final html.AnchorElement anchor = new html.AnchorElement();
            anchor.id = anchorLink;
            demos[i].insertBefore(anchor, demos[i].querySelector('h5'));

            // Size iframe
            _sizeDemo(demos[i]);
            });
        }
    }

    _sizeDemos();
}

void _setLoaderInfo(final int nrOfFramesLeft) {
    new Future(() {
        final html.HtmlElement element = html.querySelector('div.loader') as html.HtmlElement;
        if(element != null) {
            element.text = LOADER_TEXT.replaceFirst("{{nrofiframes}}","$nrOfFramesLeft");
        }
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}