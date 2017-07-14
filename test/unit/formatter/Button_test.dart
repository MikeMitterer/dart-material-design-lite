@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:html' as dom;

import "package:mdl/mdl.dart";

// import 'package:logging/logging.dart';

import '../config.dart';

main() async {
    // final Logger _logger = new Logger("test.Formatter.Button");
    
    configLogging();

    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();
    final String html = '''
        <button class="mdl-button mdl-ripple-effect" mdl-formatter="uppercase(value)">Flat</button>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('Button', () {
        setUp(() async {
            await prepareMdlTest( () async {
                await registerMaterialButton();
                await registerMdlFormatterComponents();
            });
        });

        test('> Uppercase', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialButton button = MaterialButton.widget(element);
            expect(button,isNotNull);

            button.value = "Mike";
            expect(button.value,"MIKE");

        }); // end of 'Uppercase' test

    });
    // End of 'Formatter' group
}

// - Helper --------------------------------------------------------------------------------------

