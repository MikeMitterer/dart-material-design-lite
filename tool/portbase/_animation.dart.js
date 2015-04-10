import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Animation WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class DemoAnimation {

    final element;

    DemoAnimation(this.element);

  _position = _constant.STARTING_POSITION;
  _movable = element.querySelector('.' + _cssClasses.MOVABLE);
  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _DemoAnimationConstant {
    final int STARTING_POSITION = 1;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _DemoAnimationCssClasses {
    final String MOVABLE = 'demo-animation__movable';
    final String POSITION_PREFIX = 'demo-animation--position-';
}

/// Handle click of element.
/// @param {Event} event The event that fired.
/// DemoAnimation.prototype.handleClick_ = function(event) {
void _handleClick(final html.Event event) {

  _movable.classes.remove(_cssClasses.POSITION_PREFIX +
      _position);
  _position++;
  if (_position > 6) {
    _position = 1;
  }
  _movable.classes.add(_cssClasses.POSITION_PREFIX +
      _position);
}

/// Initialize element.
/// DemoAnimation.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    if (!_movable) {
      console.error('Was expecting to find an element with class name ' +
          _cssClasses.MOVABLE + ' inside of: ', element);
      return;
    }

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
    element.onClick.listen( _handleClick);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: DemoAnimation,
//   classAsString: 'DemoAnimation',
//   cssClass: 'demo-js-animation'
// });
