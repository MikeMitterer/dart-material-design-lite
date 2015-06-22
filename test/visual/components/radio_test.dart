part of mdl.ui.unit.test;

testRadio() {
    final Logger _logger = new Logger("test.Radio");

    group('Radio', () {
        setUp(() { });

        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector(".ui-test--radio").querySelector(".mdl-radio");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialRadio,MaterialRipple");
        }); // end of 'check if upgraded' test

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector(".ui-test--radio").querySelector("#wifi2");
            expect(element,isNotNull);

            final MaterialRadio widget = MaterialRadio.widget(element);
            expect(widget,isNotNull);

            widget.disable();

        }); // end of 'widget' test

        test('> check only one', () {
            final dom.HtmlElement element = dom.document.querySelector(".ui-test--radio").querySelector("#wifi2");
            expect(element,isNotNull);

            final MaterialRadio widget = MaterialRadio.widget(element);
            expect(widget,isNotNull);

            widget.check();
        }); // end of 'check only one' test


    });
    // end 'Radio' group
}

// - Helper --------------------------------------------------------------------------------------
