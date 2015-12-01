part of mdl.unit.test;

class TestDataStore extends Dispatcher implements TestDataStoreInterface {

    String _name = "Mike";

    String get name => _name;

    TestDataStore(final ActionBus actionbus) : super(actionbus);

    void set name(final String value) {
        _name = value;
        emitChange();
    }
}

/// Interface defined by a component
abstract class TestDataStoreInterface extends DataStore {
    String get name;
}

class MyComponent {
    TestDataStoreInterface _store;

    /// [testCallback] is really just for testing the _actionbus-response
    MyComponent(this._store, void testCallback(final String value) ) {
        _store.onChange.listen( (_) {
            testCallback(_store.name);
        });
    }
}

testDispatcher() {
    // final Logger _logger = new Logger("test.Dispatcher");

    group('Dispatcher', () {
        final ActionBus actionbus = new ActionBus();

        setUp(() { });

        test('> emitChange', () {

            final Function onDataChanged = expectAsync( (final String value ) {
                expect(value,"Dart");
            });

            final TestDataStore datastore = new TestDataStore(actionbus);
            final MyComponent component = new MyComponent(datastore,onDataChanged);

            // The datastore emits an "onChange"-Event (UpdateView-Action)
            datastore.name = "Dart";

        }); // end of 'emitChange' test

        

    });
    // end 'DataStore' group
}

// - Helper --------------------------------------------------------------------------------------
