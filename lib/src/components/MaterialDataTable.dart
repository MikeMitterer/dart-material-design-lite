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
part of mdlcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialDataTableCssClasses {

    final String DATA_TABLE = 'mdl-data-table';
    final String SELECTABLE = 'mdl-data-table--selectable';
    final String IS_SELECTED = 'is-selected';
    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialDataTableCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialDataTableConstant {

    static const String WIDGET_SELECTOR = "mdl-data-table";

    const _MaterialDataTableConstant();
}

class MaterialDataTable extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialDataTable');

    //static const _MaterialDataTableConstant _constant = const _MaterialDataTableConstant();
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

        final List<dom.TableRowElement> rows = element.querySelector('tbody').querySelectorAll('tr') as List<dom.TableRowElement>;

        if (element.classes.contains(_cssClasses.SELECTABLE)) {

            final dom.HtmlElement th = dom.document.createElement('th');

            final dom.LabelElement headerCheckbox = _createCheckbox(null, rows);
            th.append(headerCheckbox);
            firstHeader.parent.insertBefore(th, firstHeader);

            for (int i = 0; i < rows.length; i++) {

                final dom.HtmlElement firstCell = rows[i].querySelector('td');
                if (firstCell != null) {

                    final dom.HtmlElement td = dom.document.createElement('td');

                    final dom.LabelElement rowCheckbox = _createCheckbox(rows[i],null);
                    td.append(rowCheckbox);
                    rows[i].insertBefore(td, firstCell);
                }
            }
        }

        componentHandler().upgradeElement(element);
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// MaterialDataTable.prototype.createCheckbox_ = function(row, rows) {
    dom.LabelElement _createCheckbox(final dom.TableRowElement row, final List<dom.HtmlElement> rows) {

        final dom.LabelElement label = new dom.LabelElement();

        label.classes.add('mdl-checkbox');
        label.classes.add('mdl-js-checkbox');
        label.classes.add('mdl-js-ripple-effect');
        label.classes.add('mdl-data-table__select');

        final dom.CheckboxInputElement checkbox = new dom.CheckboxInputElement();
        checkbox.classes.add('mdl-checkbox__input');

        if (row != null) {

            // .addEventListener('change', -- .onChange.listen(<Event>);
            checkbox.onChange.listen( _selectRow(checkbox, row, null));

        } else if (rows != null && rows.isNotEmpty) {

            // .addEventListener('change', -- .onChange.listen(<Event>);
            checkbox.onChange.listen( _selectRow(checkbox, null, rows));
        }

        label.append(checkbox);
        return label;
    }

    /// MaterialDataTable.prototype.selectRow_ = function(checkbox, row, rows) {
    Function _selectRow(final dom.CheckboxInputElement checkbox, final dom.TableRowElement row, final List<dom.HtmlElement> rows) {

        if (row != null) {

            return (final dom.Event event) {
                if (checkbox.checked) {
                    row.classes.add(_cssClasses.IS_SELECTED);

                } else {
                    row.classes.remove(_cssClasses.IS_SELECTED);
                }
            };
        }

        if (rows != null && rows.isNotEmpty) {

            return (final dom.Event event) {

                dom.HtmlElement el;
                if (checkbox.checked) {
                    for (int i = 0; i < rows.length; i++) {
                        el = rows[i].querySelector('td').querySelector('.mdl-checkbox__input');
                        MaterialCheckbox.widget(el).check();
                        rows[i].classes.add(_cssClasses.IS_SELECTED);
                    }

                } else {
                    for (int i = 0; i < rows.length; i++) {
                        el = rows[i].querySelector('td').querySelector('.mdl-checkbox__input');
                        MaterialCheckbox.widget(el).uncheck();
                        rows[i].classes.remove(_cssClasses.IS_SELECTED);
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

