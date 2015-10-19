part of mdl.unit.test;

testObservables() {
    final Logger _logger = new Logger("mdl.unit.test.Observables");

    group('Observables', () {
        setUp(() { });

        test('> List', () {
            final ObservableList<String> list = new ObservableList<String>();

            final onChange = expectAsync((final ListChangedEvent event) {
                expect(event.changetype,ListChangeType.ADD);

                _logger.fine(list.toString());
            });

            list.onChange.listen(onChange);
            list.add("Hallo");

        }); // end of 'List' test

        

    });
    // end 'Observables' group
}

// - Helper --------------------------------------------------------------------------------------
