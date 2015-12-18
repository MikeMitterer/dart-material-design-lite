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

/// This is the base class for [DataStore] so it's not really a [DataStore] but if you need
/// an object that informs others about an internat change-state the [Emitter] can help you
///
///     class MyProxy extends Emitter {
///         ...
///         void updateSomething() {
///             ...
///             emitChange();
///         }
///     }
///
///     class MyDataStore extends DataStore {
///         final MyProxy proxy = new MyProxy();
///         ...
///
///         void _bindSignals() {
///             proxy.onChange.listen((_) {
///                 ...
///                 // Use some data from proxy
///                 // and inform your observers about the changes!
///                 emitChange();
///             }
///         }
///     }
abstract class Emitter {
    StreamController<DataStoreChangedEvent<Action>> _onChange;

    Stream<DataStoreChangedEvent<Action>> get onChange {
        if (_onChange == null) {
            _onChange =
            new StreamController<DataStoreChangedEvent<Action>>.broadcast(onCancel: () => _onChange = null);
        }
        return _onChange.stream;
    }

    /// Informs the coupled [DataStore]s about the change
    void emitChange({ final Action action: UpdateViewAction }) {
        if (_onChange != null && _onChange.hasListener && !_onChange.isClosed) {
            _onChange.add(new DataStoreChangedEvent<Action>(action));
        }
    }
}
