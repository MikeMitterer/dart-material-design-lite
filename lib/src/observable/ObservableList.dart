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

typedef bool UpdateItem<T>(final dom.HtmlElement element, final T item);

/// Propagated if List changes
class ListChangedEvent<T> {
    /// [changetype] shows what changed
    final ListChangeType changetype;

    /// [item] is set on ADD, REMOVE and update
    final T item;

    /// [prevItem] is set on UPDATE and defines the old Entry
    /// It is also set on INSERT. It defines the previous items a the given index
    final T prevItem;

    /// Index in der Original-Liste (_innerList)
    final int index;

    ListChangedEvent(this.changetype,{ final T this.item, final this.prevItem, final this.index: -1 });
}

/// List that sends [ListChangeEvents] to the listener if this list changes
/// Supported methods:
///     Add, insert, update ([]), remove, clear, removeAll
///
///     @MdlComponentModel
///     class MyComponent extends MdlTemplateComponent {
///
///         final ObservableList<RecordsPerDay> records = new ObservableList<RecordsPerDay>(
///             updateCallback: _updateListItem);
///
///         void _init() {
///
///             render().then((_) {
///                 _bindStoreActions();
///             });
///         }
///
///         void _bindStoreActions() {
///             if(_store == null) { return;}
///
///             _store.onChange.listen((final DataStoreChangedEvent event) {
///                 _updateView();
///             });
///         }
///
///         void _updateView() {
///
///             if(records.length != _store.records.length) {
///                 records.clear();
///                 records.addAll(_store.records);
///
///             } else {
///                 final List<RecordsPerDay> _storeRecords = _store.records;
///                 for (int index = 0; index < _storeRecords.length; index++) {
///
///                     // Triggers _updateListItem!!! in MaterialRepeat
///                     records[index] = _storeRecords[index];
///                 }
///             }
///         }
///
///         static bool _updateListItem(final dom.HtmlElement element, final RecordsPerDay item, final RecordsPerDay prevItem) {
///             if(element == null) {
///                 return false;
///             }
///             final dom.SpanElement date = element.querySelector(".date");
///             final dom.SpanElement records = element.querySelector(".records");
///             date.text = item.date.toString();
///             records.text = item.records.toString();
///             return true;
///         }
///
///         @override
///         final String template = "...";
///     }
///
@MdlComponentModel
class ObservableList<T> extends ListBase<T> {
    //final Logger _logger = new Logger('mdlobservable.ObservableList');

    final List<T> _innerList = new List();
    final List<T> _filterBackup = new List();

    StreamController<ListChangedEvent<T>> _onChange;

    final UpdateItem _updateCallback;

    /// If [updateCallback] is given it will be called from [MaterialRepeat]
    /// if the list updates
    ObservableList({final UpdateItem updateCallback: _defaultUpdateCallback })
        : _updateCallback = updateCallback;

    /// Propagated Event-Listener
    Stream<ListChangedEvent<T>> get onChange {
        if(_onChange == null) {
            _onChange = new StreamController<ListChangedEvent<T>>.broadcast(
                onCancel: () => _onChange = null);
        }
        return _onChange.stream;
    }

    int get length => _innerList.length;

    void set length(int length) {
        _innerList.length = length;
    }

    /// Updates the internal List.
    void operator []=(int index, T value) {
        _fire(new ListChangedEvent<T>(ListChangeType.UPDATE,
            item: value,
            prevItem: _innerList[index],
            index: index ));

        _innerList[index] = value;
    }

    T operator [](int index) => _innerList[index];

    void add(final T value) {
        _innerList.add(value);

        _fire(new ListChangedEvent<T>(
            ListChangeType.ADD,
            item: value,
            index: _innerList.indexOf(value)));
    }

    void addAll(Iterable<T> all) {
        _innerList.addAll(all);
        all.forEach((final element) {
            _fire(new ListChangedEvent<T>(
                ListChangeType.ADD,
                item: element,
                index: _innerList.indexOf(element)));
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

                _fire(new ListChangedEvent<T>(
                    ListChangeType.INSERT,
                    item: element,
                    index: index ));

                _innerList.insert(index,element);

            } else {

                _fire(new ListChangedEvent<T>(
                    ListChangeType.INSERT,
                    item: element,
                    prevItem: _innerList[index],
                    index: index));

                _innerList.insert(index,element);
            }
        }
    }

    @override
    void clear() {
        _clearList();
        _clearFilter();
    }

    @override
    void removeRange(int start, int end) {
        RangeError.checkValidRange(start, end, this.length);
        for(int index = start;index < end;index++) {
            _fire(new ListChangedEvent<T>(
                ListChangeType.REMOVE,
                item: _innerList[index],
                index: index ));
        }
        _innerList.removeRange(start,end);
    }

    @override
    bool remove(final Object element) {
        _fire(new ListChangedEvent<T>(
            ListChangeType.REMOVE,
            item: element as T,
            index: _innerList.indexOf(element as T) ));

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

    @override
    void retainWhere(bool test(final T element)) {
        final List<T> itemsToRemove = new List<T>();

        _innerList.forEach((final T element) {
            // remove items where test fails
            if(test(element) == false) {
                itemsToRemove.add(element);
            }
        });

        itemsToRemove.forEach((final T element) => remove(element));
    }

    /// Filter items in list
    ///
    ///     final String text = filter.value.trim();
    ///
    ///     if(text.isNotEmpty) {
    ///         components.filter((final HackintoshComponent element) => element.name.contains(text));
    ///     } else {
    ///         components.resetFilter();
    ///     }
    ///
    void filter(bool test(final T element)) {
        if(_filterBackup.isEmpty) {
            _filterBackup.addAll(_innerList);
        }

        _clearList();
        addAll(_filterBackup.where(test));
    }

    /// Resets the item-List to it's original stand
    void resetFilter() {
        if(_filterBackup.isNotEmpty) {
            _clearList();

            addAll(_filterBackup);
            _filterBackup.clear();
        }
    }

    /// Called by MaterialRepeat do make fast updates
    bool update(final dom.HtmlElement element, final T item)
        => _updateCallback(element,item);

    //- private -----------------------------------------------------------------------------------

    void _fire(final ListChangedEvent<T> event) {
        if( _onChange != null && _onChange.hasListener) {
            _onChange.add(event);
        }
    }

    /// Remove all items from list (DOM + innerList)
    void _clearList() {
        _fire(new ListChangedEvent<T>(ListChangeType.CLEAR));
        _innerList.clear();
    }

    /// Remove items backed up items for filter
    void _clearFilter() {
        _filterBackup.clear();
    }

    /// Default Callback for updating the UI
    ///
    /// It returns false which indicates that MaterialRepeater should call it's own
    /// update routines
    // @ToDo: https://github.com/dart-lang/sdk/issues/28996
    static bool _defaultUpdateCallback/*<T>*/(final dom.HtmlElement element, final /* T */ item) {
        return false;
    }

}