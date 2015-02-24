import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Radio WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialRadio {

    final element;

    MaterialRadio(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialRadioConstant {
    final int TINY_TIMEOUT = 0;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialRadioCssClasses {
    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';

    final String IS_UPGRADED = 'is-upgraded';

    final String WSK_JS_RADIO = 'wsk-js-radio';

    final String WSK_RADIO_BTN = 'wsk-radio__button';

    final String WSK_RADIO_OUTER_CIRCLE = 'wsk-radio__outer-circle';

    final String WSK_RADIO_INNER_CIRCLE = 'wsk-radio__inner-circle';

    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    final String WSK_RADIO_RIPPLE_CONTAINER = 'wsk-radio__ripple-container';

    final String WSK_RIPPLE_CENTER = 'wsk-ripple--center';

    final String WSK_RIPPLE = 'wsk-ripple';
}

/// Handle change of state.
/// @param {Event} event The event that fired.
/// MaterialRadio.prototype.onChange_ = function(event) {
void _onChange(final html.Event event) {

  _updateClasses(_btnElement, element);

  // Since other radio buttons don't get change events, we need to look for
  // them to update their classes.

  final radios = document.getElementsByClassName(_cssClasses.WSK_JS_RADIO);

  for (final i = 0; i < radios.length; i++) {

    final button = radios[i].querySelector('.' + _cssClasses.WSK_RADIO_BTN);
    // Different name == different group, so no point updating those.
    if (button.getAttribute('name') == _btnElement.getAttribute('name')) {
      _updateClasses(button, radios[i]);
    }
  }
}

/// Handle focus.
/// @param {Event} event The event that fired.
/// MaterialRadio.prototype.onFocus_ = function(event) {
void _onFocus(final html.Event event) {

  element.classes.add(_cssClasses.IS_FOCUSED);
}

/// Handle lost focus.
/// @param {Event} event The event that fired.
/// MaterialRadio.prototype.onBlur_ = function(event) {
void _onBlur(final html.Event event) {

  element.classes.remove(_cssClasses.IS_FOCUSED);
}

/// Handle mouseup.
/// @param {Event} event The event that fired.
/// MaterialRadio.prototype.onMouseup_ = function(event) {
void _onMouseup(final html.Event event) {

  _blur();
}

/// Update classes.
/// @param {HTMLElement} button The button whose classes we should update.
/// @param {HTMLElement} label The label whose classes we should update.
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

/// Initialize element.
/// MaterialRadio.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    _btnElement = element.querySelector('.' +
        _cssClasses.WSK_RADIO_BTN);

    final outerCircle = new html.SpanElement();
    outerCircle.classes.add(_cssClasses.WSK_RADIO_OUTER_CIRCLE);

    final innerCircle = new html.SpanElement();
    innerCircle.classes.add(_cssClasses.WSK_RADIO_INNER_CIRCLE);

    element.append(outerCircle);
    element.append(innerCircle);

    final rippleContainer;
    if (element.classes.contains(
        _cssClasses.WSK_JS_RIPPLE_EFFECT)) {
      element.classes.add(
          _cssClasses.WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS);

      rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(
          _cssClasses.WSK_RADIO_RIPPLE_CONTAINER);
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
    element.onMouseUp.listen( _onMouseup);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
    rippleContainer.onMouseUp.listen( _onMouseup);

    _updateClasses(_btnElement, element);
    element.classes.add(_cssClasses.IS_UPGRADED);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialRadio,
//   classAsString: 'MaterialRadio',
//   cssClass: 'wsk-js-radio'
// });
