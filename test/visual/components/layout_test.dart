part of mdl.ui.unit.test;

testLayout() {
    final Logger _logger = new Logger("test.Layout");

    group('Layout', () {
        setUp(() { });

        test('> check if upgraded', () {
            final dom.DivElement element = dom.document.querySelector("#demo-layout");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialLayout");
        });

        test('> widget', () {
            final dom.DivElement element = dom.document.querySelector("#demo-layout");

            final MaterialLayout widget = MaterialLayout.widget(element);
            expect(widget,isNotNull);

        }); // end of 'widget' test

    });
    // end 'Layout' group
}

// - Helper --------------------------------------------------------------------------------------
