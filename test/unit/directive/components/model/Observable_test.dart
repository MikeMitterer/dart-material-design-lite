@TestOn("chrome")

import 'dart:async';
import 'package:test/test.dart';

import 'dart:html' as dom;

import 'package:dryice/dryice.dart';
import 'package:console_log_handler/console_log_handler.dart';

import "package:mdl/mdl.dart";

// import 'package:logging/logging.dart';

import '../../../config.dart';
import 'Observable_test.reflectable.dart';

@inject @Model
class TestApplication extends MaterialApplication {
    final ObservableProperty<String> clientName = new ObservableProperty<String>("789",observeViaTimer: true);

    @override
    void run() {
        clientName.observes(() => "123");

        //clientName.value = "123";
    }
}

class TestModule extends Module {
  @override
  configure() {
      bind(Formatter);
  }
}

main() async {
    // final Logger _logger = new Logger("test.Formatter.Button");
    configLogging(show: Level.INFO);
    initializeReflectable();

    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();
    final String html = '''
        <div>
            <!-- /* Hallo Kommentar aus HTML */ -->
            <span mdl-observe="clientName">456</span>
        </div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('Observe', () {
        setUp(() async {
            await prepareMdlTest( () async {
                componentHandler().rootContext(TestApplication).addModule(new TestModule());
                await registerMaterialObserve();
            });
        });

        test('> Observe', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final dom.SpanElement span = element.querySelector("span");

            expect(span, isNotNull);

            // Setting the value takes a bit
            (componentHandler().injector.get(MaterialApplication) as TestApplication).clientName.value = "123";

            // We wait until the application loop gets the value
            int retries = 0;
            for(;retries < 10 && span.text != "123";retries++) {
                await new Future.delayed(new Duration(milliseconds: 100));
            }
            expect(retries < 10,isTrue);
        }); // end of 'Observe' test

    });
    // End of 'Formatter' group
}

// - Helper --------------------------------------------------------------------------------------

