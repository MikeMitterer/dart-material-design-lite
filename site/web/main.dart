import 'dart:html' as dom;
import "dart:async";
import "dart:math" as Math;
import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:prettify/prettify.dart';

final Logger _logger = new Logger('layout-header-drawer-footer');

main() async {
    configLogging();

    registerMdl();
    await componentFactory().run();
    prettyPrint();
    prepareScrolling();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}

/**
 * Iterates through all anchors (mdl-navigation__link) but excludes those with
 * an empty hash
 */
void prepareScrolling() {
    final dom.HtmlElement body = dom.querySelector("body");
    final dom.HtmlElement content = dom.querySelector(".mdl-layout__content");

    final List<dom.AnchorElement> anchors =
        dom.querySelectorAll('a.mdl-navigation__link-animated[href^="#"]:not([href="#"])') as List<dom.AnchorElement>;

    double _easingPattern(final String type,double time ) {
        double pattern = 0.0;
        if ( type == 'easeInQuad' ) pattern = time * time; // accelerating from zero velocity
        if ( type == 'easeOutQuad' ) pattern = time * (2 - time); // decelerating to zero velocity
        if ( type == 'easeInOutQuad' ) pattern = time < 0.5 ? 2 * time * time : -1 + (4 - 2 * time) * time; // acceleration until halfway, then deceleration
        if ( type == 'easeInCubic' ) pattern = time * time * time; // accelerating from zero velocity
        if ( type == 'easeOutCubic' ) pattern = (--time) * time * time + 1; // decelerating to zero velocity
        if ( type == 'easeInOutCubic' ) pattern = time < 0.5 ? 4 * time * time * time : (time - 1) * (2 * time - 2) * (2 * time - 2) + 1; // acceleration until halfway, then deceleration
        if ( type == 'easeInQuart' ) pattern = time * time * time * time; // accelerating from zero velocity
        if ( type == 'easeOutQuart' ) pattern = 1 - (--time) * time * time * time; // decelerating to zero velocity
        if ( type == 'easeInOutQuart' ) pattern = time < 0.5 ? 8 * time * time * time * time : 1 - 8 * (--time) * time * time * time; // acceleration until halfway, then deceleration
        if ( type == 'easeInQuint' ) pattern = time * time * time * time * time; // accelerating from zero velocity
        if ( type == 'easeOutQuint' ) pattern = 1 + (--time) * time * time * time * time; // decelerating to zero velocity
        if ( type == 'easeInOutQuint' ) pattern = time < 0.5 ? 16 * time * time * time * time * time : 1 + 16 * (--time) * time * time * time * time; // acceleration until halfway, then deceleration

        return pattern != 0.0 ? pattern : time; // no easing, no acceleration
    }

    void _startAnimation(final int endLocation) {
        final dom.HtmlElement body = dom.querySelector("body");
        int timeLapsed = 0;
        int speed = 750;
        double percentage;
        int startLocation = content.scrollTop;
        int distance = endLocation - startLocation;
        double step = 0.0;

        new Timer.periodic(new Duration(milliseconds: 16),(final Timer timer) {
            timeLapsed += 16;
            percentage = timeLapsed / speed;
            percentage = percentage > 1.0 ? 1.0 : percentage;

            step = startLocation + (distance.toDouble() * _easingPattern("easeInOutQuad",percentage));
            content.scrollTop = step.toInt();

            //_logger.info("Scroll: Step $step (Offset $endLocation) Perc $percentage Pos: ${content.scrollTop}");

            if(percentage >= 1.0) {
                timer.cancel();
            }
        });
    }


    anchors.forEach((final dom.HtmlElement element) {
        final dom.AnchorElement anchor = element;
        anchor.onClick.listen((final dom.MouseEvent event) {
            final String targetName = anchor.href.trim().replaceFirst(new RegExp(r".*#"),"");
            final dom.AnchorElement target = dom.querySelector('[name="$targetName"]');
            //_logger.info('[name="$targetName"]');

            if(target != null) {
                int offset = target.offsetTo(body).y - 60;
                if(offset < 100) {
                    offset = 0;
                }

                //content.scrollTop = offset - 64 - 60;
                //html.scrollTop = offset;
                event.stopPropagation();
                event.preventDefault();
                //_logger.info("Scroll! (${body.scrollTop}) - Offset: ${offset}");

                anchors.forEach((final dom.HtmlElement anchor) => anchor.classes.remove("is-active"));
                anchor.classes.add("is-active");

                if(offset != content.scrollTop) {
                    _startAnimation(offset);
                }
            }
        });
    });
}
