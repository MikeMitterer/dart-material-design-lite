part of mdl.ui.unit.test;

testComponent() {
    final Logger _logger = new Logger("test.Component");

    group('Component', () {
        setUp(() { });

        test('> Parent', () {
            final MaterialButton button = MaterialButton.widget(dom.querySelector("#parent-test"));
            expect(button,isNotNull);

            final MdlComponent parent = button.parent;
            expect(parent,isNotNull);
            expect(parent,new isInstanceOf<MaterialAccordion>());
        }); // end of 'Parent' test

        test('> Parent II', () {
            final MaterialAccordion accordion = MaterialAccordion.widget(dom.querySelector("#accordion2"));
            expect(accordion,isNotNull);

            final MdlComponent parent = accordion.parent;
            expect(parent,isNull);
        }); // end of 'Parent' test

    });
    // end 'Component' group
}

// - Helper --------------------------------------------------------------------------------------
