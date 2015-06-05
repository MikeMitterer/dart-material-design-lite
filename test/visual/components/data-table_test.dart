part of  mdl.ui.unit.test;

testDataTable() {
    final Logger _logger = new Logger("test.DataTable");

    group('DataTable', () {
        setUp(() { });

        test('> check if upgraded', () {
            final dom.TableElement element = dom.document.querySelector("#data-table");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialDataTable");

            final MaterialDataTable component = MaterialDataTable.widget(element);
            expect(component,isNotNull);

        }); // end of 'check if upgraded' test


    });
    // end 'DataTable' group
}

// - Helper --------------------------------------------------------------------------------------
