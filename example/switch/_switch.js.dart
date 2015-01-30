import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Checkbox WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialSwitch {

    final element;

    MaterialSwitch(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialSwitchConstant {
    final int TINY_TIMEOUT = 0;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialSwitchCssClasses {
    final String WSK_SWITCH_INPUT = 'wsk-switch__input';

    final String WSK_SWITCH_TRACK = 'wsk-switch__track';

    final String WSK_SWITCH_THUMB = 'wsk-switch__thumb';

    final String WSK_SWITCH_FOCUS_HELPER = 'wsk-switch__focus-helper';

    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    final String WSK_SWITCH_RIPPLE_CONTAINER = 'wsk-switch__ripple-container';

    final String WSK_RIPPLE_CENTER = 'wsk-ripple--center';

    final String WSK_RIPPLE = 'wsk-ripple';

    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';
}

/// Handle change of state.
/// @param {Event} event The event that fired.
/// MaterialSwitch.prototype.onChange_ = function(event) {
void _onChange(final html.MouseEvent event) {

  _updateClasses(_btnElement, element);
}

/// Handle focus of element.
/// @param {Event} event The event that fired.
/// MaterialSwitch.prototype.onFocus_ = function(event) {
void _onFocus(final html.MouseEvent event) {

  element.classes.add(_cssClasses.IS_FOCUSED);
}

/// Handle lost focus of element.
/// @param {Event} event The event that fired.
/// MaterialSwitch.prototype.onBlur_ = function(event) {
void _onBlur(final html.MouseEvent event) {

  element.classes.remove(_cssClasses.IS_FOCUSED);
}

/// Handle mouseup.
/// @param {Event} event The event that fired.
/// MaterialSwitch.prototype.onMouseUp_ = function(event) {
void _onMouseUp(final html.MouseEvent event) {

  _blur();
}

/// Handle class updates.
/// @param {HTMLElement} button The button whose classes we should update.
/// @param {HTMLElement} label The label whose classes we should update.
/// MaterialSwitch.prototype.updateClasses_ = function(button, label) {
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
/// MaterialSwitch.prototype.blur_ = function(event) {
void _blur(final html.MouseEvent event) {

  // TODO: figure out why there's a focus event being fired after our blur,
  // so that we can avoid this hack.
  window.setTimeout( /*function*/ () {
    _btnElement.blur();
  }, _constant.TINY_TIMEOUT);
}

/// Initialize element.
/// MaterialSwitch.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    _btnElement = element.querySelector('.' +
        _cssClasses.WSK_SWITCH_INPUT);

    final track = new html.DivElement();
    track.classes.add(_cssClasses.WSK_SWITCH_TRACK);

    final thumb = new html.DivElement();
    thumb.classes.add(_cssClasses.WSK_SWITCH_THUMB);

    final focusHelper = new html.SpanElement();
    focusHelper.classes.add(_cssClasses.WSK_SWITCH_FOCUS_HELPER);

    thumb.append(focusHelper);

    element.append(track);
    element.append(thumb);

    final rippleContainer;
    if (element.classes.contains(
        _cssClasses.WSK_JS_RIPPLE_EFFECT)) {
      element.classes.add(
          _cssClasses.WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS);

      rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(
          _cssClasses.WSK_SWITCH_RIPPLE_CONTAINER);
      rippleContainer.classes.add(_cssClasses.WSK_JS_RIPPLE_EFFECT);
      rippleContainer.classes.add(_cssClasses.WSK_RIPPLE_CENTER);

      final ripple = new html.SpanElement();
      ripple.classes.add(_cssClasses.WSK_RIPPLE);

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
//   constructor: MaterialSwitch,
//   classAsString: 'MaterialSwitch',
//   cssClass: 'wsk-js-switch'
// });
