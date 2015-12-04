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
    // final Logger _logger = new Logger("test.Progress");
    configLogging();

    registerMdl();
    await initComponents();

    group('ComponentHandler', () {
        setUp(() { });

        test('> downgrade Button', () async {
            final dom.ButtonElement element = dom.document.querySelector("#button-to-downgrade");

            MdlComponent component = mdlComponent(element,null);

            expect(element,isNotNull);
            expect(component,isNotNull);

            expect(element.classes.contains("mdl-downgraded"),isFalse);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialButton");

            expect(component.element.dataset.containsKey("upgraded"),isTrue);
            expect(component.element.dataset["upgraded"],"MaterialButton");

            await componentHandler().downgradeElement(element);

            expect(element.classes.contains("mdl-downgraded"),isTrue);
            expect(element.dataset.containsKey("upgraded"),isFalse);
            expect(element.dataset["upgraded"],null);

            bool foundException = false;
            try {
                mdlComponent(element,null);
            } on String catch(e) {

                expect(e,"button is not a MdlComponent!!! (ID: button-to-downgrade, "
                    "Classes: mdl-button mdl-js-button mdl-downgraded, Dataset: null)");

                foundException = true;
            }
            expect(foundException,isTrue);


        }); // end of 'downgrade Element' test


        test('> downgrade Checkbox', () async {
            final dom.HtmlElement element = dom.document.querySelector("#checkbox-to-downgrade");

            MdlComponent component = mdlComponent(element,null);

            expect(element,isNotNull);
            expect(component,isNotNull);

            expect(component.element.dataset.containsKey("upgraded"),isTrue);
            expect(component.element.dataset["upgraded"],"MaterialCheckbox");

            await componentHandler().downgradeElement(element);

            expect(component.element.dataset.containsKey("upgraded"),isFalse);
            expect(component.element.dataset["upgraded"],null);

            bool foundException = false;
            try {
                mdlComponent(element,null);
            } on String catch(e) {

                expect(e,"input is not a MdlComponent!!! (ID: checkbox-to-downgrade, "
                    "Classes: mdl-checkbox__input, Dataset: null)");

                foundException = true;
            }
            expect(foundException,isTrue);

        }); // end of 'downgrade Checkbox' test

        test('> downgrade Checkbox with Ripples', () async {
            final dom.HtmlElement element = dom.document.querySelector("#checkbox-to-downgrade-with-ripples");

            MdlComponent component = mdlComponent(element,null);

            expect(element,isNotNull);
            expect(component,isNotNull);

            expect(component.element.dataset.containsKey("upgraded"),isTrue);
            expect(component.element.dataset["upgraded"],"MaterialCheckbox,MaterialRipple");

            await componentHandler().downgradeElement(element);

            expect(component.element.dataset.containsKey("upgraded"),isFalse);
            expect(component.element.dataset["upgraded"],null);

            bool foundException = false;
            try {
                mdlComponent(element,null);
            } on String catch(e) {

                expect(e,"input is not a MdlComponent!!! (ID: checkbox-to-downgrade-with-ripples, "
                    "Classes: mdl-checkbox__input, Dataset: null)");

                foundException = true;
            }
            expect(foundException,isTrue);

        }); // end of 'downgrade Checkbox' test

        test('> downgrade Tabs', () async {
            final dom.HtmlElement element = dom.document.querySelector("#tab-to-downgrade");

            MdlComponent component = mdlComponent(element,null);

            expect(element,isNotNull);
            expect(component,isNotNull);

            await componentHandler().downgradeElement(element);

            bool foundException = false;
            try {
                mdlComponent(element,null);
            } on String catch(e) {

                expect(e,"div is not a MdlComponent!!! (ID: tab-to-downgrade, "
                    "Classes: mdl-tabs mdl-js-tabs mdl-js-ripple-effect mdl-js-ripple-effect--ignore-events "
                    "is-upgraded mdl-downgraded, Dataset: null)");

                foundException = true;
            }
            expect(foundException,isTrue);

        }); // end of 'downgrade Tabs' test

    });
    // end 'ComponentHandler' group
}

// - Helper --------------------------------------------------------------------------------------
