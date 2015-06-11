import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

main() {
    final Logger _logger = new Logger('main.MaterialRepeat');

    configLogging();

    registerMdl();

    componentFactory().run().then((_) async {
        final MaterialRepeat repeater = MaterialRepeat.widget(dom.querySelector(".mdl-repeat"));

        final List names = new List();

        names.add({ 'name' : "Nicki", 'type' : "Animal"});
        names.add({"name" : "Mike"});
        names.add({"name" : "Gerda"});
        names.add({"name" : "Sarah"});

        await Future.forEach(names, (final name) async {
            await repeater.add(name);
        });

        new Timer(new Duration(milliseconds: 500), () {
            repeater.remove(names.getRange(2,3).first);
        });

        final hudriwudri = {'name' : "HudriWudri"};
        new Timer(new Duration(milliseconds: 1000), () {
            repeater.insert(3,hudriwudri);
        });

        new Timer(new Duration(milliseconds: 1500), () {
            repeater.remove(hudriwudri);
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