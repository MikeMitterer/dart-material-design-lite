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

@TestOn("content-shell")
import 'package:test/test.dart';

import "package:mdl/mdl.dart";
import "package:mdl/mdlflux.dart";

import '../config.dart';

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

main() {
    // final Logger _logger = new Logger("test.Dispatcher");
    configLogging();

    group('Dispatcher', () {
        final ActionBus actionbus = new ActionBus();

        setUp(() { });

        test('> emitChange', () {

//            final Function onDataChanged = expectAsync( (final String value ) {
//                expect(value,"Dart");
//            });

            final TestDataStore datastore = new TestDataStore(actionbus);
            // final MyComponent component = new MyComponent(datastore,onDataChanged);

            // The datastore emits an "onChange"-Event (UpdateView-Action)
            datastore.name = "Dart";

        }); // end of 'emitChange' test

        

    });
    // end 'DataStore' group
}