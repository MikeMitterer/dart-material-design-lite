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

/// Received by a concrete implementation of [DataStore] if something has changed in the [DataStore]
class DataStoreChangedEvent<T extends Action> {
    final T data;

    DataStoreChangedEvent(this.data);

    bool get hasParam => (data != null);

    bool get hasNoParam => !hasParam;
}

/// The [DataStore] are responsible for managing business logic and data.
///
/// They're akin to models or collections in MVC systems,
/// but stores may manage more than a single piece of data or a single collection,
/// as they are responsible for a domain of the application.
///
/// A [DataStore] has per definition not setters!
///
/// Usage I: (Component)
///
///     abstract class MyComponentStore extends DataStore {
///         Optional<Device> get activeDevice;
///         bool hasID(final String id);
///     }
///
///
///     class MyComponent {
///         final MyComponentStore _store;
///         
///         MyComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
///             : super(element,injector), _store = injector.get(MyComponentStore) {
///             _init();
///         }
///
///         void _init() {
///             render().then((_) => _bindSignals());
///         }
///
///         void _bindSignals() {
///             _store.onChange.listen( (_) {
///                 // UPDATE your VIEW!
///             });
///         }
///
///         void onClick() {
///             _store.fire(const ActivateSomething());
///         }
///     }
///
abstract class DataStore {
    StreamController<DataStoreChangedEvent<Action>> _onChange;

    Stream<DataStoreChangedEvent<Action>> get onChange {
        if (_onChange == null) {
            _onChange =
            new StreamController<DataStoreChangedEvent<Action>>.broadcast(onCancel: () => _onChange = null);
        }
        return _onChange.stream;
    }

    void fire(final Action action);
}
