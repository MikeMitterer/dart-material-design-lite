part of mdl.ui.unit.test;

testCheckbox() {
    final Logger _logger = new Logger("test.Checkbox");

    group('Checkbox', () {
        setUp(() { });

        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#checkbox1").parent;

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialCheckbox");
        });

    });
    // end 'Checkbox' group
}

// - Helper --------------------------------------------------------------------------------------
