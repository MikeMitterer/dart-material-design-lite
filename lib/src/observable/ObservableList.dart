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

part of mdlobservable;

enum ListChangeType {
    ADD, INSERT, UPDATE, REMOVE, CLEAR
}

/// Propagated if List changes
class ListChangedEvent<T> {
    /// [changetype] shows what changed
    final ListChangeType changetype;

    /// [item] is set on ADD, REMOVE and update
    final Object item;

    /// [prevItem] is set on UPDATE and defines the old Entry
    /// It is also set on INSERT. It defines the previous items a the given index
    final Object prevItem;

    ListChangedEvent(this.changetype,{ final Object this.item, final this.prevItem });
}

/**
 * List that sends [ListChangeEvents] to the listener if this list changes
 * Supported methods:
 *      Add, insert, update ([]), remove, clear, removeAll
 */
@MdlComponentModel
class ObservableList<T> extends ListBase<T> {
    //final Logger _logger = new Logger('mdlobservable.ObservableList');

    final List<T> _innerList = new List();

    StreamController<ListChangedEvent<T>> _onChange;

    /// Propagated Event-Listener
    Stream<ListChangedEvent<T>> get onChange {
        if(_onChange == null) {
            _onChange = new StreamController<ListChangedEvent<T>>.broadcast(onCancel: () => _onChange = null);
        }
        return _onChange.stream;
    }

    int get length => _innerList.length;

    void set length(int length) {
        _innerList.length = length;
    }

    void operator []=(int index, T value) {
        _fire(new ListChangedEvent<T>(ListChangeType.UPDATE,
            item: value,
            prevItem: _innerList[index]));

        _innerList[index] = value;
    }

    T operator [](int index) => _innerList[index];

    void add(final T value) {
        _innerList.add(value);
        _fire(new ListChangedEvent<T>(ListChangeType.ADD,item: value));
    }

    void addAll(Iterable<T> all) {
        _innerList.addAll(all);
        all.forEach((final element) {
            _fire(new ListChangedEvent<T>(ListChangeType.ADD,item: element));
        });
    }

    void addIfAbsent(final T value) {
        if(!_innerList.contains(value)) {
            add(value);
        }
    }

    @override
    void insert(int index, T element) {
        RangeError.checkValueInInterval(index, 0, length, "index");

        if(index == _innerList.length) {
            add(element);

        } else {
            if(index == 0) {

                _fire(new ListChangedEvent<T>(ListChangeType.INSERT,item: element));
                _innerList.insert(index,element);

            } else {

                _fire(new ListChangedEvent<T>(ListChangeType.INSERT,
                    item: element, prevItem: _innerList[index]));

                _innerList.insert(index,element);
            }
        }
    }

    @override
    void clear() {
        _fire(new ListChangedEvent<T>(ListChangeType.CLEAR));
        _innerList.clear();
    }

    @override
    void removeRange(int start, int end) {
        RangeError.checkValidRange(start, end, this.length);
        for(int index = start;index < end;index++) {
            _fire(new ListChangedEvent<T>(ListChangeType.REMOVE,item: _innerList[index] ));
        }
        _innerList.removeRange(start,end);
    }

    @override
    bool remove(final T element) {
        _fire(new ListChangedEvent<T>(ListChangeType.REMOVE,item: element ));
        return _innerList.remove(element);
    }

    @override
    void removeWhere(bool test(final T element)) {
        final List<T> itemsToRemove = new List<T>();

        _innerList.forEach((final T element) {
            if(test(element)) {
                itemsToRemove.add(element);
            }
        });

        itemsToRemove.forEach((final T element) => remove(element));
    }

    //- private -----------------------------------------------------------------------------------

    void _fire(final ListChangedEvent<T> event) {
        if( _onChange != null && _onChange.hasListener) {
            _onChange.add(event);
        }
    }
}