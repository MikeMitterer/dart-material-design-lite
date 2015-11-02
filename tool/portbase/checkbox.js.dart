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

/// Class constructor for Checkbox MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {HTMLElement} element The element that will be upgraded.

  final MaterialCheckbox = function MaterialCheckbox(element) {

    // Initialize instance.
    init();
  }
  window['MaterialCheckbox'] = MaterialCheckbox;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialCheckboxConstant {
      final int TINY_TIMEOUT = 0;
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialCheckboxCssClasses {
      final String INPUT = 'mdl-checkbox__input';
      final String BOX_OUTLINE = 'mdl-checkbox__box-outline';
      final String FOCUS_HELPER = 'mdl-checkbox__focus-helper';
      final String TICK_OUTLINE = 'mdl-checkbox__tick-outline';
      final String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
      final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
      final String RIPPLE_CONTAINER = 'mdl-checkbox__ripple-container';
      final String RIPPLE_CENTER = 'mdl-ripple--center';
      final String RIPPLE = 'mdl-ripple';
      final String IS_FOCUSED = 'is-focused';
      final String IS_DISABLED = 'is-disabled';
      final String IS_CHECKED = 'is-checked';
      final String IS_UPGRADED = 'is-upgraded';
  }

/// Handle change of state.
/// 
/// param {Event} event The event that fired.
///   MaterialCheckbox.prototype.onChange_ = function(event) {
void _onChange(final html.Event event) {
    _updateClasses();
  }

/// Handle focus of element.
/// 
/// param {Event} event The event that fired.
///   MaterialCheckbox.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {
    element.classes.add(_cssClasses.IS_FOCUSED);
  }

/// Handle lost focus of element.
/// 
/// param {Event} event The event that fired.
///   MaterialCheckbox.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {
    element.classes.remove(_cssClasses.IS_FOCUSED);
  }

/// Handle mouseup.
/// 
/// param {Event} event The event that fired.
///   MaterialCheckbox.prototype.onMouseUp_ = function(event) {
void _onMouseUp(final html.Event event) {
    _blur();
  }

/// Handle class updates.
/// 
///   MaterialCheckbox.prototype.updateClasses_ = /*function*/ () {
void _updateClasses() {
    checkDisabled();
    checkToggleState();
  }

