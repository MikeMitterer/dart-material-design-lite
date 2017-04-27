@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:html' as dom;

import "package:mdl/mdl.dart";

// import 'package:logging/logging.dart';

import '../config.dart';

main() async {
    // final Logger _logger = new Logger("test.Formatter.LabelField");
    
    configLogging();

    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();
    final String html = '''
        <div class="mdl-labelfield" mdl-formatter="uppercase(value)">
            <label class="mdl-labelfield__label"></label>
            <div class="mdl-labelfield__text"></div>
        </div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    final String html2 = '''
        <div class="mdl-labelfield">
            <label class="mdl-labelfield__label" mdl-formatter="uppercase(value)"></label>
            <div class="mdl-labelfield__text"></div>
        </div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    final String htmlForNumberFormat = '''
        <div class="mdl-labelfield" mdl-formatter="number(value,3)">
            <label class="mdl-labelfield__label"></label>
            <div class="mdl-labelfield__text"></div>
        </div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    final String htmlForNumberFormatNoFraction = '''
        <div class="mdl-labelfield" mdl-formatter="number(value)">
            <label class="mdl-labelfield__label"></label>
            <div class="mdl-labelfield__text"></div>
        </div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('LabelField', () {
        setUp(() async {
            await prepareMdlTest( () async {
                await registerMaterialLabelfield();
                await registerMdlFormatterComponents();
            });
        });

        test('> Uppercase', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialLabelfield labelfield = MaterialLabelfield.widget(element);
            expect(labelfield,isNotNull);

            labelfield.value = "Mike";
            expect(labelfield.value,"MIKE");

        }); // end of 'Uppercase' test

        test('> Label formatter', () async {
            final dom.HtmlElement element = await renderer.render(parent,html2);

            await componentHandler().upgradeElement(element);
            final MaterialLabelfield labelfield = MaterialLabelfield.widget(element);
            expect(labelfield,isNotNull);

            labelfield.label = "Name";
            expect(labelfield.label,"NAME");

            labelfield.value = "Mike";
            expect(labelfield.value,"Mike");
        }); // end of 'Label formatter' test

        test('> Number format I', () async {
            final dom.HtmlElement element = await renderer.render(parent,htmlForNumberFormat);

            await componentHandler().upgradeElement(element);
            final MaterialLabelfield labelfield = MaterialLabelfield.widget(element);
            expect(labelfield,isNotNull);

            labelfield.label = "Name";
            expect(labelfield.label,"Name");

            labelfield.value = "Mike";
            expect(labelfield.value,"Mike");
        }); // end of 'Number format I' test

        test('> Number format II', () async {
            final dom.HtmlElement element = await renderer.render(parent,htmlForNumberFormat);

            await componentHandler().upgradeElement(element);
            final MaterialLabelfield labelfield = MaterialLabelfield.widget(element);
            expect(labelfield,isNotNull);

            labelfield.label = "Name";
            expect(labelfield.label,"Name");

            labelfield.value = "10";
            expect(labelfield.value,"10.000");
        }); // end of 'Number format II' test

        test('> Number format III - no decimals specified', () async {
            final dom.HtmlElement element = await renderer.render(parent,htmlForNumberFormatNoFraction);

            await componentHandler().upgradeElement(element);
            final MaterialLabelfield labelfield = MaterialLabelfield.widget(element);
            expect(labelfield,isNotNull);

            labelfield.label = "Name";
            expect(labelfield.label,"Name");

            labelfield.value = "10";
            expect(labelfield.value,"10.00");
        }); // end of 'Number format III - no decimals specified' test

    });
    // End of 'Formatter' group
}

// - Helper --------------------------------------------------------------------------------------
