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

// @TestOn("dartium")
@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:html' as dom;

import 'package:mdl/mdl.dart';

import '../config.dart';

/// Search next MDL-Parent in MDL-Component-Tree
main() async {
    // final Logger _logger = new Logger("test.Parent");
    configLogging();

    registerMdl();
    await initComponents();

    group('Component', () {
        setUp(() { });

        test('> Parent', () {
            final MaterialButton button = MaterialButton.widget(dom.querySelector("#parent-test"));
            expect(button,isNotNull);

            final MdlComponent parent = button.parent;
            expect(parent,isNotNull);
            expect(parent,new isInstanceOf<MaterialAccordion>());
        }); // end of 'Parent' test

        test('> Parent II', () {
            final dom.HtmlElement div = dom.querySelector("#accordion2");
            expect(div,isNotNull);

            final MaterialAccordion accordionPanel1 = MaterialAccordion.widget(div.querySelector(".mdl-accordion"));
            expect(accordionPanel1,isNotNull);

            final MdlComponent parent = accordionPanel1.parent;
            expect(parent,isNull);
        }); // end of 'Parent' test

    });
    // end 'Component' group
}

// - Helper --------------------------------------------------------------------------------------
