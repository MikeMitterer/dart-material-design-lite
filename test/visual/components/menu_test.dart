part of mdl.ui.unit.test;

testMenu() {
    final Logger _logger = new Logger("test.Menu");

    group('Menu', () {
        setUp(() {
            final dom.HtmlElement elementLeft = dom.document.querySelector("#menu-left");
            final dom.HtmlElement elementRight = dom.document.querySelector("#menu-right");
            final MaterialMenu menuLeft = MaterialMenu.widget(elementLeft);
            final MaterialMenu menuRight = MaterialMenu.widget(elementRight);

            menuLeft.show();
            menuRight.show();
        });

        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#menu-left");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialMenu,MaterialRipple");
        });

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#menu-right");

            final MaterialMenu widget = MaterialMenu.widget(element);
            expect(widget,isNotNull);

        }); // end of 'widget' test


    });
    // end 'Menu' group
}

// - Helper --------------------------------------------------------------------------------------
