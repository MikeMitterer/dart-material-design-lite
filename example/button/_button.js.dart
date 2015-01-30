import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Button WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialButton {

    final element;

    MaterialButton(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialButtonConstant {
  // None for now.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialButtonCssClasses {
    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String WSK_BUTTON_RIPPLE_CONTAINER = 'wsk-button__ripple-container';

    final String WSK_RIPPLE = 'wsk-ripple';
}

/// Handle blur of element.
/// @param {HTMLElement} element The instance of a button we want to blur.
/// MaterialButton.prototype.blurHandlerGenerator_ = function(element) {
void _blurHandlerGenerator(final element) {

  return function() {element.blur();}
}

/// Initialize element.
/// MaterialButton.prototype.init = /*function*/ () {
void init() {

  if (element) {

    final blurHandler = _blurHandlerGenerator(element);
    if (element.classes.contains(
        _cssClasses.WSK_JS_RIPPLE_EFFECT)) {

      final rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(
          _cssClasses.WSK_BUTTON_RIPPLE_CONTAINER);

      final ripple = new html.SpanElement();
      ripple.classes.add(_cssClasses.WSK_RIPPLE);
      rippleContainer.append(ripple);

	// -- .onMouseUp.listen(<MouseEvent>);
      ripple.addEventListener('mouseup', blurHandler);
      element.append(rippleContainer);
    }

	// -- .onMouseUp.listen(<MouseEvent>);
    element.addEventListener('mouseup', blurHandler);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialButton,
//   classAsString: 'MaterialButton',
//   cssClass: 'wsk-js-button'
// });
