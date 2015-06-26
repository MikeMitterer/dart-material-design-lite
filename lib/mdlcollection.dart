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

library mdlcollection;

import 'dart:collection';
import "dart:async";

enum ChangeType {
    ADD, UPDATE, REMOVE, CLEAR
}

class ListChangedEvent<T> {
    final ChangeType changetype;
    final Object item;
    final int index;

    ListChangedEvent(this.changetype,{ final Object this.item, final index: -1 }) : this.index = index;
}

class ObservableList<T> extends ListBase<T> {

    final List<T> _innerList = new List();
    final StreamController _controller = new StreamController<ListChangedEvent<T>>.broadcast();
    bool _changing = false;

    Stream<ListChangedEvent<T>> onChange;

    ObservableList() {
        onChange = _controller.stream;
    }

    int get length => _innerList.length;

    void set length(int length) {
        _innerList.length = length;
    }

    void operator []=(int index, T value) {
        _innerList[index] = value;

        // remove + removeRange uses [] to set the new items
        // This flag avoids troubles
        if(!_changing) {
            _controller.add(new ListChangedEvent<T>(ChangeType.UPDATE,item: value, index: index));
        }
    }

    T operator [](int index) => _innerList[index];

    void add(final T value) {
        _innerList.add(value);
        _controller.add(new ListChangedEvent<T>(ChangeType.ADD,item: value));
    }

    void addAll(Iterable<T> all) {
        _innerList.addAll(all);
        all.forEach((final element) {
            _controller.add(new ListChangedEvent<T>(ChangeType.ADD,item: element));
        });
    }

    @override
    void clear() {
        super.clear();
        _controller.add(new ListChangedEvent<T>(ChangeType.CLEAR));
    }

    @override
    void removeRange(int start, int end) {
        RangeError.checkValidRange(start, end, this.length);
        for(int index = start;index < end;index++) {
            _controller.add(new ListChangedEvent<T>(ChangeType.REMOVE,item: _innerList[index] ));
        }
        _changing = true;
        super.removeRange(start,end);
        _changing = false;
    }

    @override
    bool remove(final Object element) {
        _controller.add(new ListChangedEvent<T>(ChangeType.REMOVE,item: element ));

        _changing = true;
        final bool result = super.remove(element);
        _changing = false;

        return result;
    }


}