@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:html' as dom;

import "package:mdl/mdl.dart";

// import 'package:logging/logging.dart';

import '../config.dart';

main() async {
    // final Logger _logger = new Logger("test.Formatter.Textfield");
    
    configLogging();

    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();
    final String html = '''
        <div class="mdl-textfield">
            <input class="mdl-textfield__input" type="text" id="sample1" >
            <label class="mdl-textfield__label" for="sample1" mdl-formatter="uppercase(value)">Type Something...</label>
        </div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('Textfield', () {
        setUp(() async {
            await prepareMdlTest( () async {
                await registerMaterialTextfield();
                await registerMdlFormatterComponents();
            });
        });

        test('> Uppercase', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialTextfield widget = MaterialTextfield.widget(element);
            expect(widget,isNotNull);

            widget.value = "Mike";
            expect(widget.value,"Mike");

        }); // end of 'Uppercase' test

        test('> Label', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialTextfield widget = MaterialTextfield.widget(element);
            expect(widget,isNotNull);

            widget.label = "Name1";
            expect(widget.label,"NAME1");

            widget.value = "Mike";
            expect(widget.value,"Mike");
        }); // end of 'Label' test

    });
    // End of 'Textfield' group
}

// - Helper --------------------------------------------------------------------------------------
