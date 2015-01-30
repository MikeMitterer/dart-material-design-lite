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
    final String WSK_CHECKBOX_INPUT = 'wsk-checkbox__input';

    final String WSK_CHECKBOX_BOX_OUTLINE = 'wsk-checkbox__box-outline';

    final String WSK_CHECKBOX_FOCUS_HELPER = 'wsk-checkbox__focus-helper';

    final String WSK_CHECKBOX_TICK_OUTLINE = 'wsk-checkbox__tick-outline';

    final String WSK_CHECKBOX_BOT_RIGHT = 'wsk-checkbox__bottom-right';

    final String WSK_CHECKBOX_BOT_LEFT = 'wsk-checkbox__bottom-left';

    final String WSK_CHECKBOX_BOTTOM = 'wsk-checkbox__bottom';

    final String WSK_CHECKBOX_TOP_LEFT = 'wsk-checkbox__top-left';

    final String WSK_CHECKBOX_TOP_RIGHT = 'wsk-checkbox__top-right';

    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    final String WSK_CHECKBOX_RIPPLE_CONTAINER = 'wsk-checkbox__ripple-container';

    final String WSK_RIPPLE_CENTER = 'wsk-ripple--center';

    final String WSK_RIPPLE = 'wsk-ripple';

    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';
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

/// Initialize element.
/// MaterialCheckbox.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    _btnElement = element.querySelector('.' +
        _cssClasses.WSK_CHECKBOX_INPUT);

    final boxOutline = new html.SpanElement();
    boxOutline.classes.add(_cssClasses.WSK_CHECKBOX_BOX_OUTLINE);

    final tickContainer = new html.SpanElement();
    tickContainer.classes.add(_cssClasses.WSK_CHECKBOX_FOCUS_HELPER);

    final tickOutline = new html.SpanElement();
    tickOutline.classes.add(_cssClasses.WSK_CHECKBOX_TICK_OUTLINE);

    final bottomRight = new html.SpanElement();
    bottomRight.classes.add(_cssClasses.WSK_CHECKBOX_BOT_RIGHT);

    final bottomLeft = new html.SpanElement();
    bottomLeft.classes.add(_cssClasses.WSK_CHECKBOX_BOT_LEFT);

    final bottom = new html.SpanElement();
    bottom.classes.add(_cssClasses.WSK_CHECKBOX_BOTTOM);

    final topLeft = new html.SpanElement();
    topLeft.classes.add(_cssClasses.WSK_CHECKBOX_TOP_LEFT);

    final topRight = new html.SpanElement();
    topRight.classes.add(_cssClasses.WSK_CHECKBOX_TOP_RIGHT);

    boxOutline.append(tickOutline);
    boxOutline.append(topLeft);
    boxOutline.append(topRight);
    boxOutline.append(bottomRight);
    boxOutline.append(bottomLeft);
    boxOutline.append(bottom);

    element.append(tickContainer);
    element.append(boxOutline);

    final rippleContainer;
    if (element.classes.contains(
        _cssClasses.WSK_JS_RIPPLE_EFFECT)) {
      element.classes.add(
          _cssClasses.WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS);

      rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(
          _cssClasses.WSK_CHECKBOX_RIPPLE_CONTAINER);
      rippleContainer.classes.add(_cssClasses.WSK_JS_RIPPLE_EFFECT);
      rippleContainer.classes.add(_cssClasses.WSK_RIPPLE_CENTER);

      final ripple = new html.SpanElement();
      ripple.classes.add(_cssClasses.WSK_RIPPLE);

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

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
    rippleContainer.onMouseUp.listen( _onMouseUp);

    _updateClasses(_btnElement, element);
    element.classes.add('is-upgraded');
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialCheckbox,
//   classAsString: 'MaterialCheckbox',
//   cssClass: 'wsk-js-checkbox'
// });
