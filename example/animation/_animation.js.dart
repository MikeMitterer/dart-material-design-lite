import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Animation WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialAnimation {

    final element;

    MaterialAnimation(this.element);

  _position = _constant.STARTING_POSITION;
  _moveable = element.querySelector('.' +
      _cssClasses.DEMO_JS_MOVABLE_AREA);
  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialAnimationConstant {
    final int STARTING_POSITION = 1;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialAnimationCssClasses {
    final String DEMO_JS_MOVABLE_AREA = 'demo-js-movable-area';

    final String DEMO_POSITION_PREFIX = 'demo-position-';
}

/// Handle click of element.
/// @param {Event} event The event that fired.
/// MaterialAnimation.prototype.handleClick_ = function(event) {
void _handleClick(final html.MouseEvent event) {

  _moveable.classes.remove(_cssClasses.DEMO_POSITION_PREFIX +
      _position);
  _position++;
  if (_position > 6) {
    _position = 1;
  }
  _moveable.classes.add(_cssClasses.DEMO_POSITION_PREFIX +
      _position);
}

/// Initialize element.
/// MaterialAnimation.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    if (!_moveable) {
      console.error('Was expecting to find an element with class ' +
          'name .demo-js-movable-area in side of: ', element);
      return;
    }

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
    element.onClick.listen( _handleClick);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialAnimation,
//   classAsString: 'MaterialAnimation',
//   cssClass: 'demo-js-clickable-area'
// });
