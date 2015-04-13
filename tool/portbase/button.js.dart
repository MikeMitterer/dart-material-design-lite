import 'dart:html' as html;
import 'dart:math' as Math;

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

/// Class constructor for Button WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class MaterialButton {

    final element;

    MaterialButton(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _MaterialButtonConstant {
  // None for now.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _MaterialButtonCssClasses {
    final String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
    final String RIPPLE_CONTAINER = 'mdl-button__ripple-container';
    final String RIPPLE = 'mdl-ripple';
}

/// Handle blur of element.
/// param {HTMLElement} element The instance of a button we want to blur.
/// MaterialButton.prototype.blurHandler = function(event) {
void blurHandler(final html.Event event) {

  if (event) {
    element.blur();
  }
}

// Public methods.

/// Disable button.
/// public
/// MaterialButton.prototype.disable = /*function*/ () {
void disable() {

  element.disabled = true;
}

/// Enable button.
/// public
/// MaterialButton.prototype.enable = /*function*/ () {
void enable() {

  element.disabled = false;
}

/// Initialize element.
/// MaterialButton.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    if (element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {

      final rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);

      final ripple = new html.SpanElement();
      ripple.classes.add(_cssClasses.RIPPLE);
      rippleContainer.append(ripple);

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
      ripple.onMouseUp.listen( blurHandler);
      element.append(rippleContainer);
    }

	// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
    element.onMouseUp.listen( blurHandler);

	// .addEventListener('mouseleave', -- .onMouseLeave.listen(<MouseEvent>);
    element.onMouseLeave.listen( blurHandler);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialButton,
//   classAsString: 'MaterialButton',
//   cssClass: 'mdl-js-button'
// });
