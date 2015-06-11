import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

typedef void RemoveCallback(final Name name);

@MdlComponentModel
class Name {
    final Logger _logger = new Logger('main.Name');

    static int _counter = 0;
    int _id = 0;

    final RemoveCallback _callback;

    final String name;

    String get id => _id.toString();

    Name(this.name,this._callback) { _id = _counter++; }


    void clicked(final String value) {
        _logger.info("Clicked on $value");
    }

    void remove() {
        _logger.info("Remove ID $id");
        _callback(this);
    }
}

main() {
    final Logger _logger = new Logger('main.MaterialRepeat');

    configLogging();

    registerMdl();

    componentFactory().run().then((_) async {
        final MaterialRepeat repeater = MaterialRepeat.widget(dom.querySelector(".mdl-repeat"));
        repeater.visualDebugging = true;

        final List<Name> names = new List<Name>();
        final RemoveCallback removeCallback = (final Name nameToRemove) {
            _logger.info("Name to remove: ${nameToRemove.name}");

            repeater.remove(nameToRemove);
            names.remove(nameToRemove);
        };

        names.add(new Name("A - Nicki",removeCallback));
        names.add(new Name("B - Mike",removeCallback));
        names.add(new Name("C - Gerda",removeCallback));
        names.add(new Name("D - Sarah",removeCallback));

        await Future.forEach(names, (final name) async {
            await repeater.add(name);
        });

//        new Timer(new Duration(milliseconds: 500), () {
//            final name = names.getRange(2,3).first;
//            names.remove(name);
//            repeater.remove(name);
//        });

//        final hudriwudri = new Name("HudriWudri",removeCallback);
//        new Timer(new Duration(milliseconds: 1500), () {
//            names.insert(2,hudriwudri);
//            repeater.insert(2,hudriwudri);
//        });

//        new Timer(new Duration(milliseconds: 2500), () {
//            names.remove(hudriwudri);
//            repeater.remove(hudriwudri);
//        });

//        new Timer(new Duration(milliseconds: 500), () {
//            int index1 = 2;
//            int index2 = 0;
//
//            final item1 = names[index1];
//            final item2 = names[index2];
//
//            _logger.info("Swap in main: ${item1.name} -> ${item2.name}");
//            names[index2] = item2;
//            names[index1] = item1;
//            repeater.swap(item1,item2);
//        });

        new Timer(new Duration(milliseconds: 1000), () {
            Stopwatch stopwatch = new Stopwatch()..start();
            final List<Future> futures = new List<Future>();

            int i = 0;
            for(;i < 1000;i++) {
                final name = new Name("Name: $i",removeCallback);

                names.add(name);
                futures.add(repeater.add(name));
            }
            Future.wait(futures).then((_) {
                stopwatch.stop();
                _logger.info("Adding ${i} number of items took ${stopwatch.elapsedMilliseconds}ms");
            });
        });

        new Timer(new Duration(milliseconds: 2000), ()  {
            final int FPS = (1000 / 50).ceil();
            _logger.info("Frames per sec: ${(1000 / FPS).ceil() }");

            int index = 0;
            for(int i = 0;i < names.length * 10;i++)  {
                if(index >= names.length) {
                    index = 0;
                }
                final int index1 = index;
                final int index2 = index + 1 < names.length ? index + 1 : 0;

                _logger.info("Swap $index1 with $index2");

                new Future.delayed(new Duration(milliseconds: (i + 1) * FPS ), () async {

                    _logger.info("InnerSwap $index1 with $index2");

                    final item1 = names[index1];
                    final item2 = names[index2];

                    names[index1] = item2;
                    names[index2] = item1;

                    await repeater.swap(item1,item2);
                });

                index++;
            }
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