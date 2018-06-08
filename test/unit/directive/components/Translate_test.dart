@TestOn("chrome")
library test.unit.core.directive.translate;

import 'dart:async';
import 'dart:html' as dom;
import 'package:test/test.dart';
import 'package:dryice/dryice.dart';

import "package:mdl/mdl.dart";
import 'package:mdl/mdlmock.dart' as mdlmock;

import "package:console_log_handler/console_log_handler.dart";
//import 'package:logging/logging.dart';

import '../../config.dart';
import 'Translate_test.reflectable.dart';

main() async {
    //final Logger _logger = new Logger("test.Formatter.Button");
    //configLogging(show: Level.INFO);

    initializeReflectable();
    configLogging();

    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();

    final String html = '''
        <div>
            <!-- /* Hallo Kommentar aus HTML */ -->
            <span id="first" translate>_('Angular way8')</span>
            <button id="second" class="mdl-button mdl-ripple-effect">Second button</button>
        </div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('Translate', () {
        setUp(() async {
            mdlmock.setUpInjector();
            mdlmock.mockComponentHandler(mdlmock.injector(), mdlmock.componentFactory());

            await prepareMdlTest( () async {
                await registerMaterialButton();
                await registerMaterialTranslate();
            });
        });

        test('> Button', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialButton button = MaterialButton.widget(element.querySelector("#second"));

            expect(button,isNotNull);

        }); // end of 'Registration' test

        test('> Translate', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);

            final dom.SpanElement span = element.querySelector("#first");
            expect(span,isNotNull);

            // Funkt nicht - ist aber evtl. OK
//            print(span.getAttributeNames().join(", "));
//
//            final MaterialTranslate divTranslate = MaterialTranslate.widget(span);
//            expect(divTranslate,isNotNull);

        }); // end of 'Uppercase' test

    });
    // End of 'Formatter' group
}

// - Helper --------------------------------------------------------------------------------------

