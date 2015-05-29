part of mdl.ui.unit.test;

testButton() {
    final Logger _logger = new Logger("test.Button");

    group("Button",() {

        test('> check if upgraded', () {
            final dom.ButtonElement element = dom.document.querySelector("#button1");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialButton");
        });
    });
    // end 'Button' group
}

// - Helper --------------------------------------------------------------------------------------