/// Add blur.
/// 
///   MaterialCheckbox.prototype.blur_ = /*function*/ () {
void _blur() {
    // TODO: figure out why there's a focus event being fired after our blur,
    // so that we can avoid this hack.
    window.setTimeout( /*function*/ () {
      _inputElement.blur();
  }

  // Public methods.

/// Check the inputs toggle state and update display.
/// 
/// public
///   MaterialCheckbox.prototype.checkToggleState = /*function*/ () {
void checkToggleState() {
    if (_inputElement.checked) {
      element.classes.add(_cssClasses.IS_CHECKED);

    } else {
      element.classes.remove(_cssClasses.IS_CHECKED);
    }
  }
  MaterialCheckbox.prototype['checkToggleState'] =
      MaterialCheckbox.prototype.checkToggleState;

/// Check the inputs disabled state and update display.
/// 
/// public
///   MaterialCheckbox.prototype.checkDisabled = /*function*/ () {
void checkDisabled() {
    if (_inputElement.disabled) {
      element.classes.add(_cssClasses.IS_DISABLED);

    } else {
      element.classes.remove(_cssClasses.IS_DISABLED);
    }
  }
  MaterialCheckbox.prototype['checkDisabled'] =
      MaterialCheckbox.prototype.checkDisabled;

/// Disable checkbox.
/// 
/// public
///   MaterialCheckbox.prototype.disable = /*function*/ () {
void disable() {
    _inputElement.disabled = true;
    _updateClasses();
  }
  MaterialCheckbox.prototype['disable'] = MaterialCheckbox.prototype.disable;

/// Enable checkbox.
/// 
/// public
///   MaterialCheckbox.prototype.enable = /*function*/ () {
void enable() {
    _inputElement.disabled = false;
    _updateClasses();
  }
  MaterialCheckbox.prototype['enable'] = MaterialCheckbox.prototype.enable;

/// Check checkbox.
/// 
/// public
///   MaterialCheckbox.prototype.check = /*function*/ () {
void check() {
    _inputElement.checked = true;
    _updateClasses();
  }
  MaterialCheckbox.prototype['check'] = MaterialCheckbox.prototype.check;

/// Uncheck checkbox.
/// 
/// public
///   MaterialCheckbox.prototype.uncheck = /*function*/ () {
void uncheck() {
    _inputElement.checked = false;
    _updateClasses();
  }
  MaterialCheckbox.prototype['uncheck'] = MaterialCheckbox.prototype.uncheck;

/// Initialize element.
///   MaterialCheckbox.prototype.init = /*function*/ () {
void init() {
    if (element != null) {
      _inputElement = element.querySelector('.' +
          _cssClasses.INPUT);

      final boxOutline = new html.SpanElement();
      boxOutline.classes.add(_cssClasses.BOX_OUTLINE);

      final tickContainer = new html.SpanElement();
      tickContainer.classes.add(_cssClasses.FOCUS_HELPER);

      final tickOutline = new html.SpanElement();
      tickOutline.classes.add(_cssClasses.TICK_OUTLINE);

      boxOutline.append(tickOutline);

      element.append(tickContainer);
      element.append(boxOutline);

      if (element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
        element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

        _rippleContainerElement = new html.SpanElement();
        _rippleContainerElement.classes.add(_cssClasses.RIPPLE_CONTAINER);
        _rippleContainerElement.classes.add(_cssClasses.RIPPLE_EFFECT);
        _rippleContainerElement.classes.add(_cssClasses.RIPPLE_CENTER);
        _boundRippleMouseUp = onMouseUp;

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
        _rippleContainerElement.onMouseUp.listen( boundRippleMouseUp);

        final ripple = new html.SpanElement();
        ripple.classes.add(_cssClasses.RIPPLE);

        _rippleContainerElement.append(ripple);
        element.append(_rippleContainerElement);
      }
      _boundInputOnChange = onChange;
      _boundInputOnFocus = onFocus;
      _boundInputOnBlur = onBlur;
      _boundElementMouseUp = onMouseUp;

	// .addEventListener('change', -- .onChange.listen(<Event>);
      _inputElement.onChange.listen( boundInputOnChange);

	// .addEventListener('focus', -- .onFocus.listen(<Event>);
      _inputElement.onFocus.listen( boundInputOnFocus);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
      _inputElement.onBlur.listen( boundInputOnBlur);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
      element.onMouseUp.listen( boundElementMouseUp);

      _updateClasses();
      element.classes.add(_cssClasses.IS_UPGRADED);
    }
  }

/// Downgrade the component.
/// 
///   MaterialCheckbox.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {
    if (_rippleContainerElement) {
      _rippleContainerElement.removeEventListener('mouseup', boundRippleMouseUp);
    }
    _inputElement.removeEventListener('change', boundInputOnChange);
    _inputElement.removeEventListener('focus', boundInputOnFocus);
    _inputElement.removeEventListener('blur', boundInputOnBlur);
    element.removeEventListener('mouseup', boundElementMouseUp);
  }

/// Public alias for the downgrade method.
/// 
/// public
  MaterialCheckbox.prototype.mdlDowngrade =
      MaterialCheckbox.prototype.mdlDowngrade_;

  MaterialCheckbox.prototype['mdlDowngrade'] =
      MaterialCheckbox.prototype.mdlDowngrade;

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialCheckbox,
//     classAsString: 'MaterialCheckbox',
//     cssClass: 'mdl-js-checkbox',
//     widget: true
//   });
// })();
