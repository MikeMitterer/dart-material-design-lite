import 'dart:html' as html;
import 'dart:math' as Math;

/// license
/// Copyright 2015 Google Inc. All Rights Reserved.
/// 
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
/// 
/// http://www.apache.org/licenses/LICENSE-2.0
/// 
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.

( /*function*/ () {

/// Class constructor for Data Table Card MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {Element} element The element that will be upgraded.

  final MaterialDataTable = function MaterialDataTable(element) {

    // Initialize instance.
    init();
  }

  window['MaterialDataTable'] = MaterialDataTable;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialDataTableConstant {
    // None at the moment.
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialDataTableCssClasses {
      final String DATA_TABLE = 'mdl-data-table';
      final String SELECTABLE = 'mdl-data-table--selectable';
      final String SELECT_ELEMENT = 'mdl-data-table__select';
      final String IS_SELECTED = 'is-selected';
      final String IS_UPGRADED = 'is-upgraded';
  }

/// Generates and returns a function that toggles the selection state of a
/// single row (or multiple rows).
/// 
/// param {Element} checkbox Checkbox that toggles the selection state.
/// param {Element} row Row to toggle when checkbox changes.
/// param {(Array<Object>|NodeList)=} optRows Rows to toggle when checkbox changes.
/// return {?function()} a function to toggle the selection state of the row(s).
///   MaterialDataTable.prototype.selectRow_ = function(checkbox, row, optRows) {
void _selectRow(final checkbox, row, optRows) {
    if (row) {
      return function() {
        if (checkbox.checked) {
          row.classes.add(_cssClasses.IS_SELECTED);

        } else {
          row.classes.remove(_cssClasses.IS_SELECTED);
        }
      };
    }

    if (optRows) {
      return function() {

        final i;

        final el;
        if (checkbox.checked) {
          for (i = 0; i < optRows.length; i++) {
            el = optRows[i].querySelector('td').querySelector('.mdl-checkbox');
            el['MaterialCheckbox'].check();
            optRows[i].classes.add(_cssClasses.IS_SELECTED);
          }

        } else {
          for (i = 0; i < optRows.length; i++) {
            el = optRows[i].querySelector('td').querySelector('.mdl-checkbox');
            el['MaterialCheckbox'].uncheck();
            optRows[i].classes.remove(_cssClasses.IS_SELECTED);
          }
        }
      };
    }

    return null;
  }

/// Creates a checkbox for a single or or multiple rows and hooks up the
/// event handling.
/// 
/// param {Element} row Row to toggle when checkbox changes.
/// param {(Array<Object>|NodeList)=} optRows Rows to toggle when checkbox changes.
/// return {Element} the created parent label.
///   MaterialDataTable.prototype.createCheckbox_ = function(row, optRows) {
void _createCheckbox(final row, optRows) {

    final label = document.createElement('label');

    final labelClasses = [
      'mdl-checkbox',
      'mdl-js-checkbox',
      'mdl-js-ripple-effect',
      _cssClasses.SELECT_ELEMENT
    ];
    label.className = labelClasses.join(' ');

    final checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.classes.add('mdl-checkbox__input');

    if (row) {
      checkbox.checked = row.classes.contains(_cssClasses.IS_SELECTED);

	// .addEventListener('change', -- .onChange.listen(<Event>);
      checkbox.onChange.listen( _selectRow(checkbox, row));
    } else if (optRows) {

	// .addEventListener('change', -- .onChange.listen(<Event>);
      checkbox.onChange.listen(
          _selectRow(checkbox, null, optRows));
    }

    label.append(checkbox);
    componentHandler.upgradeElement(label, 'MaterialCheckbox');
    return label;
  }

/// Initialize element.
///   MaterialDataTable.prototype.init = /*function*/ () {
void init() {
    if (element != null) {

      final firstHeader = element.querySelector('th');

      final bodyRows = Array.prototype.slice.call(
          element.querySelectorAll('tbody tr'));

      final footRows = Array.prototype.slice.call(
          element.querySelectorAll('tfoot tr'));

      final rows = bodyRows.concat(footRows);

      if (element.classes.contains(_cssClasses.SELECTABLE)) {

        final th = document.createElement('th');

        final headerCheckbox = _createCheckbox(null, rows);
        th.append(headerCheckbox);
        firstHeader.parent.insertBefore(th, firstHeader);

        for (final i = 0; i < rows.length; i++) {

          final firstCell = rows[i].querySelector('td');
          if (firstCell) {

            final td = document.createElement('td');
            if (rows[i].parentNode.nodeName.toUpperCase() == 'TBODY') {

              final rowCheckbox = _createCheckbox(rows[i]);
              td.append(rowCheckbox);
            }
            rows[i].insertBefore(td, firstCell);
          }
        }
        element.classes.add(_cssClasses.IS_UPGRADED);
      }
    }
  }

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialDataTable,
//     classAsString: 'MaterialDataTable',
//     cssClass: 'mdl-js-data-table'
//   });
// })();
