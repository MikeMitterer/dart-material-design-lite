part of mdl.ui.unit.test;

/// Search next MDL-Parent in MDL-Component-Tree
testParent() {
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
            final dom.HtmlElement div = dom.querySelector("#accordion2");
            expect(div,isNotNull);

            final MaterialAccordion accordionPanel1 = MaterialAccordion.widget(div.querySelector(".mdl-accordion"));
            expect(accordionPanel1,isNotNull);

            final MdlComponent parent = accordionPanel1.parent;
            expect(parent,isNull);
        }); // end of 'Parent' test

    });
    // end 'Component' group
}

// - Helper --------------------------------------------------------------------------------------
