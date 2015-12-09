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

import '../config.dart';

Future prepareMdlTest(Future additionalRegistration()) async {
    registerApplicationComponents();
    await additionalRegistration();
    await componentHandler().run();
}

main() {
    // final Logger _logger = new Logger("test.Form");
    configLogging();

    final dom.FormElement form = new dom.FormElement();

    group('Form', () {
        setUp( () async {
            await prepareMdlTest( () async {

                await registerMaterialButton();
                await registerMaterialCheckbox();
                await registerMaterialTextfield();
                await registerMaterialFormComponent();
            });
            form.classes.add("mdl-form");
                final dom.DivElement content = new dom.DivElement();
                content.classes.add("mdl-form__content");
                form.append(content);
                    final dom.DivElement textfield1 = new dom.DivElement();
                    textfield1.classes.addAll([ "mdl-textfield", "mdl-js-textfield"] );
                    content.append(textfield1);
                        final dom.TextInputElement input1 = new dom.InputElement();
                        input1.classes.addAll([ "mdl-textfield__input"] );
                        input1.setAttribute("required","");
                        input1.id = "input1-test";
                        textfield1.append(input1);

                        final dom.LabelElement label1 = new dom.LabelElement();
                        label1.classes.addAll([ "mdl-textfield__label"] );
                        textfield1.append(label1);
                final dom.DivElement actions = new dom.DivElement();
                actions.classes.add("mdl-form__actions");
                form.append(actions);
                    final dom.ButtonElement submit = new dom.ButtonElement();
                    submit.classes.addAll([ "mdl-button","mdl-js-button","mdl-button--submit"] );
                    actions.append(submit);

        });

        test('> getAllMdlComponents', () async {
            expect(form,isNotNull);
            await componentHandler().upgradeElement(form);

            final List<MdlComponent> components = getAllMdlComponents(form);
            expect(components,isNotNull);
            expect(components.length,3);

        }); // end of 'getAllMdlComponents' test

        /// Status becomes disabled because input1 is required but not set
        test('> is submit-button disabled', () async {
            expect(form,isNotNull);
            await componentHandler().upgradeElement(form);

            final List<MdlComponent> components = getAllMdlComponents(form);
            final MaterialButton submit = components.firstWhere((final MdlComponent component) {
                return component is MaterialButton && component.classes.contains("mdl-button--submit");
            });

            expect(submit,isNotNull);
            expect(submit.enabled,isFalse);
            expect(form.classes.contains("is-valid"),isFalse);

        }); // end of 'is submit-button disabled' test

        /// Form should be invalid because input1 is required but not set
        test('> is Form invalid', () async {
            expect(form,isNotNull);
            await componentHandler().upgradeElement(form);

            expect(form.classes.contains("is-invalid"),isTrue);

            final dom.TextInputElement input1 = form.querySelector("#input1-test");
            expect(input1,isNotNull);
            input1.value = "fill me";
            expect(input1.checkValidity(),isTrue);

            final MaterialFormComponent mdlForm = MaterialFormComponent.widget(form);
            expect(mdlForm,isNotNull);
            mdlForm.updateStatus();

            expect(mdlForm.isValid,isTrue);
            expect(form.classes.contains("is-invalid"),isFalse);

        }); // end of 'is Form invalid' test
    });
    // end 'CoreUtils II' group
}
