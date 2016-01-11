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

/// Class constructor for Textfield MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {HTMLElement} element The element that will be upgraded.

  final MaterialTextfield = function MaterialTextfield(element) {
    _maxRows = constant.NO_MAX_ROWS;
    // Initialize instance.
    init();
  }
  window['MaterialTextfield'] = MaterialTextfield;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialTextfieldConstant {
      final int NO_MAX_ROWS = -1;
      final String MAX_ROWS_ATTRIBUTE = 'maxrows';
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialTextfieldCssClasses {
      final String LABEL = 'mdl-textfield__label';
      final String INPUT = 'mdl-textfield__input';
      final String IS_DIRTY = 'is-dirty';
      final String IS_FOCUSED = 'is-focused';
      final String IS_DISABLED = 'is-disabled';
      final String IS_INVALID = 'is-invalid';
      final String IS_UPGRADED = 'is-upgraded';
  }

/// Handle input being entered.
/// 
/// param {Event} event The event that fired.
///   MaterialTextfield.prototype.onKeyDown_ = function(event) {
void _onKeyDown(final html.Event event) {

    final currentRowCount = event.target.value.split('\n').length;
    if (event.keyCode == 13) {
      if (currentRowCount >= maxRows) {
        event.preventDefault();
      }
    }
  }

/// Handle focus.
/// 
/// param {Event} event The event that fired.
///   MaterialTextfield.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {
    element.classes.add(_cssClasses.IS_FOCUSED);
  }

/// Handle lost focus.
/// 
/// param {Event} event The event that fired.
///   MaterialTextfield.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {
    element.classes.remove(_cssClasses.IS_FOCUSED);
  }

/// Handle reset event from out side.
/// 
/// param {Event} event The event that fired.
///   MaterialTextfield.prototype.onReset_ = function(event) {
void _onReset(final html.Event event) {
    _updateClasses();
  }

/// Handle class updates.
/// 
///   MaterialTextfield.prototype.updateClasses_ = /*function*/ () {
void _updateClasses() {
    checkDisabled();
    checkValidity();
    checkDirty();
    checkFocus();
  }

  // Public methods.

/// Check the disabled state and update field accordingly.
/// 
/// public
///   MaterialTextfield.prototype.checkDisabled = /*function*/ () {
void checkDisabled() {
    if (_input.disabled) {
      element.classes.add(_cssClasses.IS_DISABLED);

    } else {
      element.classes.remove(_cssClasses.IS_DISABLED);
    }
  }
  MaterialTextfield.prototype['checkDisabled'] =
      MaterialTextfield.prototype.checkDisabled;

/// Check the focus state and update field accordingly.
/// 
/// public
///   MaterialTextfield.prototype.checkFocus = /*function*/ () {
void checkFocus() {
    if (Boolean(element.querySelector(':focus'))) {
      element.classes.add(_cssClasses.IS_FOCUSED);

    } else {
      element.classes.remove(_cssClasses.IS_FOCUSED);
    }
  }
  MaterialTextfield.prototype['checkFocus'] =
    MaterialTextfield.prototype.checkFocus;

/// Check the validity state and update field accordingly.
/// 
/// public
///   MaterialTextfield.prototype.checkValidity = /*function*/ () {
void checkValidity() {
    if (_input.validity) {
      if (_input.validity.valid) {
        element.classes.remove(_cssClasses.IS_INVALID);

      } else {
        element.classes.add(_cssClasses.IS_INVALID);
      }
    }
  }
  MaterialTextfield.prototype['checkValidity'] =
      MaterialTextfield.prototype.checkValidity;

/// Check the dirty state and update field accordingly.
/// 
/// public
///   MaterialTextfield.prototype.checkDirty = /*function*/ () {
void checkDirty() {
    if (_input.value && _input.value.length > 0) {
      element.classes.add(_cssClasses.IS_DIRTY);

    } else {
      element.classes.remove(_cssClasses.IS_DIRTY);
    }
  }
  MaterialTextfield.prototype['checkDirty'] =
      MaterialTextfield.prototype.checkDirty;

/// Disable text field.
/// 
/// public
///   MaterialTextfield.prototype.disable = /*function*/ () {
void disable() {
    _input.disabled = true;
    _updateClasses();
  }
  MaterialTextfield.prototype['disable'] = MaterialTextfield.prototype.disable;

/// Enable text field.
/// 
/// public
///   MaterialTextfield.prototype.enable = /*function*/ () {
void enable() {
    _input.disabled = false;
    _updateClasses();
  }
  MaterialTextfield.prototype['enable'] = MaterialTextfield.prototype.enable;

/// Update text field value.
/// 
/// param {string} value The value to which to set the control (optional).
/// public
///   MaterialTextfield.prototype.change = function(value) {
void change(final value) {

    _input.value = value || '';
    _updateClasses();
  }
  MaterialTextfield.prototype['change'] = MaterialTextfield.prototype.change;

/// Initialize element.
///   MaterialTextfield.prototype.init = /*function*/ () {
void init() {

    if (element != null) {
      _label = element.querySelector('.' + _cssClasses.LABEL);
      _input = element.querySelector('.' + _cssClasses.INPUT);

      if (_input) {
        if (_input.hasAttribute(
          _maxRows = parseInt(input.getAttribute(
          if (isNaN(maxRows)) {
            _maxRows = constant.NO_MAX_ROWS;
          }
        }

        _boundUpdateClassesHandler = updateClasses;
        _boundFocusHandler = onFocus;
        _boundBlurHandler = onBlur;
        _boundResetHandler = onReset;
        _input.addEventListener('input', boundUpdateClassesHandler);

	// .addEventListener('focus', -- .onFocus.listen(<Event>);
        _input.onFocus.listen( boundFocusHandler);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
        _input.onBlur.listen( boundBlurHandler);
        _input.addEventListener('reset', boundResetHandler);

        if (_maxRows != constant.NO_MAX_ROWS) {
          // TODO: This should handle pasting multi line text.
          // Currently doesn't.
          _boundKeyDownHandler = onKeyDown;
          _input.addEventListener('keydown', boundKeyDownHandler);
        }

        final invalid = element.classList
          .contains(_cssClasses.IS_INVALID);
        _updateClasses();
        element.classes.add(_cssClasses.IS_UPGRADED);
        if (invalid) {
          element.classes.add(_cssClasses.IS_INVALID);
        }
        if (_input.hasAttribute('autofocus')) {
          element.focus();
          checkFocus();
        }
      }
    }
  }

/// Downgrade the component
/// 
///   MaterialTextfield.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {
    _input.removeEventListener('input', boundUpdateClassesHandler);
    _input.removeEventListener('focus', boundFocusHandler);
    _input.removeEventListener('blur', boundBlurHandler);
    _input.removeEventListener('reset', boundResetHandler);
    if (boundKeyDownHandler) {
      _input.removeEventListener('keydown', boundKeyDownHandler);
    }
  }

/// Public alias for the downgrade method.
/// 
/// public
  MaterialTextfield.prototype.mdlDowngrade =
      MaterialTextfield.prototype.mdlDowngrade_;

  MaterialTextfield.prototype['mdlDowngrade'] =
      MaterialTextfield.prototype.mdlDowngrade;

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialTextfield,
//     classAsString: 'MaterialTextfield',
//     cssClass: 'mdl-js-textfield',
//     widget: true
//   });
// })();
