part of mdl.ui.unit.test;

testComponentHandler() {
    final Logger _logger = new Logger("test.ComponentHandler");

    group('ComponentHandler', () {
        setUp(() { });

        test('> downgrade Button', () async {
            final dom.ButtonElement element = dom.document.querySelector("#button-to-downgrade");

            MdlComponent component = mdlComponent(element);

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
                mdlComponent(element);
            } on String catch(e) {

                expect(e,"button is not a MdlComponent!!! (ID: button-to-downgrade)");
                foundException = true;
            }
            expect(foundException,isTrue);


        }); // end of 'downgrade Element' test


        test('> downgrade Checkbox', () async {
            final dom.HtmlElement element = dom.document.querySelector("#checkbox-to-downgrade");

            MdlComponent component = mdlComponent(element);

            expect(element,isNotNull);
            expect(component,isNotNull);

            expect(component.element.dataset.containsKey("upgraded"),isTrue);
            expect(component.element.dataset["upgraded"],"MaterialCheckbox");

            await componentHandler().downgradeElement(element);

            expect(component.element.dataset.containsKey("upgraded"),isFalse);
            expect(component.element.dataset["upgraded"],null);

            bool foundException = false;
            try {
                mdlComponent(element);
            } on String catch(e) {

                expect(e,"input is not a MdlComponent!!! (ID: checkbox-to-downgrade)");
                foundException = true;
            }
            expect(foundException,isTrue);

        }); // end of 'downgrade Checkbox' test

        test('> downgrade Checkbox with Ripples', () async {
            final dom.HtmlElement element = dom.document.querySelector("#checkbox-to-downgrade-with-ripples");

            MdlComponent component = mdlComponent(element);

            expect(element,isNotNull);
            expect(component,isNotNull);

            expect(component.element.dataset.containsKey("upgraded"),isTrue);
            expect(component.element.dataset["upgraded"],"MaterialCheckbox,MaterialRipple");

            await componentHandler().downgradeElement(element);

            expect(component.element.dataset.containsKey("upgraded"),isFalse);
            expect(component.element.dataset["upgraded"],null);

            bool foundException = false;
            try {
                mdlComponent(element);
            } on String catch(e) {

                expect(e,"input is not a MdlComponent!!! (ID: checkbox-to-downgrade-with-ripples)");
                foundException = true;
            }
            expect(foundException,isTrue);

        }); // end of 'downgrade Checkbox' test

        test('> downgrade Tabs', () async {
            final dom.HtmlElement element = dom.document.querySelector("#tab-to-downgrade");

            MdlComponent component = mdlComponent(element);

            expect(element,isNotNull);
            expect(component,isNotNull);

            await componentHandler().downgradeElement(element);

            bool foundException = false;
            try {
                mdlComponent(element);
            } on String catch(e) {

                expect(e,"div is not a MdlComponent!!! (ID: tab-to-downgrade)");
                foundException = true;
            }
            expect(foundException,isTrue);

        }); // end of 'downgrade Tabs' test

    });
    // end 'ComponentHandler' group
}

// - Helper --------------------------------------------------------------------------------------
