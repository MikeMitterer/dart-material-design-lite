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

import '../../config.dart';

main() async {
    // final Logger _logger = new Logger("test.Repeat");
    configLogging();

    registerMdl();
    await initComponents();

    group('Repeat', () {
        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#repeat");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialRepeat");
        });

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#repeat");

            final MaterialRepeat widget = MaterialRepeat.widget(element);
            expect(widget,isNotNull);

        }); // end of 'widget' test

        test('> Add items', () async {
            final dom.HtmlElement element = dom.document.querySelector("#repeat");
            final MaterialRepeat widget = MaterialRepeat.widget(element);

            await widget.add({ "name" : "Mike"});
            await widget.add({ "name" : "Nicki"});

            final MaterialCheckbox checkbox = MaterialCheckbox.widget(element.querySelectorAll("input.mdl-checkbox__input").last);
            expect(checkbox,isNotNull);

            checkbox.check();

            // second radio in last div.template
            final dom.HtmlElement radioInput = element.querySelectorAll(".row").last.querySelectorAll(".mdl-radio")[1].querySelector("input");
            expect(radioInput,isNotNull);

            final MaterialRadio radio = MaterialRadio.widget(radioInput);
            expect(radio,isNotNull);
            radio.check();

        }); // end of 'Add items' test

    });
    // end 'Repeat' group
}

// - Helper --------------------------------------------------------------------------------------
