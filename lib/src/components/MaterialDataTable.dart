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
class _MaterialDataTableCssClasses {

    final String DATA_TABLE = 'mdl-data-table';
    final String SELECTABLE = 'mdl-data-table--selectable';
    final String SELECT_ELEMENT = 'mdl-data-table__select';

    final String IS_SELECTED = 'is-selected';
    final String IS_UPGRADED = 'is-upgraded';

    final String CHECKBOX = "mdl-checkbox";
    final String JS_CHECKBOX = "mdl-js-checkbox";
    final String JS_RIPPLE_EFFECT = "mdl-js-ripple-effect";

    const _MaterialDataTableCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialDataTableConstant {

    static const String WIDGET_SELECTOR = "mdl-data-table";

    final String SELECTABLE_NAME = "mdl-data-table-selectable-name";
    final String SELECTABLE_VALUE = "mdl-data-table-selectable-value";

    const _MaterialDataTableConstant();
}

class MaterialDataTable extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialDataTable');

    static const _MaterialDataTableConstant _constant = const _MaterialDataTableConstant();
    static const _MaterialDataTableCssClasses _cssClasses = const _MaterialDataTableCssClasses();

    MaterialDataTable.fromElement(final dom.HtmlElement element, final di.Injector injector)
        : super(element, injector) {

        _init();
    }

    static MaterialDataTable widget(final dom.HtmlElement element) => mdlComponent(element,MaterialDataTable) as MaterialDataTable;

    // Central Element - by default this is where mdl-data-table can be found (element)
    // html.Element get hub => inputElement;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialDataTable - init");

        final dom.HtmlElement firstHeader = element.querySelector('th');

        final List<dom.TableRowElement> bodyRows = element.querySelectorAll('tbody tr') as List<dom.TableRowElement>;
        final List<dom.TableRowElement> footRows = element.querySelectorAll('tfoot tr') as List<dom.TableRowElement>;

        final List<dom.TableRowElement> rows = new List<dom.TableRowElement>.from(bodyRows);
        rows.addAll(footRows);

        if (element.classes.contains(_cssClasses.SELECTABLE)) {

            final dom.HtmlElement th = dom.document.createElement('th');

            final dom.LabelElement headerCheckbox = _createCheckbox(null, rows);
            th.append(headerCheckbox);
            firstHeader.parent.insertBefore(th, firstHeader);

            for (int i = 0; i < rows.length; i++) {

                final dom.HtmlElement firstCell = rows[i].querySelector('td');
                if (firstCell != null) {

                    final dom.HtmlElement td = dom.document.createElement('td');

                    if(rows[i].parent.tagName.toLowerCase() == "tbody") {
                        final dom.LabelElement rowCheckbox = _createCheckbox(rows[i],null);
                        td.append(rowCheckbox);
                    }

                    rows[i].insertBefore(td, firstCell);
                }
            }
        }

        componentHandler().upgradeElement(element);
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// Creates a checkbox for a single or or multiple rows and hooks up the
    /// event handling.
    dom.LabelElement _createCheckbox(final dom.TableRowElement row, final List<dom.HtmlElement> optRows) {

        final dom.LabelElement label = new dom.LabelElement();

        label.classes.add(_cssClasses.CHECKBOX);
        label.classes.add(_cssClasses.JS_CHECKBOX);
        label.classes.add(_cssClasses.JS_RIPPLE_EFFECT);
        label.classes.add(_cssClasses.SELECT_ELEMENT);

        final dom.CheckboxInputElement checkbox = new dom.CheckboxInputElement();
        checkbox.classes.add('mdl-checkbox__input');

        if (row != null) {
            checkbox.checked = row.classes.contains(_cssClasses.IS_SELECTED);

            // .addEventListener('change', -- .onChange.listen(<Event>);
            checkbox.onChange.listen( _selectRow(checkbox, row, null));

        } else if (optRows != null && optRows.isNotEmpty) {

            // .addEventListener('change', -- .onChange.listen(<Event>);
            checkbox.onChange.listen( _selectRow(checkbox, null, optRows));
        }

        label.append(checkbox);
        return label;
    }

    /// Generates and returns a function that toggles the selection state of a
    /// single row (or multiple rows).
    ///
    /// [checkbox] Checkbox that toggles the selection state.
    /// [row] to toggle when checkbox changes.
    /// [rows] to toggle when checkbox changes.
    Function _selectRow(final dom.CheckboxInputElement checkbox, final dom.TableRowElement row, final List<dom.HtmlElement> optRows) {

        if (row != null) {

            return (final dom.Event event) {
                if (checkbox.checked) {
                    row.classes.add(_cssClasses.IS_SELECTED);

                } else {
                    row.classes.remove(_cssClasses.IS_SELECTED);
                }
            };
        }

        if (optRows != null && optRows.isNotEmpty) {

            return (final dom.Event event) {

                dom.HtmlElement el;
                if (checkbox.checked) {
                    for (int i = 0; i < optRows.length; i++) {
                        el = optRows[i].querySelector('td').querySelector('.mdl-checkbox__input');
                        MaterialCheckbox.widget(el).check();
                        optRows[i].classes.add(_cssClasses.IS_SELECTED);
                    }

                } else {
                    for (int i = 0; i < optRows.length; i++) {
                        el = optRows[i].querySelector('td').querySelector('.mdl-checkbox__input');
                        MaterialCheckbox.widget(el).uncheck();
                        optRows[i].classes.remove(_cssClasses.IS_SELECTED);
                    }
                }
            };
        }
        return null;
    }
}

/// registration-Helper
void registerMaterialDataTable() {
    final MdlConfig config = new MdlWidgetConfig<MaterialDataTable>(
        _MaterialDataTableConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element, final di.Injector injector) => new MaterialDataTable.fromElement(element, injector)
    );
    componentHandler().register(config);
}

