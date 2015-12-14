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

( /*function*/ () {

/// Class constructor for Tooltip MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {HTMLElement} element The element that will be upgraded.

  final MaterialTooltip = function MaterialTooltip(element) {

    // Initialize instance.
    init();
  }
  window['MaterialTooltip'] = MaterialTooltip;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialTooltipConstant {
    // None for now.
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialTooltipCssClasses {
      final String IS_ACTIVE = 'is-active';
      final String BOTTOM = 'mdl-tooltip--bottom';
      final String LEFT = 'mdl-tooltip--left';
      final String RIGHT = 'mdl-tooltip--right';
      final String TOP = 'mdl-tooltip--top';
  }

/// Handle mouseenter for tooltip.
/// 
/// param {Event} event The event that fired.
///   MaterialTooltip.prototype.handleMouseEnter_ = function(event) {
void _handleMouseEnter(final html.Event event) {

    final props = event.target.getBoundingClientRect();

    final left = props.left + (props.width / 2);

    final top = props.top + (props.height / 2);

    final marginLeft = -1 * (element.offsetWidth / 2);

    final marginTop = -1 * (element.offsetHeight / 2);

    if (element.classes.contains(_cssClasses.LEFT) || element.classes.contains(_cssClasses.RIGHT)) {
      left = (props.width / 2);
      if (top + marginTop < 0) {
        element.style.top = 0;
        element.style.marginTop = 0;

      } else {
        element.style.top = top + 'px';
        element.style.marginTop = marginTop + 'px';
      }

    } else {
      if (left + marginLeft < 0) {
        element.style.left = 0;
        element.style.marginLeft = 0;

      } else {
        element.style.left = left + 'px';
        element.style.marginLeft = marginLeft + 'px';
      }
    }

    if (element.classes.contains(_cssClasses.TOP)) {
      element.style.top = props.top - element.offsetHeight - 10 + 'px';
    } else if (element.classes.contains(_cssClasses.RIGHT)) {
      element.style.left = props.left + props.width + 10 + 'px';
    } else if (element.classes.contains(_cssClasses.LEFT)) {
      element.style.left = props.left - element.offsetWidth - 10 + 'px';

    } else {
      element.style.top = props.top + props.height + 10 + 'px';
    }

    element.classes.add(_cssClasses.IS_ACTIVE);
  }

/// Handle mouseleave for tooltip.
/// 
///   MaterialTooltip.prototype.handleMouseLeave_ = /*function*/ () {
void _handleMouseLeave() {
    element.classes.remove(_cssClasses.IS_ACTIVE);
  }

/// Initialize element.
///   MaterialTooltip.prototype.init = /*function*/ () {
void init() {

    if (element != null) {

      final forElId = element.getAttribute('for');

      if (forElId) {
        _forElement = html.document.getElementById(forElId);
      }

      if (_forElement) {
        // It's left here because it prevents accidental text selection on Android
        if (!_forElement.hasAttribute('tabindex')) {
          _forElement.setAttribute('tabindex', '0');
        }

        _boundMouseEnterHandler = handleMouseEnter;
        _boundMouseLeaveHandler = handleMouseLeave;

	// .addEventListener('mouseenter', -- .onMouseEnter.listen(<MouseEvent>);
        _forElement.onMouseEnter.listen( boundMouseEnterHandler, false);
        _forElement.addEventListener('touchend', boundMouseEnterHandler, false);

	// .addEventListener('mouseleave', -- .onMouseLeave.listen(<MouseEvent>);
        _forElement.onMouseLeave.listen( boundMouseLeaveHandler, false);
        window.addEventListener('touchstart', boundMouseLeaveHandler);
      }
    }
  }

/// Downgrade the component
/// 
///   MaterialTooltip.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {
    if (_forElement) {
      _forElement.removeEventListener('mouseenter', boundMouseEnterHandler, false);
      _forElement.removeEventListener('touchend', boundMouseEnterHandler, false);
      _forElement.removeEventListener('mouseleave', boundMouseLeaveHandler, false);
      window.removeEventListener('touchstart', boundMouseLeaveHandler);
    }
  }

/// Public alias for the downgrade method.
/// 
/// public
  MaterialTooltip.prototype.mdlDowngrade =
      MaterialTooltip.prototype.mdlDowngrade_;

  MaterialTooltip.prototype['mdlDowngrade'] =
      MaterialTooltip.prototype.mdlDowngrade;

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialTooltip,
//     classAsString: 'MaterialTooltip',
//     cssClass: 'mdl-tooltip'
//   });
// })();
