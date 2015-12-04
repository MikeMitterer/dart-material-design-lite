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

main() async {
    // final Logger _logger = new Logger("test.Checkbox");
    configLogging();

    registerMdl();
    await initComponents();

    group('Checkbox', () {
        setUp(() { });

        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#checkbox1").parent;

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialCheckbox");
        });

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#checkbox1");

            final MaterialCheckbox widget = MaterialCheckbox.widget(element);
            expect(widget,isNotNull);

        }); // end of 'widget' test


    });
    // end 'Checkbox' group
}

// - Helper --------------------------------------------------------------------------------------
