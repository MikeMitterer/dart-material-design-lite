@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:html' as dom;

import "package:mdl/mdl.dart";

// import 'package:logging/logging.dart';

import '../config.dart';

main() async {
    // final Logger _logger = new Logger("test.Formatter.Switch");
    
    configLogging();

    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();
    final String html = '''
        <label class="mdl-switch mdl-ripple-effect" for="switch-1" mdl-formatter="uppercase(value)">
            <input type="checkbox" id="switch-1" class="mdl-switch__input" mdl-formatter="number(value,4)">
            <span class="mdl-switch__label">Switch me</span>
        </label>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('Switch', () {
        setUp(() async {
            await prepareMdlTest( () async {
                await registerMaterialSwitch();
                await registerMdlFormatterComponents();
            });
        });

        test('> Uppercase', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialSwitch widget = MaterialSwitch.widget(element);
            expect(widget,isNotNull);

            widget.value = "Mike";
            expect(widget.value,"Mike");

            expect(widget.label,"SWITCH ME");

        }); // end of 'Uppercase' test

        test('> Value', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialSwitch widget = MaterialSwitch.widget(element);
            expect(widget,isNotNull);

            widget.value = "13.1234567890";
            expect(widget.value,"13.1235");

            expect(widget.label,"SWITCH ME");
        }); // end of 'Value' test

    });
    // End of 'Switch' group
}

// - Helper --------------------------------------------------------------------------------------
