part of mdl.unit.test;

testForm() {
    // final Logger _logger = new Logger("test.Form");

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

// - Helper --------------------------------------------------------------------------------------
