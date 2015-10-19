part of mdl.ui.unit.test;

testAccordion() {
    final Logger _logger = new Logger("test.Accordion");

    group('Accordion', () {
        setUp(() { });

        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#accordion1");
            expect(element,isNotNull);

            final dom.HtmlElement firstPanel = element.querySelector(".mdl-accordion") as dom.HtmlElement;
            expect(firstPanel,isNotNull);

            expect(firstPanel.dataset.containsKey("upgraded"),isTrue);
            expect(firstPanel.dataset["upgraded"],"MaterialAccordion");
        });

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#accordion1");

            final dom.HtmlElement firstPanel = element.querySelector(".mdl-accordion") as dom.HtmlElement;
            expect(firstPanel,isNotNull);

            final MaterialAccordion widget = MaterialAccordion.widget(firstPanel);
            expect(widget,isNotNull);

        }); // end of 'widget' test


    });
    // end 'Accordion' group
}

// - Helper --------------------------------------------------------------------------------------
