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

/// Class constructor for Tooltip MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class MaterialTooltip {

    final element;

    MaterialTooltip(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _MaterialTooltipConstant {
  // None for now.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _MaterialTooltipCssClasses {
    final String IS_ACTIVE = 'is-active';
}

/// Handle mouseenter for tooltip.
/// param {Event} event The event that fired.
/// MaterialTooltip.prototype.handleMouseEnter_ = function(event) {
void _handleMouseEnter(final html.Event event) {

  event.stopPropagation();

  final props = event.target.getBoundingClientRect();

  final left = props.left + (props.width / 2);

  final marginLeft = -1 * (element.offsetWidth / 2);

  if (left + marginLeft < 0) {
    element.style.left = 0;
    element.style.marginLeft = 0;

  } else {
    element.style.left = left + 'px';
    element.style.marginLeft = marginLeft + 'px';
  }

  element.style.top = props.top + props.height + 10 + 'px';
  element.classes.add(_cssClasses.IS_ACTIVE);

	// .addEventListener('scroll', -- .onScroll.listen(<Event>);
  window.onScroll.listen( boundMouseLeaveHandler, false);
  window.addEventListener('touchmove', boundMouseLeaveHandler, false);
}

/// Handle mouseleave for tooltip.
/// param {Event} event The event that fired.
/// MaterialTooltip.prototype.handleMouseLeave_ = function(event) {
void _handleMouseLeave(final html.Event event) {

  event.stopPropagation();
  element.classes.remove(_cssClasses.IS_ACTIVE);
  window.removeEventListener('scroll', boundMouseLeaveHandler);
  window.removeEventListener('touchmove', boundMouseLeaveHandler, false);
}

/// Initialize element.
/// MaterialTooltip.prototype.init = /*function*/ () {
void init() {

  if (element != null) {

    final forElId = element.getAttribute('for');

    if (forElId) {
      _forElement = html.document.getElementById(forElId);
    }

    if (_forElement) {
      // Tabindex needs to be set for `blur` events to be emitted
      if (!_forElement.getAttribute('tabindex')) {
        _forElement.setAttribute('tabindex', '0');
      }

      _boundMouseEnterHandler = handleMouseEnter;
      _boundMouseLeaveHandler = handleMouseLeave;

	// .addEventListener('mouseenter', -- .onMouseEnter.listen(<MouseEvent>);
      _forElement.onMouseEnter.listen( boundMouseEnterHandler,
          false);

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
      _forElement.onClick.listen( boundMouseEnterHandler,
          false);

	// .addEventListener('blur', -- .onBlur.listen(<Event>);
      _forElement.onBlur.listen( boundMouseLeaveHandler);
      _forElement.addEventListener('touchstart', boundMouseEnterHandler,
          false);

	// .addEventListener('mouseleave', -- .onMouseLeave.listen(<MouseEvent>);
      _forElement.onMouseLeave.listen( boundMouseLeaveHandler);
    }
  }
}

/// Downgrade the component
/// 
/// MaterialTooltip.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {
  if (_forElement) {
    _forElement.removeEventListener('mouseenter', boundMouseEnterHandler, false);
    _forElement.removeEventListener('click', boundMouseEnterHandler, false);
    _forElement.removeEventListener('touchstart', boundMouseEnterHandler, false);
    _forElement.removeEventListener('mouseleave', boundMouseLeaveHandler);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialTooltip,
//   classAsString: 'MaterialTooltip',
//   cssClass: 'mdl-tooltip'
// });
