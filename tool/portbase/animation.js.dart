import 'dart:html' as html;
import 'dart:math' as Math;

/// license
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

/// Class constructor for Animation MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class DemoAnimation {

    final element;

    DemoAnimation(this.element);

  _position = _constant.STARTING_POSITION;
  _movable = element.querySelector('.' + _cssClasses.MOVABLE);
  // Initialize instance.
  init();
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _DemoAnimationCssClasses {
    final String MOVABLE = 'demo-animation__movable';
    final String POSITION_PREFIX = 'demo-animation--position-';
    final String FAST_OUT_SLOW_IN = 'mdl-animation--fast-out-slow-in';
    final String LINEAR_OUT_SLOW_IN = 'mdl-animation--linear-out-slow-in';
    final String FAST_OUT_LINEAR_IN = 'mdl-animation--fast-out-linear-in';
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _DemoAnimationConstant {
    final int STARTING_POSITION = 0;
  // Which animation to use for which state. Check demo.css for an explanation.
  ANIMATIONS: [
    DemoAnimation.prototype._cssClasses.FAST_OUT_LINEAR_IN,
    DemoAnimation.prototype._cssClasses.LINEAR_OUT_SLOW_IN,
    DemoAnimation.prototype._cssClasses.FAST_OUT_SLOW_IN,
    DemoAnimation.prototype._cssClasses.FAST_OUT_LINEAR_IN,
    DemoAnimation.prototype._cssClasses.LINEAR_OUT_SLOW_IN,
    DemoAnimation.prototype._cssClasses.FAST_OUT_SLOW_IN
  ]
}

/// Handle click of element.
/// param {Event} event The event that fired.
/// DemoAnimation.prototype.handleClick_ = function(event) {
void _handleClick(final html.Event event) {

  _movable.classes.remove(_cssClasses.POSITION_PREFIX +
      _position);
  _movable.classes.remove(_constant.ANIMATIONS[_position]);

  _position++;
  if (_position > 5) {
    _position = 0;
  }

  _movable.classes.add(_constant.ANIMATIONS[_position]);
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
