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
    // final Logger _logger = new Logger("test.Menu");
    configLogging();

    registerMdl();
    await initComponents();

    group('Menu', () {
        setUp(() {
            final dom.HtmlElement elementLeft = dom.document.querySelector("#menu-left");
            final dom.HtmlElement elementRight = dom.document.querySelector("#menu-right");
            final MaterialMenu menuLeft = MaterialMenu.widget(elementLeft);
            final MaterialMenu menuRight = MaterialMenu.widget(elementRight);

            menuLeft.show();
            menuRight.show();
        });

        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#menu-left");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialMenu,MaterialRipple");
        });

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#menu-right");

            final MaterialMenu widget = MaterialMenu.widget(element);
            expect(widget,isNotNull);

        }); // end of 'widget' test


    });
    // end 'Menu' group
}

// - Helper --------------------------------------------------------------------------------------
