@TestOn("chrome")
import 'package:test/test.dart';

import 'dart:html' as dom;

import "package:mdl/mdl.dart";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import '../config.dart';
import 'Badge_test.reflectable.dart';

main() async {
    final Logger _logger = new Logger("test.Formatter.Badge");
    
    configLogging(show: Level.INFO);
    initializeReflectable();
    
    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();
    final String html = '''
        <div class="mdl-badge" data-badge="1" mdl-formatter="uppercase(value)"></div>
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('Badge', () {
        setUp(() async {
            await prepareMdlTest( () async {
                await registerMaterialBadge();
                await registerMdlFormatterComponents();
            });
        });

        test('> Uppercase', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialBadge badge = MaterialBadge.widget(element);
            expect(badge,isNotNull);

            _logger.info("Hallo vom Test");

            badge.value = "a";
            expect(badge.value,"A");

        }); // end of 'Uppercase' test

    });
    // End of 'Formatter' group
}

// - Helper --------------------------------------------------------------------------------------

