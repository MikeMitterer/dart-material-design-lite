@TestOn("chrome")
library test.unit.core.utils;

import 'package:test/test.dart';

import 'dart:html' as dom;

import "package:mdl/mdl.dart";
import 'package:dryice/dryice.dart';

//import "package:console_log_handler/console_log_handler.dart";

import '../config.dart';
import 'utils_test.reflectable.dart';

class MdlTestModule extends Module {

    configure() {
        bind(MaterialApplication);
    }
}

main() {
    // final Logger _logger = new Logger("test.CoreUtils");
    // configLogging();
    initializeReflectable();

    final dom.DivElement div = new dom.DivElement();

    group('CoreUtils', () {
        setUp( () async {
            await prepareMdlTest(() async {
                await registerMaterialButton();
            });
            div.classes.addAll(["mdl-button"]);
        });

        test('> register component', () async {
            expect(div,isNotNull);

            await componentHandler().upgradeElement(div);

            expect(isMdlComponent(div),isTrue);
            expect(isMdlComponent(div,MaterialButton),isTrue);

        }); // end of 'register component' test

        test('> mdlComponent', () async {
            expect(div,isNotNull);

            await componentHandler().upgradeElement(div);

            expect(mdlComponent(div,MaterialButton),isNotNull);

        }); // end of 'mdlComponent' test

        test('> isMdlWidget', () async {
            expect(div,isNotNull);

            await componentHandler().upgradeElement(div);

            expect(isMdlWidget(div),isTrue);

            final dom.DivElement div2 = new dom.DivElement();
            expect(isMdlWidget(div2),isFalse);

        }); // end of 'isMdlWidget' test

        test('> mdlComponentNames', () async {
            expect(div,isNotNull);

            await componentHandler().upgradeElement(div);

            final List<String> names = mdlComponentNames(div);
            expect(names.length,1);

            expect(names.first,"MaterialButton");

        }); // end of 'mdlComponentNames' test¨

        test('> mdlComponents', () async {
            expect(div,isNotNull);

            await componentHandler().upgradeElement(div);

            final List<MdlComponent> names = mdlComponents(div);
            expect(names.length,1);

            expect(names.first,new isInstanceOf<MaterialButton>());

        }); // end of 'mdlComponents' test
    });
    // end 'CoreUtils' group
}
