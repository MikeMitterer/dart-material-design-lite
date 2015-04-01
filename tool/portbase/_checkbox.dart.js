import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Checkbox WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialCheckbox {

    final element;

    MaterialCheckbox(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialCheckboxConstant {
    final int TINY_TIMEOUT = 0;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialCheckboxCssClasses {
    final String INPUT = 'wsk-checkbox__input';
    final String BOX_OUTLINE = 'wsk-checkbox__box-outline';
    final String FOCUS_HELPER = 'wsk-checkbox__focus-helper';
    final String TICK_OUTLINE = 'wsk-checkbox__tick-outline';
    final String RIPPLE_EFFECT = 'wsk-js-ripple-effect';
    final String RIPPLE_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';
    final String RIPPLE_CONTAINER = 'wsk-checkbox__ripple-container';
    final String RIPPLE_CENTER = 'wsk-ripple--center';
    final String RIPPLE = 'wsk-ripple';
    final String IS_FOCUSED = 'is-focused';
    final String IS_DISABLED = 'is-disabled';
    final String IS_CHECKED = 'is-checked';
    final String IS_UPGRADED = 'is-upgraded';
}

/// Handle change of state.
/// @param {Event} event The event that fired.
/// MaterialCheckbox.prototype.onChange_ = function(event) {
void _onChange(final html.Event event) {

  _updateClasses(_btnElement, element);
}

/// Handle focus of element.
/// @param {Event} event The event that fired.
/// MaterialCheckbox.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {

  element.classes.add(_cssClasses.IS_FOCUSED);
}

/// Handle lost focus of element.
/// @param {Event} event The event that fired.
/// MaterialCheckbox.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {

  element.classes.remove(_cssClasses.IS_FOCUSED);
}

/// Handle mouseup.
/// @param {Event} event The event that fired.
/// MaterialCheckbox.prototype.onMouseUp_ = function(event) {
void _onMouseUp(final html.Event event) {

  _blur();
}

/// Handle class updates.
/// @param {HTMLElement} button The button whose classes we should update.
/// @param {HTMLElement} label The label whose classes we should update.
/// MaterialCheckbox.prototype.updateClasses_ = function(button, label) {
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
/// MaterialCheckbox.prototype.blur_ = function(event) {
void _blur(final html.Event event) {

  // TODO: figure out why there's a focus event being fired after our blur,
  // so that we can avoid this hack.
  window.setTimeout( /*function*/ () {
    _btnElement.blur();
  }, _constant.TINY_TIMEOUT);
}

// Public methods.

/// Disable checkbox.
/// @public
/// MaterialCheckbox.prototype.disable = /*function*/ () {
void disable() {

  _btnElement.disabled = true;
  _updateClasses();
}

/// Enable checkbox.
/// @public
/// MaterialCheckbox.prototype.enable = /*function*/ () {
void enable() {

  _btnElement.disabled = false;
  _updateClasses();
}

/// Check checkbox.
/// @public
/// MaterialCheckbox.prototype.check = /*function*/ () {
void check() {

  _btnElement.checked = true;
  _updateClasses();
}

/// Uncheck checkbox.
/// @public
/// MaterialCheckbox.prototype.uncheck = /*function*/ () {
void uncheck() {

  _btnElement.checked = false;
  _updateClasses();
}

/// Initialize element.
/// MaterialCheckbox.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    _btnElement = element.querySelector('.' +
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

    final rippleContainer;
    if (element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
      element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

      rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
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
    _btnElement.onChange.listen( _onChange);

	// .addEventListener('focus', -- .onFocus.listen(<Event>);
    _btnElement.onFocus.listen( _onFocus);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
    _btnElement.onBlur.listen( _onBlur);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
    element.onMouseUp.listen( _onMouseUp);

    _updateClasses(_btnElement, element);
    element.classes.add(_cssClasses.IS_UPGRADED);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialCheckbox,
//   classAsString: 'MaterialCheckbox',
//   cssClass: 'wsk-js-checkbox'
// });
