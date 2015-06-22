part of mdl.ui.unit.test;

testProgress() {
    final Logger _logger = new Logger("test.Progress");

    group('Progress', () {
        setUp(() { });
        
        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#p1");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialProgress");
        }); // end of 'check if upgraded' test

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#p1");

            final MaterialProgress widget = MaterialProgress.widget(element);
            expect(widget,isNotNull);

            widget.progress = 50;
            expect(widget.progress,50);

            MaterialProgress.widget(dom.querySelector("#p3")).progress = 33;
            MaterialProgress.widget(dom.querySelector("#p3")).buffer = 66;


        }); // end of 'widget' test

        test('> Min / Max', () {
            final MaterialProgress maxCheck = MaterialProgress.widget(dom.querySelector("#p4"));
            final MaterialProgress minCheck = MaterialProgress.widget(dom.querySelector("#p5"));

            expect(maxCheck,isNotNull);
            expect(minCheck,isNotNull);

            maxCheck.progress = 133;
            minCheck.progress = -66;

            expect(maxCheck.progress,100);
            expect(minCheck.progress,0);

        }); // end of 'Min / Max' test

    });
    // end 'Progress' group
}

// - Helper --------------------------------------------------------------------------------------
