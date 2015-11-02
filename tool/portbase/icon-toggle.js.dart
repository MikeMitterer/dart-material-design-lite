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

/// Class constructor for icon toggle MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {HTMLElement} element The element that will be upgraded.

  final MaterialIconToggle = function MaterialIconToggle(element) {

    // Initialize instance.
    init();
  }
  window['MaterialIconToggle'] = MaterialIconToggle;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialIconToggleConstant {
      final int TINY_TIMEOUT = 0;
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialIconToggleCssClasses {
      final String INPUT = 'mdl-icon-toggle__input';
      final String JS_RIPPLE_EFFECT = 'mdl-js-ripple-effect';
      final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
      final String RIPPLE_CONTAINER = 'mdl-icon-toggle__ripple-container';
      final String RIPPLE_CENTER = 'mdl-ripple--center';
      final String RIPPLE = 'mdl-ripple';
      final String IS_FOCUSED = 'is-focused';
      final String IS_DISABLED = 'is-disabled';
      final String IS_CHECKED = 'is-checked';
  }

/// Handle change of state.
/// 
/// param {Event} event The event that fired.
///   MaterialIconToggle.prototype.onChange_ = function(event) {
void _onChange(final html.Event event) {
    _updateClasses();
  }

/// Handle focus of element.
/// 
/// param {Event} event The event that fired.
///   MaterialIconToggle.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {
    element.classes.add(_cssClasses.IS_FOCUSED);
  }

/// Handle lost focus of element.
/// 
/// param {Event} event The event that fired.
///   MaterialIconToggle.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {
    element.classes.remove(_cssClasses.IS_FOCUSED);
  }

/// Handle mouseup.
/// 
/// param {Event} event The event that fired.
///   MaterialIconToggle.prototype.onMouseUp_ = function(event) {
void _onMouseUp(final html.Event event) {
    _blur();
  }

/// Handle class updates.
/// 
///   MaterialIconToggle.prototype.updateClasses_ = /*function*/ () {
void _updateClasses() {
    checkDisabled();
    checkToggleState();
  }

/// Add blur.
/// 
///   MaterialIconToggle.prototype.blur_ = /*function*/ () {
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
///   MaterialIconToggle.prototype.checkToggleState = /*function*/ () {
void checkToggleState() {
    if (_inputElement.checked) {
      element.classes.add(_cssClasses.IS_CHECKED);

    } else {
      element.classes.remove(_cssClasses.IS_CHECKED);
    }
  }
  MaterialIconToggle.prototype['checkToggleState'] =
      MaterialIconToggle.prototype.checkToggleState;

/// Check the inputs disabled state and update display.
/// 
/// public
///   MaterialIconToggle.prototype.checkDisabled = /*function*/ () {
void checkDisabled() {
    if (_inputElement.disabled) {
      element.classes.add(_cssClasses.IS_DISABLED);

    } else {
      element.classes.remove(_cssClasses.IS_DISABLED);
    }
  }
  MaterialIconToggle.prototype['checkDisabled'] =
      MaterialIconToggle.prototype.checkDisabled;

/// Disable icon toggle.
/// 
/// public
///   MaterialIconToggle.prototype.disable = /*function*/ () {
void disable() {
    _inputElement.disabled = true;
    _updateClasses();
  }
  MaterialIconToggle.prototype['disable'] =
      MaterialIconToggle.prototype.disable;

/// Enable icon toggle.
/// 
/// public
///   MaterialIconToggle.prototype.enable = /*function*/ () {
void enable() {
    _inputElement.disabled = false;
    _updateClasses();
  }
  MaterialIconToggle.prototype['enable'] = MaterialIconToggle.prototype.enable;

/// Check icon toggle.
/// 
/// public
///   MaterialIconToggle.prototype.check = /*function*/ () {
void check() {
    _inputElement.checked = true;
    _updateClasses();
  }
  MaterialIconToggle.prototype['check'] = MaterialIconToggle.prototype.check;

/// Uncheck icon toggle.
/// 
/// public
///   MaterialIconToggle.prototype.uncheck = /*function*/ () {
void uncheck() {
    _inputElement.checked = false;
    _updateClasses();
  }
  MaterialIconToggle.prototype['uncheck'] =
      MaterialIconToggle.prototype.uncheck;

/// Initialize element.
///   MaterialIconToggle.prototype.init = /*function*/ () {
void init() {

    if (element != null) {
      _inputElement =
          element.querySelector('.' + _cssClasses.INPUT);

      if (element.classes.contains(_cssClasses.JS_RIPPLE_EFFECT)) {
        element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

        _rippleContainerElement = new html.SpanElement();
        _rippleContainerElement.classes.add(_cssClasses.RIPPLE_CONTAINER);
        _rippleContainerElement.classes.add(_cssClasses.JS_RIPPLE_EFFECT);
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
      _boundElementOnMouseUp = onMouseUp;

	// .addEventListener('change', -- .onChange.listen(<Event>);
      _inputElement.onChange.listen( boundInputOnChange);

	// .addEventListener('focus', -- .onFocus.listen(<Event>);
      _inputElement.onFocus.listen( boundInputOnFocus);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
      _inputElement.onBlur.listen( boundInputOnBlur);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
      element.onMouseUp.listen( boundElementOnMouseUp);

      _updateClasses();
      element.classes.add('is-upgraded');
    }
  }

/// Downgrade the component
/// 
///   MaterialIconToggle.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {
    if (_rippleContainerElement) {
      _rippleContainerElement.removeEventListener('mouseup', boundRippleMouseUp);
    }
    _inputElement.removeEventListener('change', boundInputOnChange);
    _inputElement.removeEventListener('focus', boundInputOnFocus);
    _inputElement.removeEventListener('blur', boundInputOnBlur);
    element.removeEventListener('mouseup', boundElementOnMouseUp);
  }

/// Public alias for the downgrade method.
/// 
/// public
  MaterialIconToggle.prototype.mdlDowngrade =
      MaterialIconToggle.prototype.mdlDowngrade_;

  MaterialIconToggle.prototype['mdlDowngrade'] =
      MaterialIconToggle.prototype.mdlDowngrade;

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialIconToggle,
//     classAsString: 'MaterialIconToggle',
//     cssClass: 'mdl-js-icon-toggle',
//     widget: true
//   });
// })();
