@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:html' as dom;

import "package:mdl/mdl.dart";

// import 'package:logging/logging.dart';

import '../../config.dart';

main() async {
    // final Logger _logger = new Logger("test.Formatter.Button");
    
    configLogging();

    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();
    final String html = '''
        <div>
            <!-- /* Hallo Kommentar aus HTML */ -->
            <span translate>_('Angular way8')</span>
        </div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('Translate', () {
        setUp(() async {
            await prepareMdlTest( () async {
                await registerMaterialTranslate();
            });
        });

        test('> Translate', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            //final MaterialTranslate divTranslate = MaterialTranslate.widget(element);
            //expect(divTranslate,isNotNull);

        }); // end of 'Uppercase' test

    });
    // End of 'Formatter' group
}

// - Helper --------------------------------------------------------------------------------------

