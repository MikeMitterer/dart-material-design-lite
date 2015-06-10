part of mdl.ui.unit.test;

testIconToggle() {
    final Logger _logger = new Logger("test.IconToggle");

    group('IconToggle', () {

        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#icon-toggle1").parent;

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialIconToggle");
        });

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#icon-toggle1");

            final MaterialIconToggle widget = MaterialIconToggle.widget(element);
            expect(widget,isNotNull);

        }); // end of 'widget' test


    });
    // end 'IconToggle' group
}

// - Helper --------------------------------------------------------------------------------------
