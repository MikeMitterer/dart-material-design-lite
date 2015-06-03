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

/// Class constructor for Textfield MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class MaterialTextfield {

    final element;

    MaterialTextfield(this.element);

  _maxRows = constant.NO_MAX_ROWS;
  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _MaterialTextfieldConstant {
    final int NO_MAX_ROWS = -1;
    final String MAX_ROWS_ATTRIBUTE = 'maxrows';
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _MaterialTextfieldCssClasses {
    final String LABEL = 'mdl-textfield__label';
    final String INPUT = 'mdl-textfield__input';
    final String IS_DIRTY = 'is-dirty';
    final String IS_FOCUSED = 'is-focused';
    final String IS_DISABLED = 'is-disabled';
    final String IS_INVALID = 'is-invalid';
    final String IS_UPGRADED = 'is-upgraded';
}

/// Handle input being entered.
/// param {Event} event The event that fired.
/// MaterialTextfield.prototype.onKeyDown_ = function(event) {
void _onKeyDown(final html.Event event) {

  final currentRowCount = event.target.value.split('\n').length;
  if (event.keyCode == 13) {
    if (currentRowCount >= maxRows) {
      event.preventDefault();
    }
  }
}

/// Handle focus.
/// param {Event} event The event that fired.
/// MaterialTextfield.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {

  element.classes.add(_cssClasses.IS_FOCUSED);
}

/// Handle lost focus.
/// param {Event} event The event that fired.
/// MaterialTextfield.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {

  element.classes.remove(_cssClasses.IS_FOCUSED);
}

/// Handle class updates.
/// param {HTMLElement} button The button whose classes we should update.
/// param {HTMLElement} label The label whose classes we should update.
/// MaterialTextfield.prototype.updateClasses_ = /*function*/ () {
void _updateClasses() {

  if (_input.disabled) {
    element.classes.add(_cssClasses.IS_DISABLED);

  } else {
    element.classes.remove(_cssClasses.IS_DISABLED);
  }

  if (_input.validity.valid) {
    element.classes.remove(_cssClasses.IS_INVALID);

  } else {
    element.classes.add(_cssClasses.IS_INVALID);
  }

  if (_input.value && _input.value.length > 0) {
    element.classes.add(_cssClasses.IS_DIRTY);

  } else {
    element.classes.remove(_cssClasses.IS_DIRTY);
  }
}

// Public methods.

/// Disable text field.
/// public
/// MaterialTextfield.prototype.disable = /*function*/ () {
void disable() {

  _input.disabled = true;
  _updateClasses();
}

/// Enable text field.
/// public
/// MaterialTextfield.prototype.enable = /*function*/ () {
void enable() {

  _input.disabled = false;
  _updateClasses();
}

/// Update text field value.
/// param {String} value The value to which to set the control (optional).
/// public
/// MaterialTextfield.prototype.change = function(value) {
void change(final value) {

  if (value) {
    _input.value = value;
  }
  _updateClasses();
}

/// Initialize element.
/// MaterialTextfield.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    _label = element.querySelector('.' + _cssClasses.LABEL);
    _input = element.querySelector('.' + _cssClasses.INPUT);

    if (_input) {
      if (_input.hasAttribute(_constant.MAX_ROWS_ATTRIBUTE)) {
        _maxRows = parseInt(input.getAttribute(
            _constant.MAX_ROWS_ATTRIBUTE), 10);
        if (isNaN(maxRows)) {
          _maxRows = constant.NO_MAX_ROWS;
        }
      }

      _boundUpdateClassesHandler = updateClasses;
      _boundFocusHandler = onFocus;
      _boundBlurHandler = onBlur;
      _input.addEventListener('input', boundUpdateClassesHandler);

	// .addEventListener('focus', -- .onFocus.listen(<Event>);
      _input.onFocus.listen( boundFocusHandler);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
      _input.onBlur.listen( boundBlurHandler);

      if (_maxRows != constant.NO_MAX_ROWS) {
        // TODO: This should handle pasting multi line text.
        // Currently doesn't.
        _boundKeyDownHandler = onKeyDown;
        _input.addEventListener('keydown', boundKeyDownHandler);
      }

      _updateClasses();
      element.classes.add(_cssClasses.IS_UPGRADED);
    }
  }
}

/*
/// Downgrade the component
/// 
/// MaterialTextfield.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {
  _input.removeEventListener('input', boundUpdateClassesHandler);
  _input.removeEventListener('focus', boundFocusHandler);
  _input.removeEventListener('blur', boundBlurHandler);
  if (boundKeyDownHandler) {
    _input.removeEventListener('keydown', boundKeyDownHandler);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialTextfield,
//   classAsString: 'MaterialTextfield',
//   cssClass: 'mdl-js-textfield'
// });
