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

/// Class constructor for Radio WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class MaterialRadio {

    final element;

    MaterialRadio(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _MaterialRadioConstant {
    final int TINY_TIMEOUT = 0;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _MaterialRadioCssClasses {
    final String IS_FOCUSED = 'is-focused';
    final String IS_DISABLED = 'is-disabled';
    final String IS_CHECKED = 'is-checked';
    final String IS_UPGRADED = 'is-upgraded';
    final String JS_RADIO = 'mdl-js-radio';
    final String RADIO_BTN = 'mdl-radio__button';
    final String RADIO_OUTER_CIRCLE = 'mdl-radio__outer-circle';
    final String RADIO_INNER_CIRCLE = 'mdl-radio__inner-circle';
    final String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
    final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
    final String RIPPLE_CONTAINER = 'mdl-radio__ripple-container';
    final String RIPPLE_CENTER = 'mdl-ripple--center';
    final String RIPPLE = 'mdl-ripple';
}

/// Handle change of state.
/// param {Event} event The event that fired.
/// MaterialRadio.prototype.onChange_ = function(event) {
void _onChange(final html.Event event) {

  _updateClasses(_btnElement, element);

  // Since other radio buttons don't get change events, we need to look for
  // them to update their classes.

  final radios = document.getElementsByClassName(_cssClasses.JS_RADIO);

  for (final i = 0; i < radios.length; i++) {

    final button = radios[i].querySelector('.' + _cssClasses.RADIO_BTN);
    // Different name == different group, so no point updating those.
    if (button.getAttribute('name') == _btnElement.getAttribute('name')) {
      _updateClasses(button, radios[i]);
    }
  }
}

/// Handle focus.
/// param {Event} event The event that fired.
/// MaterialRadio.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {

  element.classes.add(_cssClasses.IS_FOCUSED);
}

/// Handle lost focus.
/// param {Event} event The event that fired.
/// MaterialRadio.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {

  element.classes.remove(_cssClasses.IS_FOCUSED);
}

/// Handle mouseup.
/// param {Event} event The event that fired.
/// MaterialRadio.prototype.onMouseup_ = function(event) {
void _onMouseup(final html.Event event) {

  _blur();
}

/// Update classes.
/// param {HTMLElement} button The button whose classes we should update.
/// param {HTMLElement} label The label whose classes we should update.
/// MaterialRadio.prototype.updateClasses_ = function(button, label) {
void _updateClasses(final button, label) {

  if (button.disabled) {
    label.classes.add(_cssClasses.IS_DISABLED);

  } else {
    label.classes.remove(_cssClasses.IS_DISABLED);
  }

  if (button.checked) {
    label.classes.add(_cssClasses.IS_CHECKED);

  } else {
    label.classes.remove(_cssClasses.IS_CHECKED);
  }
}

/// Add blur.
/// MaterialRadio.prototype.blur_ = function(event) {
void _blur(final html.Event event) {

  // TODO: figure out why there's a focus event being fired after our blur,
  // so that we can avoid this hack.
  window.setTimeout( /*function*/ () {
    _btnElement.blur();
  }, _constant.TINY_TIMEOUT);
}

// Public methods.

/// Disable radio.
/// public
/// MaterialRadio.prototype.disable = /*function*/ () {
void disable() {

  _btnElement.disabled = true;
  _updateClasses(_btnElement, element);
}

/// Enable radio.
/// public
/// MaterialRadio.prototype.enable = /*function*/ () {
void enable() {

  _btnElement.disabled = false;
  _updateClasses(_btnElement, element);
}

/// Check radio.
/// public
/// MaterialRadio.prototype.check = /*function*/ () {
void check() {

  _btnElement.checked = true;
  _updateClasses(_btnElement, element);
}

/// Uncheck radio.
/// public
/// MaterialRadio.prototype.uncheck = /*function*/ () {
void uncheck() {

  _btnElement.checked = false;
  _updateClasses(_btnElement, element);
}

/// Initialize element.
/// MaterialRadio.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    _btnElement = element.querySelector('.' +
        _cssClasses.RADIO_BTN);

    final outerCircle = new html.SpanElement();
    outerCircle.classes.add(_cssClasses.RADIO_OUTER_CIRCLE);

    final innerCircle = new html.SpanElement();
    innerCircle.classes.add(_cssClasses.RADIO_INNER_CIRCLE);

    element.append(outerCircle);
    element.append(innerCircle);

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
      rippleContainer.onMouseUp.listen( _onMouseup);

      final ripple = new html.SpanElement();
      ripple.classes.add(_cssClasses.RIPPLE);

      rippleContainer.append(ripple);
      element.append(rippleContainer);
    }

	// .addEventListener('change', -- .onChange.listen(<Event>);
    _btnElement.onChange.listen( _onChange);

	// .addEventListener('focus', -- .onFocus.listen(<Event>);
    _btnElement.onFocus.listen( _onFocus);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
    _btnElement.onBlur.listen( _onBlur);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
    element.onMouseUp.listen( _onMouseup);

    _updateClasses(_btnElement, element);
    element.classes.add(_cssClasses.IS_UPGRADED);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialRadio,
//   classAsString: 'MaterialRadio',
//   cssClass: 'mdl-js-radio'
// });
