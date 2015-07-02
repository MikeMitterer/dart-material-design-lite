/**
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
    ADD, UPDATE, REMOVE, CLEAR
}

/// Propagated if List changes
class ListChangedEvent<T> {
    /// [changetype] shows what changed
    final ListChangeType changetype;

    /// [item] is set on ADD, REMOVE and update
    final Object item;

    /// [prevItem] is set on UPDATE and defines the old Entry
    final Object prevItem;

    ListChangedEvent(this.changetype,{ final Object this.item, final this.prevItem });
}

@MdlComponentModel
class ObservableList<T> extends ListBase<T> {

    final List<T> _innerList = new List();
    bool _changing = false;

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
        // remove + removeRange uses [] to set the new items
        // This flag avoids troubles
        if(!_changing) {
            _fire(new ListChangedEvent<T>(ListChangeType.UPDATE,item: value, prevItem: _innerList[index]));
        }

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

    @override
    void clear() {
        super.clear();
        _fire(new ListChangedEvent<T>(ListChangeType.CLEAR));
    }

    @override
    void removeRange(int start, int end) {
        RangeError.checkValidRange(start, end, this.length);
        for(int index = start;index < end;index++) {
            _fire(new ListChangedEvent<T>(ListChangeType.REMOVE,item: _innerList[index] ));
        }
        _changing = true;
        super.removeRange(start,end);
        _changing = false;
    }

    @override
    bool remove(final Object element) {
        _fire(new ListChangedEvent<T>(ListChangeType.REMOVE,item: element ));

        _changing = true;
        final bool result = super.remove(element);
        _changing = false;

        return result;
    }

    //- private -----------------------------------------------------------------------------------

    void _fire(final ListChangedEvent<T> event) {
        if(_onChange == null) {
            _onChange = new StreamController<ListChangedEvent<T>>.broadcast(onCancel: () => _onChange = null);
        }
        _onChange.add(event);
    }
}