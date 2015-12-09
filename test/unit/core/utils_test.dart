/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:async';
import 'dart:html' as dom;

import "package:mdl/mdl.dart";
import 'package:di/di.dart' as di;

import '../config.dart';

class MdlTestModule extends di.Module {

    MdlTestModule() {
        bind(MaterialApplication);
    }
}

Future prepareMdlTest(Future additionalRegistration()) async {
    registerApplicationComponents();
    await additionalRegistration();
    await componentHandler().run();
}

main() {
    // final Logger _logger = new Logger("test.CoreUtils");
    configLogging();

    final dom.DivElement div = new dom.DivElement();

    group('CoreUtils', () {
        setUp( () async {
            await prepareMdlTest(() async {
                await registerMaterialButton();
            });
            div.classes.addAll(["mdl-button","mdl-js-button"]);
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
