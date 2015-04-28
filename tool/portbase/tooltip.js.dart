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
  element.style.left = props.left + (props.width / 2) + 'px';
  element.style.marginLeft = -1 * (element.offsetWidth / 2) + 'px';
  element.style.top = props.top + props.height + 10 + 'px';
  element.classes.add(_cssClasses.IS_ACTIVE);
}

/// Handle mouseleave for tooltip.
/// param {Event} event The event that fired.
/// MaterialTooltip.prototype.handleMouseLeave_ = function(event) {
void _handleMouseLeave(final html.Event event) {

  event.stopPropagation();
  element.classes.remove(_cssClasses.IS_ACTIVE);
}

/// Initialize element.
/// MaterialTooltip.prototype.init = /*function*/ () {
void init() {

  if (element != null) {

    final forElId = element.getAttribute('for');

    final forEl = null;

    if (forElId) {
      forEl = html.document.getElementById(forElId);
    }

    if (forEl) {

	// .addEventListener('mouseenter', -- .onMouseEnter.listen(<MouseEvent>);
      forEl.onMouseEnter.listen( _handleMouseEnter,
          false);

	// .addEventListener('mouseleave', -- .onMouseLeave.listen(<MouseEvent>);
      forEl.onMouseLeave.listen( _handleMouseLeave);
    }
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialTooltip,
//   classAsString: 'MaterialTooltip',
//   cssClass: 'mdl-tooltip'
// });
