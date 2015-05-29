part of mdl.ui.unit.test;

testAccordion() {
    final Logger _logger = new Logger("test.Accordion");

    group('Accordion', () {
        setUp(() { });

        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#accordion1");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialAccordion");
        });


    });
    // end 'Accordion' group
}

// - Helper --------------------------------------------------------------------------------------
