part of mdl.ui.unit.test;

testRepeat() {
    final Logger _logger = new Logger("mdl.ui.unit.test.Repeat");


    group('Repeat', () {
        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#repeat");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialRepeat");
        });

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#repeat");

            final MaterialRepeat widget = MaterialRepeat.widget(element);
            expect(widget,isNotNull);

        }); // end of 'widget' test

        test('> Add items', () async {
            final dom.HtmlElement element = dom.document.querySelector("#repeat");
            final MaterialRepeat widget = MaterialRepeat.widget(element);

            await widget.add({ "name" : "Mike"});
            await widget.add({ "name" : "Nicki"});

            final MaterialCheckbox checkbox = MaterialCheckbox.widget(element.querySelectorAll("input.mdl-checkbox__input").last);
            expect(checkbox,isNotNull);

            checkbox.check();

            // second radio in last div.template
            final dom.HtmlElement radioInput = element.querySelectorAll(".row").last.querySelectorAll(".mdl-radio")[1].querySelector("input");
            expect(radioInput,isNotNull);

            final MaterialRadio radio = MaterialRadio.widget(radioInput);
            expect(radio,isNotNull);
            radio.check();

        }); // end of 'Add items' test

    });
    // end 'Repeat' group
}

// - Helper --------------------------------------------------------------------------------------
