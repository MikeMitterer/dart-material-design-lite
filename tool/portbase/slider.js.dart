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

/// Class constructor for Slider MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class MaterialSlider {

    final element;

    MaterialSlider(this.element);

  // Browser feature detection.
  _isIE = window.navigator.msPointerEnabled;
  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _MaterialSliderConstant {
  // None for now.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _MaterialSliderCssClasses {
    final String IE_CONTAINER = 'mdl-slider__ie-container';
    final String SLIDER_CONTAINER = 'mdl-slider__container';
    final String BACKGROUND_FLEX = 'mdl-slider__background-flex';
    final String BACKGROUND_LOWER = 'mdl-slider__background-lower';
    final String BACKGROUND_UPPER = 'mdl-slider__background-upper';
    final String IS_LOWEST_VALUE = 'is-lowest-value';
    final String IS_UPGRADED = 'is-upgraded';
}

/// Handle input on element.
/// param {Event} event The event that fired.
/// MaterialSlider.prototype.onInput_ = function(event) {
void _onInput(final html.Event event) {

  _updateValueStyles();
}

/// Handle change on element.
/// param {Event} event The event that fired.
/// MaterialSlider.prototype.onChange_ = function(event) {
void _onChange(final html.Event event) {

  _updateValueStyles();
}

/// Handle mouseup on element.
/// param {Event} event The event that fired.
/// MaterialSlider.prototype.onMouseUp_ = function(event) {
void _onMouseUp(final html.Event event) {

  event.target.blur();
}

/// Handle mousedown on container element.
/// This handler is purpose is to not require the use to click
/// exactly on the 2px slider element, as FireFox seems to be very
/// strict about 
/// param {Event} event The event that fired.
/// MaterialSlider.prototype.onContainerMouseDown_ = function(event) {
void _onContainerMouseDown(final html.Event event) {

  // If this click is not on the parent element (but rather some child)
  // ignore. It may still bubble up.
  if(event.target != element.parentElement) {
    return;
  }

  // Discard the original event and create a new event that
  // is on the slider element.
  event.preventDefault();

  final newEvent = new MouseEvent('mousedown', {
    target: event.target,
    buttons: event.buttons,
    clientX: event.clientX,
    clientY: element.getBoundingClientRect().y
  });
  element.dispatchEvent(newEvent);
}

/// Handle updating of values.
/// param {Event} event The event that fired.
/// MaterialSlider.prototype.updateValueStyles_ = function(event) {
void _updateValueStyles(final html.Event event) {

  // Calculate and apply percentages to div structure behind slider.

  final fraction = (element.value - element.min) /
      (element.max - element.min);

  if (fraction == 0) {
    element.classes.add(_cssClasses.IS_LOWEST_VALUE);

  } else {
    element.classes.remove(_cssClasses.IS_LOWEST_VALUE);
  }

  if (!_isIE) {
    _backgroundLower.style.flex = fraction;
    _backgroundLower.style.webkitFlex = fraction;
    _backgroundUpper.style.flex = 1 - fraction;
    _backgroundUpper.style.webkitFlex = 1 - fraction;
  }
}

// Public methods.

/// Disable slider.
/// public
/// MaterialSlider.prototype.disable = /*function*/ () {
void disable() {

  element.disabled = true;
}

/// Enable slider.
/// public
/// MaterialSlider.prototype.enable = /*function*/ () {
void enable() {

  element.disabled = false;
}

/// Update slider value.
/// param {Number} value The value to which to set the control (optional).
/// public
/// MaterialSlider.prototype.change = function(value) {
void change(final value) {

  if (value) {
    element.value = value;
  }
  _updateValueStyles();
}

/// Initialize element.
/// MaterialSlider.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    if (_isIE) {
      // Since we need to specify a very large height in IE due to
      // implementation limitations, we add a parent here that trims it down to
      // a reasonable size.

      final containerIE = new html.DivElement();
      containerIE.classes.add(_cssClasses.IE_CONTAINER);
      element.parent.insertBefore(containerIE, element);
      element.parent.removeChild(element);
      containerIE.append(element);

    } else {
      // For non-IE browsers, we need a div structure that sits behind the
      // slider and allows us to style the left and right sides of it with
      // different colors.

      final container = new html.DivElement();
      container.classes.add(_cssClasses.SLIDER_CONTAINER);
      element.parent.insertBefore(container, element);
      element.parent.removeChild(element);
      container.append(element);

      final backgroundFlex = new html.DivElement();
      backgroundFlex.classes.add(_cssClasses.BACKGROUND_FLEX);
      container.append(backgroundFlex);

      _backgroundLower = new html.DivElement();
      _backgroundLower.classes.add(_cssClasses.BACKGROUND_LOWER);
      backgroundFlex.append(_backgroundLower);

      _backgroundUpper = new html.DivElement();
      _backgroundUpper.classes.add(_cssClasses.BACKGROUND_UPPER);
      backgroundFlex.append(_backgroundUpper);
    }

    element.addEventListener('input', _onInput);

	// .addEventListener('change', -- .onChange.listen(<Event>);
    element.onChange.listen( _onChange);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
    element.onMouseUp.listen( _onMouseUp);
    element.parent.addEventListener('mousedown', _onContainerMouseDown);

    _updateValueStyles();
    element.classes.add(_cssClasses.IS_UPGRADED);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialSlider,
//   classAsString: 'MaterialSlider',
//   cssClass: 'mdl-js-slider'
// });
