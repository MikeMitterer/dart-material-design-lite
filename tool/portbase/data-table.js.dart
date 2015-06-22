import 'dart:html' as html;
import 'dart:math' as Math;

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

/// Class constructor for Data Table Card MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class MaterialDataTable {

    final element;

    MaterialDataTable(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _MaterialDataTableConstant {
  // None at the moment.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _MaterialDataTableCssClasses {
    final String DATA_TABLE = 'mdl-data-table';
    final String SELECTABLE = 'mdl-data-table--selectable';
    final String IS_SELECTED = 'is-selected';
    final String IS_UPGRADED = 'is-upgraded';
}

/// MaterialDataTable.prototype.selectRow_ = function(checkbox, row, rows) {
void _selectRow(final checkbox, row, rows) {

  if (row) {
    return function() {
      if (checkbox.checked) {
        row.classes.add(_cssClasses.IS_SELECTED);

      } else {
        row.classes.remove(_cssClasses.IS_SELECTED);
      }
    };
  }

  if (rows) {
    return function() {

      final i;

      final el;
      if (checkbox.checked) {
        for (i = 0; i < rows.length; i++) {
          el = rows[i].querySelector('td').querySelector('.mdl-checkbox');
          el.widget.check();
          rows[i].classes.add(_cssClasses.IS_SELECTED);
        }

      } else {
        for (i = 0; i < rows.length; i++) {
          el = rows[i].querySelector('td').querySelector('.mdl-checkbox');
          el.widget.uncheck();
          rows[i].classes.remove(_cssClasses.IS_SELECTED);
        }
      }
    };
  }
}

/// MaterialDataTable.prototype.createCheckbox_ = function(row, rows) {
void _createCheckbox(final row, rows) {

  final label = document.createElement('label');
  label.classes.add('mdl-checkbox');
  label.classes.add('mdl-js-checkbox');
  label.classes.add('mdl-js-ripple-effect');
  label.classes.add('mdl-data-table__select');

  final checkbox = document.createElement('input');
  checkbox.type = 'checkbox';
  checkbox.classes.add('mdl-checkbox__input');
  if (row) {

	// .addEventListener('change', -- .onChange.listen(<Event>);
    checkbox.onChange.listen( _selectRow(checkbox, row));
  } else if (rows) {

	// .addEventListener('change', -- .onChange.listen(<Event>);
    checkbox.onChange.listen( _selectRow(checkbox, null, rows));
  }
  label.append(checkbox);
  componentHandler.upgradeElement(label, 'MaterialCheckbox');
  return label;
}

/// Initialize element.
/// MaterialDataTable.prototype.init = /*function*/ () {
void init() {

  if (element != null) {

    final firstHeader = element.querySelector('th');

    final rows = element.querySelector('tbody').querySelectorAll('tr');

    if (element.classes.contains(_cssClasses.SELECTABLE)) {

      final th = document.createElement('th');

      final headerCheckbox = _createCheckbox(null, rows);
      th.append(headerCheckbox);
      firstHeader.parent.insertBefore(th, firstHeader);

      for (final i = 0; i < rows.length; i++) {

        final firstCell = rows[i].querySelector('td');
        if (firstCell) {

          final td = document.createElement('td');

          final rowCheckbox = _createCheckbox(rows[i]);
          td.append(rowCheckbox);
          rows[i].insertBefore(td, firstCell);
        }
      }
    }

    element.classes.add(_cssClasses.IS_UPGRADED);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialDataTable,
//   classAsString: 'MaterialDataTable',
//   cssClass: 'mdl-js-data-table'
// });
