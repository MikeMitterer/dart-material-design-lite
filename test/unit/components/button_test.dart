part of mdl.ui.unit.test;

testButton() {
    final Logger _logger = new Logger("test.Button");

    group("Button",() {

        test('Check if button is upgraded', () {
            final dom.ButtonElement button = dom.document.querySelector("#button1");

            expect(button,isNotNull);
            expect(button.dataset.containsKey("upgraded"),isTrue);
            expect(button.dataset["upgraded"],"MaterialButton");
        });
    });
    // end 'Button' group
}

// - Helper --------------------------------------------------------------------------------------
