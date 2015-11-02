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

  final MaterialSwitch = function MaterialSwitch(element) {

    // Initialize instance.
    init();
  }
  window['MaterialSwitch'] = MaterialSwitch;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialSwitchConstant {
      final int TINY_TIMEOUT = 0;
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialSwitchCssClasses {
      final String INPUT = 'mdl-switch__input';
      final String TRACK = 'mdl-switch__track';
      final String THUMB = 'mdl-switch__thumb';
      final String FOCUS_HELPER = 'mdl-switch__focus-helper';
      final String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
      final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
      final String RIPPLE_CONTAINER = 'mdl-switch__ripple-container';
      final String RIPPLE_CENTER = 'mdl-ripple--center';
      final String RIPPLE = 'mdl-ripple';
      final String IS_FOCUSED = 'is-focused';
      final String IS_DISABLED = 'is-disabled';
      final String IS_CHECKED = 'is-checked';
  }

/// Handle change of state.
/// 
/// param {Event} event The event that fired.
///   MaterialSwitch.prototype.onChange_ = function(event) {
void _onChange(final html.Event event) {
    _updateClasses();
  }

/// Handle focus of element.
/// 
/// param {Event} event The event that fired.
///   MaterialSwitch.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {
    element.classes.add(_cssClasses.IS_FOCUSED);
  }

/// Handle lost focus of element.
/// 
/// param {Event} event The event that fired.
///   MaterialSwitch.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {
    element.classes.remove(_cssClasses.IS_FOCUSED);
  }

/// Handle mouseup.
/// 
/// param {Event} event The event that fired.
///   MaterialSwitch.prototype.onMouseUp_ = function(event) {
void _onMouseUp(final html.Event event) {
    _blur();
  }

/// Handle class updates.
/// 
///   MaterialSwitch.prototype.updateClasses_ = /*function*/ () {
void _updateClasses() {
    checkDisabled();
    checkToggleState();
  }

/// Add blur.
/// 
///   MaterialSwitch.prototype.blur_ = /*function*/ () {
void _blur() {
    // TODO: figure out why there's a focus event being fired after our blur,
    // so that we can avoid this hack.
    window.setTimeout( /*function*/ () {
      _inputElement.blur();
  }

  // Public methods.

/// Check the components disabled state.
/// 
/// public
///   MaterialSwitch.prototype.checkDisabled = /*function*/ () {
void checkDisabled() {
    if (_inputElement.disabled) {
      element.classes.add(_cssClasses.IS_DISABLED);

    } else {
      element.classes.remove(_cssClasses.IS_DISABLED);
    }
  }
  MaterialSwitch.prototype['checkDisabled'] =
      MaterialSwitch.prototype.checkDisabled;

/// Check the components toggled state.
/// 
/// public
///   MaterialSwitch.prototype.checkToggleState = /*function*/ () {
void checkToggleState() {
    if (_inputElement.checked) {
      element.classes.add(_cssClasses.IS_CHECKED);

    } else {
      element.classes.remove(_cssClasses.IS_CHECKED);
    }
  }
  MaterialSwitch.prototype['checkToggleState'] =
      MaterialSwitch.prototype.checkToggleState;

/// Disable switch.
/// 
/// public
///   MaterialSwitch.prototype.disable = /*function*/ () {
void disable() {
    _inputElement.disabled = true;
    _updateClasses();
  }
  MaterialSwitch.prototype['disable'] = MaterialSwitch.prototype.disable;

/// Enable switch.
/// 
/// public
///   MaterialSwitch.prototype.enable = /*function*/ () {
void enable() {
    _inputElement.disabled = false;
    _updateClasses();
  }
  MaterialSwitch.prototype['enable'] = MaterialSwitch.prototype.enable;

/// Activate switch.
/// 
/// public
///   MaterialSwitch.prototype.on = /*function*/ () {
void on() {
    _inputElement.checked = true;
    _updateClasses();
  }
  MaterialSwitch.prototype['on'] = MaterialSwitch.prototype.on;

/// Deactivate switch.
/// 
/// public
///   MaterialSwitch.prototype.off = /*function*/ () {
void off() {
    _inputElement.checked = false;
    _updateClasses();
  }
  MaterialSwitch.prototype['off'] = MaterialSwitch.prototype.off;

/// Initialize element.
///   MaterialSwitch.prototype.init = /*function*/ () {
void init() {
    if (element != null) {
      _inputElement = element.querySelector('.' +
          _cssClasses.INPUT);

      final track = new html.DivElement();
      track.classes.add(_cssClasses.TRACK);

      final thumb = new html.DivElement();
      thumb.classes.add(_cssClasses.THUMB);

      final focusHelper = new html.SpanElement();
      focusHelper.classes.add(_cssClasses.FOCUS_HELPER);

      thumb.append(focusHelper);

      element.append(track);
      element.append(thumb);

      _boundMouseUpHandler = onMouseUp;

      if (element.classes.contains(
          _cssClasses.RIPPLE_EFFECT)) {
        element.classes.add(
            _cssClasses.RIPPLE_IGNORE_EVENTS);

        _rippleContainerElement = new html.SpanElement();
        _rippleContainerElement.classes.add(
            _cssClasses.RIPPLE_CONTAINER);
        _rippleContainerElement.classes.add(_cssClasses.RIPPLE_EFFECT);
        _rippleContainerElement.classes.add(_cssClasses.RIPPLE_CENTER);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
        _rippleContainerElement.onMouseUp.listen( boundMouseUpHandler);

        final ripple = new html.SpanElement();
        ripple.classes.add(_cssClasses.RIPPLE);

        _rippleContainerElement.append(ripple);
        element.append(_rippleContainerElement);
      }

      _boundChangeHandler = onChange;
      _boundFocusHandler = onFocus;
      _boundBlurHandler = onBlur;

	// .addEventListener('change', -- .onChange.listen(<Event>);
      _inputElement.onChange.listen( boundChangeHandler);

	// .addEventListener('focus', -- .onFocus.listen(<Event>);
      _inputElement.onFocus.listen( boundFocusHandler);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
      _inputElement.onBlur.listen( boundBlurHandler);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
      element.onMouseUp.listen( boundMouseUpHandler);

      _updateClasses();
      element.classes.add('is-upgraded');
    }
  }

/// Downgrade the component.
/// 
///   MaterialSwitch.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {
    if (_rippleContainerElement) {
      _rippleContainerElement.removeEventListener('mouseup', boundMouseUpHandler);
    }
    _inputElement.removeEventListener('change', boundChangeHandler);
    _inputElement.removeEventListener('focus', boundFocusHandler);
    _inputElement.removeEventListener('blur', boundBlurHandler);
    element.removeEventListener('mouseup', boundMouseUpHandler);
  }

/// Public alias for the downgrade method.
/// 
/// public
  MaterialSwitch.prototype.mdlDowngrade =
      MaterialSwitch.prototype.mdlDowngrade_;

  MaterialSwitch.prototype['mdlDowngrade'] =
      MaterialSwitch.prototype.mdlDowngrade;

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialSwitch,
//     classAsString: 'MaterialSwitch',
//     cssClass: 'mdl-js-switch',
//     widget: true
//   });
// })();
