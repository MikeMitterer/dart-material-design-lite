/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
     
part of mdlflux;

/// The [Dispatcher] is the central hub that manages all data flow in a MDL(Flux) application.
///
/// The [Dispatcher] has very little or no real intelligence of its own.
/// It is a simple mechanism for distributing change-Events (mainly via [UpdateView]-Actions)
/// actions to the stores.
///
/// Each store registers itself and provides an onChange-Listener.
///
///     class TestDataStore extends Dispatcher implements TestDataStoreInterface {
///
///         String _name = "Mike";
///
///         String get name => _name;
///
///         TestDataStore(final ActionBus actionbus) : super(actionbus);
///
///         void set name(final String value) {
///             _name = value;
///             emitChange();
///         }
///     }
///
///     /// Interface defined by a component
///     abstract class TestDataStoreInterface extends DataStore {
///         String get name;
///     }
///
///     class MyComponent {
///         TestDataStoreInterface _store;
///
///         /// [testCallback] is just for testing the _actionbus-response
///         MyComponent(this._store, void testCallback(final String value) ) {
///             _store.onChange.listen( (_) {
///                 testCallback(_store.name);
///             });
///         }
///     }
///
///     void main() {
///         final ActionBus actionbus = new ActionBus();
///         
///         final TestDataStore datastore = new TestDataStore(actionbus);
///         
///         final MyComponent component = new MyComponent(datastore, (final String value ) {
///             expect(value,"Dart");
///         });
///     }
///
abstract class Dispatcher extends DataStore {
    // final Logger _logger = new Logger('mdlflux.Dispatcher');

    final ActionBus _actionbus;

    Dispatcher(this._actionbus) {
        Validate.notNull(_actionbus);
    }

    /// Fire an [Action] to the global [ActionBus]
    @override
    void fire(final Action action) => _actionbus.fire(action);

    /// Listen on [Action]s on the global [ActionBus]
    Stream<Action> on(final ActionName actionname) {
        return _actionbus.on(actionname);
    }
}