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
part of mdlcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialDivDataTableCssClasses {

    final String DATA_TABLE =   'mdl-data-tableex';
    final String SELECTABLE =   'mdl-data-tableex--selectable';
    final String SELECT =       'mdl-data-tableex__select';

    final String IS_SELECTED =  'is-selected';
    final String IS_UPGRADED =  'is-upgraded';

    final String HEAD = "mdl-div-data-tableex__head";
    final String ROW =  "mdl-div-data-tableex__row";

    final String CELL_CHECKBOX = "mdl-data-tableex__cell--checkbox";

    final String CHECKBOX = "mdl-checkbox";
    final String CHECKBOX_INPUT = "mdl-checkbox__input";

    final String JS_CHECKBOX = "mdl-js-checkbox";
    final String JS_RIPPLE_EFFECT = "mdl-js-ripple-effect";

    const _MaterialDivDataTableCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialDivDataTableConstant {

    static const String WIDGET_SELECTOR = "mdl-data-tableex";

    final String SELECTABLE_NAME =  "mdl-data-tableex-selectable-name";
    final String SELECTABLE_VALUE = "mdl-data-tableex-selectable-value";

    const _MaterialDivDataTableConstant();
}

class DataTableChangedEvent {}

class MaterialDivDataTable extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialDivDataTable');

    static const _MaterialDivDataTableConstant _constant = const _MaterialDivDataTableConstant();
    static const _MaterialDivDataTableCssClasses _cssClasses = const _MaterialDivDataTableCssClasses();

    MaterialDivDataTableRow __headerRow;

    StreamController<DataTableChangedEvent> _onChange;

    MaterialDivDataTable.fromElement(final dom.HtmlElement element, final di.Injector injector)
        : super(element, injector) {

        _init();
    }

    static MaterialDivDataTable widget(final dom.HtmlElement element) => mdlComponent(element,MaterialDivDataTable) as MaterialDivDataTable;

    bool get isSelectable => element.classes.contains(_cssClasses.SELECTABLE);

    void set select(final bool _select) {
        _rows.forEach((final MaterialDivDataTableRow row) => row.select = _select);
        if(_headerRow != null) {
            _headerRow.select = _select;
        }
    }

    bool get isSelected {
        final List<MaterialDivDataTableRow> rows = _rows;
        for(int counter = 0;counter < rows.length; counter++) {
            if(rows[counter].isSelected == false) {
                return false;
            }
        }
        return true;
    }

    Stream<DataTableChangedEvent> get onChange {
        if(_onChange == null) {
            _onChange = new StreamController<DataTableChangedEvent>.broadcast( onCancel: () => _onChange = null);
        }
        return _onChange.stream;
    }

    List<MaterialDivDataTableRow> get selectedRows {
        return new UnmodifiableListView(_rows.where((final MaterialDivDataTableRow row) => row.isSelected));
    }
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialDivDataTable - init");

        element.classes.add(_cssClasses.IS_UPGRADED);

    }

    List<MaterialDivDataTableRow> get _rows {
        final List<dom.HtmlElement> tempRows = new List.from(
            element.querySelectorAll(".${_cssClasses.ROW}") as List<dom.HtmlElement>);
        tempRows.removeWhere((final dom.HtmlElement element) => element.classes.contains(_cssClasses.HEAD));

        final List<MaterialDivDataTableRow> rows = new List<MaterialDivDataTableRow>();

        tempRows.forEach( (final dom.HtmlElement row) {

            final MaterialDivDataTableRow mdlRow = MaterialDivDataTableRow.widget(row);
            Validate.notNull(mdlRow);
            rows.add(mdlRow);
        });

        return rows;
    }

    MaterialDivDataTableRow get _headerRow {
        if(__headerRow == null) {

            final dom.HtmlElement row = element.querySelector(".${_cssClasses.HEAD}");
            if(row != null) {
                __headerRow = MaterialDivDataTableRow.widget(row);
                Validate.notNull(__headerRow);
            }
        }

        return __headerRow;
    }

    void _verifyCheckedState() {
        if(_headerRow != null) {
            _headerRow.select = isSelected;
        }
    }

    void _fireChangeEvent() {
        if(_onChange != null && _onChange.hasListener) {
            _onChange.add(new DataTableChangedEvent());
        }
    }
}

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialDivDataTableRowCssClasses {

    final String SELECT =       'mdl-data-tableex__select';

    final String IS_SELECTED =  'is-selected';
    final String IS_UPGRADED =  'is-upgraded';

    final String HEAD = "mdl-div-data-tableex__head";

    final String CELL_CHECKBOX = "mdl-data-tableex__cell--checkbox";

    final String CHECKBOX = "mdl-checkbox";
    final String CHECKBOX_INPUT = "mdl-checkbox__input";

    final String JS_CHECKBOX = "mdl-js-checkbox";
    final String JS_RIPPLE_EFFECT = "mdl-js-ripple-effect";

    const _MaterialDivDataTableRowCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialDivDataTableRowConstant {

    static const String WIDGET_SELECTOR = "mdl-div-data-tableex__row";

    final String SELECTABLE_NAME =  "mdl-data-tableex-selectable-name";
    final String SELECTABLE_VALUE = "mdl-data-tableex-selectable-value";

    const _MaterialDivDataTableRowConstant();
}
class MaterialDivDataTableRow extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialDivDataTableRow');

    static const _MaterialDivDataTableRowConstant _constant = const _MaterialDivDataTableRowConstant();
    static const _MaterialDivDataTableRowCssClasses _cssClasses = const _MaterialDivDataTableRowCssClasses();

    /// See [parent]
    MaterialDivDataTable _parent;

    /// See [_selectableCheckbox]
    MaterialCheckbox _checkbox;

    MaterialDivDataTableRow.fromElement(final dom.HtmlElement element, final di.Injector injector)
        : super(element, injector) {
    }

    static MaterialDivDataTableRow widget(final dom.HtmlElement element) => mdlComponent(element,MaterialDivDataTableRow) as MaterialDivDataTableRow;

    /// Row-Parent - the element that has the CSS-class 'mdl-data-tableex'
    MaterialDivDataTable get parent {
        if(_parent != null) {
            return _parent;
        }

        dom.Element _getParent(final dom.HtmlElement element) {
            if(element != null) {
                if(element.classes.contains(_MaterialDivDataTableConstant.WIDGET_SELECTOR)) {
                    return element;
                }
                return _getParent(element.parent);
            }
            throw new ArgumentError("Could not find parent-class (mdl-data-tableex) for this row... ($element)");
        }
        final dom.HtmlElement parent = _getParent(element);
        _logger.info("Found parent: $parent");
        _parent = MaterialDivDataTable.widget(parent);
        _logger.info("Found parent-Widget: $_parent");

        return _parent;
    }


    @override
    /// Make sure parent is already in the DOM
    void attached() => _init();

    void set select(final bool _select) {
        if(_selectableCheckbox != null) {
            _selectableCheckbox.checked = _select;
            _toggleRow(_select);
        }
    }

    bool get isSelected => _selectableCheckbox != null ? _selectableCheckbox.checked : false;

    //- private -----------------------------------------------------------------------------------


    void _init() {
        _logger.info("MaterialDivDataTableRow - init");

        if(parent.isSelectable) {

            final dom.HtmlElement firstCell = element.querySelector(':first-child');
            if(firstCell != null) {
                final dom.HtmlElement td = new dom.DivElement();
                td.classes.add(_cssClasses.CELL_CHECKBOX);

                final dom.LabelElement rowCheckbox = _createRowCheckbox();
                td.append(rowCheckbox);
                componentHandler().upgradeElement(td).then( (_) {
                    element.insertBefore(td, firstCell);
                });

            }
        }

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// If parent has mdl-data-tableex--selectable this checkbox will be created dynamically
    /// otherwise it is [null]
    MaterialCheckbox get _selectableCheckbox {
        if(!_parent.isSelectable) {
            return null;
        }
        if(_checkbox != null) {
            return _checkbox;
        }

        final dom.HtmlElement cellCheckbox = element.querySelector(".${_cssClasses.CELL_CHECKBOX}");
        Validate.notNull(cellCheckbox);

        _checkbox = MaterialCheckbox.widget(cellCheckbox.querySelector(".${_cssClasses.CHECKBOX_INPUT}"));
        Validate.notNull(_checkbox);
        return _checkbox;
    }

    /// Creates a checkbox for a single or or multiple rows and hooks up the
    /// event handling.
    dom.LabelElement _createRowCheckbox() {

        final dom.LabelElement label = new dom.LabelElement();

        label.classes.add(_cssClasses.CHECKBOX);
        label.classes.add(_cssClasses.JS_CHECKBOX);
        label.classes.add(_cssClasses.JS_RIPPLE_EFFECT);
        label.classes.add(_cssClasses.SELECT);

        final dom.CheckboxInputElement checkbox = new dom.CheckboxInputElement();
        checkbox.classes.add(_cssClasses.CHECKBOX_INPUT);

        if (element != null) {
            checkbox.checked = element.classes.contains(_cssClasses.IS_SELECTED);

            eventStreams.add( checkbox.onChange.listen( (final dom.Event event) {
                final bool checked = checkbox.checked;
                _toggleRow(checked);

                if(element.classes.contains(_cssClasses.HEAD)) {
                    _toggleHeaderRow(checked);
                } else {
                    parent._verifyCheckedState();
                }
                parent._fireChangeEvent();
            }));

            if (element.dataset.containsKey(_constant.SELECTABLE_NAME)) {
                checkbox.name = element.dataset[_constant.SELECTABLE_NAME];
            }
            if (element.dataset.containsKey(_constant.SELECTABLE_VALUE)) {
                checkbox.value = element.dataset[_constant.SELECTABLE_VALUE];
            }
        }

        label.append(checkbox);
        return label;
    }

    /// Toggles background of [element] if checkbox changes state
    void _toggleRow(final bool checked) {

        if (checked) {
            element.classes.add(_cssClasses.IS_SELECTED);
        }
        else {
            element.classes.remove(_cssClasses.IS_SELECTED);
        }
    }

    void _toggleHeaderRow(final bool checked) {
        parent.select = checked;
    }
}

/// registration-Helper
void registerMaterialDivDataTable() {
    _registerMaterialDivDataTable();
    _registerMaterialDivDataTableRow();
}

void _registerMaterialDivDataTable() {
    final MdlConfig config = new MdlWidgetConfig<MaterialDivDataTable>(
        _MaterialDivDataTableConstant.WIDGET_SELECTOR,
        (final dom.HtmlElement element, final di.Injector injector) => new MaterialDivDataTable.fromElement(element, injector)
    );
    componentHandler().register(config);
}

void _registerMaterialDivDataTableRow() {
    final MdlConfig config = new MdlWidgetConfig<MaterialDivDataTableRow>(
        _MaterialDivDataTableRowConstant.WIDGET_SELECTOR,
        (final dom.HtmlElement element, final di.Injector injector) => new MaterialDivDataTableRow.fromElement(element, injector)
    );
    /// _registerMaterialDivDataTable hast priority 1 so here we make sure that
    /// MaterialDivDataTable will allays be registered first - every Row needs needs a parent!
    config.priority = 2;
    componentHandler().register(config);
}