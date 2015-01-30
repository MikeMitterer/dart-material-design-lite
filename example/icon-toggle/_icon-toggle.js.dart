import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for icon toggle WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialIconToggle {

    final element;

    MaterialIconToggle(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialIconToggleConstant {
    final int TINY_TIMEOUT = 0;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialIconToggleCssClasses {
    final String INPUT = 'wsk-icon-toggle__input';
    final String JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';
    final String RIPPLE_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';
    final String RIPPLE_CONTAINER = 'wsk-icon-toggle__ripple-container';
    final String RIPPLE_CENTER = 'wsk-ripple--center';
    final String RIPPLE = 'wsk-ripple';
    final String IS_FOCUSED = 'is-focused';
    final String IS_DISABLED = 'is-disabled';
    final String IS_CHECKED = 'is-checked';
}

/// Handle change of state.
/// @param {Event} event The event that fired.
/// MaterialIconToggle.prototype.onChange_ = function(event) {
void _onChange(var event) {

  _updateClasses(_btnElement, element);
}

/// Handle focus of element.
/// @param {Event} event The event that fired.
/// MaterialIconToggle.prototype.onFocus_ = function(event) {
void _onFocus(var event) {

  element.classes.add(_cssClasses.IS_FOCUSED);
}

/// Handle lost focus of element.
/// @param {Event} event The event that fired.
/// MaterialIconToggle.prototype.onBlur_ = function(event) {
void _onBlur(var event) {

  element.classes.remove(_cssClasses.IS_FOCUSED);
}

/// Handle mouseup.
/// @param {Event} event The event that fired.
/// MaterialIconToggle.prototype.onMouseUp_ = function(event) {
void _onMouseUp(var event) {

  _blur();
}

/// Handle class updates.
/// @param {HTMLElement} button The button whose classes we should update.
/// @param {HTMLElement} label The label whose classes we should update.
/// MaterialIconToggle.prototype.updateClasses_ = function(button, label) {
void _updateClasses(var button, label) {

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
/// MaterialIconToggle.prototype.blur_ = function(event) {
void _blur(var event) {

  // TODO: figure out why there's a focus event being fired after our blur,
  // so that we can avoid this hack.
  window.setTimeout( /*function*/ () {
    _btnElement.blur();
  }, _constant.TINY_TIMEOUT);
}

/// Initialize element.
/// MaterialIconToggle.prototype.init = /*function*/ () {
void init() {

  if (element) {
    _btnElement =
        element.querySelector('.' + _cssClasses.INPUT);

    final rippleContainer;
    if (element.classes.contains(_cssClasses.JS_RIPPLE_EFFECT)) {
      element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

      rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
      rippleContainer.classes.add(_cssClasses.JS_RIPPLE_EFFECT);
      rippleContainer.classes.add(_cssClasses.RIPPLE_CENTER);

      final ripple = new html.SpanElement();
      ripple.classes.add(_cssClasses.RIPPLE);

      rippleContainer.append(ripple);
      element.append(rippleContainer);
    }

		// -- .onChange.listen(<Event>);
    _btnElement.addEventListener('change', _onChange);

		// -- .onFocus.listen(<Event>);
    _btnElement.addEventListener('focus', _onFocus);

		// -- .onBlur.listen(<Event>);
    _btnElement.addEventListener('blur', _onBlur);

		// -- .onMouseUp.listen(<MouseEvent>);
    element.addEventListener('mouseup', _onMouseUp);

		// -- .onMouseUp.listen(<MouseEvent>);
    rippleContainer.addEventListener('mouseup', _onMouseUp);

    _updateClasses(_btnElement, element);
    element.classes.add('is-upgraded');
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialIconToggle,
//   classAsString: 'MaterialIconToggle',
//   cssClass: 'wsk-js-icon-toggle'
// });
