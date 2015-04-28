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

/// Class constructor for Checkbox MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class MaterialSwitch {

    final element;

    MaterialSwitch(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _MaterialSwitchConstant {
    final int TINY_TIMEOUT = 0;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _MaterialSwitchCssClasses {
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
/// param {Event} event The event that fired.
/// MaterialSwitch.prototype.onChange_ = function(event) {
void _onChange(final html.Event event) {

  _updateClasses();
}

/// Handle focus of element.
/// param {Event} event The event that fired.
/// MaterialSwitch.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {

  element.classes.add(_cssClasses.IS_FOCUSED);
}

/// Handle lost focus of element.
/// param {Event} event The event that fired.
/// MaterialSwitch.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {

  element.classes.remove(_cssClasses.IS_FOCUSED);
}

/// Handle mouseup.
/// param {Event} event The event that fired.
/// MaterialSwitch.prototype.onMouseUp_ = function(event) {
void _onMouseUp(final html.Event event) {

  _blur();
}

/// Handle class updates.
/// param {HTMLElement} button The button whose classes we should update.
/// param {HTMLElement} label The label whose classes we should update.
/// MaterialSwitch.prototype.updateClasses_ = /*function*/ () {
void _updateClasses() {

  if (_inputElement.disabled) {
    element.classes.add(_cssClasses.IS_DISABLED);

  } else {
    element.classes.remove(_cssClasses.IS_DISABLED);
  }

  if (_inputElement.checked) {
    element.classes.add(_cssClasses.IS_CHECKED);

  } else {
    element.classes.remove(_cssClasses.IS_CHECKED);
  }
}

/// Add blur.
/// MaterialSwitch.prototype.blur_ = function(event) {
void _blur(final html.Event event) {

  // TODO: figure out why there's a focus event being fired after our blur,
  // so that we can avoid this hack.
  window.setTimeout( /*function*/ () {
    _inputElement.blur();
  }, _constant.TINY_TIMEOUT);
}

// Public methods.

/// Disable switch.
/// public
/// MaterialSwitch.prototype.disable = /*function*/ () {
void disable() {

  _inputElement.disabled = true;
  _updateClasses();
}

/// Enable switch.
/// public
/// MaterialSwitch.prototype.enable = /*function*/ () {
void enable() {

  _inputElement.disabled = false;
  _updateClasses();
}

/// Activate switch.
/// public
/// MaterialSwitch.prototype.on = /*function*/ () {
void on() {

  _inputElement.checked = true;
  _updateClasses();
}

/// Deactivate switch.
/// public
/// MaterialSwitch.prototype.off = /*function*/ () {
void off() {

  _inputElement.checked = false;
  _updateClasses();
}

/// Initialize element.
/// MaterialSwitch.prototype.init = /*function*/ () {
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

    final rippleContainer;
    if (element.classes.contains(
        _cssClasses.RIPPLE_EFFECT)) {
      element.classes.add(
          _cssClasses.RIPPLE_IGNORE_EVENTS);

      rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(
          _cssClasses.RIPPLE_CONTAINER);
      rippleContainer.classes.add(_cssClasses.RIPPLE_EFFECT);
      rippleContainer.classes.add(_cssClasses.RIPPLE_CENTER);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
      rippleContainer.onMouseUp.listen( _onMouseUp);

      final ripple = new html.SpanElement();
      ripple.classes.add(_cssClasses.RIPPLE);

      rippleContainer.append(ripple);
      element.append(rippleContainer);
    }

	// .addEventListener('change', -- .onChange.listen(<Event>);
    _inputElement.onChange.listen( _onChange);

	// .addEventListener('focus', -- .onFocus.listen(<Event>);
    _inputElement.onFocus.listen( _onFocus);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
    _inputElement.onBlur.listen( _onBlur);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
    element.onMouseUp.listen( _onMouseUp);

    _updateClasses();
    element.classes.add('is-upgraded');
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialSwitch,
//   classAsString: 'MaterialSwitch',
//   cssClass: 'mdl-js-switch'
// });
