import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

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


    componentFactory().run(enableVisualDebugging: true).then((_) {

        Future _addNamesProgrammatically() async {
            final Logger _logger = new Logger('main._addNamesProgrammatically');

            final MaterialRepeat repeater = MaterialRepeat.widget(dom.querySelector("#main"));

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

            void _test0(final int milliseconds) {

                new Timer(new Duration(milliseconds: milliseconds), () {
                    final name = names.getRange(1, 2).first; // Mike
                    final String idForCheckbox = "#check-${name.id}";

                    final MaterialCheckbox checkbox = MaterialCheckbox.widget(dom.querySelector(idForCheckbox));
                    checkbox.check();
                    // check it!
                });
            }

            void _test1(final int milliseconds) {
                new Timer(new Duration(milliseconds: milliseconds), () {
                    final name = names.getRange(2,3).first;
                    names.remove(name);
                    repeater.remove(name);
                });
            }

            void _test2(final int milliseconds) {

                final hudriwudri = new Name("HudriWudri",removeCallback);
                new Timer(new Duration(milliseconds: milliseconds), () {
                    names.insert(2,hudriwudri);
                    repeater.insert(2,hudriwudri);
                });

                new Timer(new Duration(milliseconds: milliseconds + 1000), () {
                    names.remove(hudriwudri);
                    repeater.remove(hudriwudri);
                });
            }

            void _test3(final int milliseconds) {
                new Timer(new Duration(milliseconds: milliseconds), () async {
                    int index1 = 1;
                    int index2 = 2;

                    final item1 = names[index1];
                    final item2 = names[index2];

                    _logger.fine("Swap in main: ${item1.name} -> ${item2.name}");
                    names[index2] = item1;
                    names[index1] = item2;
                    await repeater.swap(item1,item2);
                });
            }

            void _test4(final int milliseconds) {
                new Timer(new Duration(milliseconds: milliseconds), () {
                    Stopwatch stopwatch = new Stopwatch()
                        ..start();
                    final List<Future> futures = new List<Future>();

                    int i = 0;
                    for (;i < 10;i++) {
                        final name = new Name("Name: $i", removeCallback);

                        names.add(name);
                        futures.add(repeater.add(name));
                    }
                    Future.wait(futures).then((_) {
                        stopwatch.stop();
                        _logger.info("Adding ${i} number of items took ${stopwatch.elapsedMilliseconds}ms");
                    });
                });
            }

            void _test5(final int milliseconds) {

                new Timer(new Duration(milliseconds: milliseconds), () {
                    final int FPS = (1000 / 50).ceil();
                    _logger.info("Frames per sec: ${(1000 / FPS).ceil() }");

                    int index = 0;
                    for (int i = 0;i < names.length * 10;i++) {
                        if (index >= names.length) {
                            index = 0;
                        }
                        final int index1 = index;
                        final int index2 = index + 1 < names.length ? index + 1 : 0;

                        _logger.fine("Swap $index1 with $index2");

                        new Future.delayed(new Duration(milliseconds: (i + 1) * FPS), () async {

                            _logger.fine("InnerSwap $index1 with $index2");

                            final item1 = names[index1];
                            final item2 = names[index2];

                            names[index1] = item2;
                            names[index2] = item1;

                            await repeater.swap(item1, item2);
                        });

                        index++;
                    }
                });
            }

            _test0(500);
            _test1(1500);
            _test2(2500);
            _test3(4500);
            _test4(5500);
            _test5(6500);

        }

        _addNamesProgrammatically();


    });

}



void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}