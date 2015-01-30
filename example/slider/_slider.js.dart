import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Slider WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialSlider {

    final element;

    MaterialSlider(this.element);

  // Browser feature detection.
  _isIE = window.navigator.msPointerEnabled;
  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialSliderConstant {
  // None for now.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialSliderCssClasses {
    final String WSK_SLIDER_IE_CONTAINER = 'wsk-slider__ie-container';

    final String WSK_SLIDER_CONTAINER = 'wsk-slider__container';

    final String WSK_SLIDER_BACKGROUND_FLEX = 'wsk-slider__background-flex';

    final String WSK_SLIDER_BACKGROUND_LOW = 'wsk-slider__background-lower';

    final String WSK_SLIDER_BACKGROUND_UP = 'wsk-slider__background-upper';

    final String IS_LOWEST_VALUE = 'is-lowest-value';
}

/// Handle input on element.
/// @param {Event} event The event that fired.
/// MaterialSlider.prototype.onInput_ = function(event) {
void _onInput(var event) {

  _updateValue();
}

/// Handle change on element.
/// @param {Event} event The event that fired.
/// MaterialSlider.prototype.onChange_ = function(event) {
void _onChange(var event) {

  _updateValue();
}

/// Handle mouseup on element.
/// @param {Event} event The event that fired.
/// MaterialSlider.prototype.onMouseUp_ = function(event) {
void _onMouseUp(var event) {

   event.target.blur();
}

/// Handle updating of values.
/// @param {Event} event The event that fired.
/// MaterialSlider.prototype.updateValue_ = function(event) {
void _updateValue(var event) {

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

/// Initialize element.
/// MaterialSlider.prototype.init = /*function*/ () {
void init() {

  if (element) {
    if (_isIE) {
      // Since we need to specify a very large height in IE due to
      // implementation limitations, we add a parent here that trims it down to
      // a reasonable size.

      final containerIE = new html.DivElement();
      containerIE.classes.add(_cssClasses.WSK_SLIDER_IE_CONTAINER);
      element.parentElement.insertBefore(containerIE, element);
      element.parentElement.removeChild(element);
      containerIE.append(element);

    } else {
      // For non-IE browsers, we need a div structure that sits behind the
      // slider and allows us to style the left and right sides of it with
      // different colors.

      final container = new html.DivElement();
      container.classes.add(_cssClasses.WSK_SLIDER_CONTAINER);
      element.parentElement.insertBefore(container, element);
      element.parentElement.removeChild(element);
      container.append(element);

      final backgroundFlex = new html.DivElement();
      backgroundFlex.classes.add(_cssClasses.WSK_SLIDER_BACKGROUND_FLEX);
      container.append(backgroundFlex);

      _backgroundLower = new html.DivElement();
      _backgroundLower.classes.add(
          _cssClasses.WSK_SLIDER_BACKGROUND_LOW);
      backgroundFlex.append(_backgroundLower);

      _backgroundUpper = new html.DivElement();
      _backgroundUpper.classes.add(
          _cssClasses.WSK_SLIDER_BACKGROUND_UP);
      backgroundFlex.append(_backgroundUpper);
    }

    element.addEventListener('input', _onInput);

		// -- .onChange.listen(<Event>);
    element.addEventListener('change', _onChange);

		// -- .onMouseUp.listen(<MouseEvent>);
    element.addEventListener('mouseup', _onMouseUp);

    _updateValue();
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialSlider,
//   classAsString: 'MaterialSlider',
//   cssClass: 'wsk-js-slider'
// });
