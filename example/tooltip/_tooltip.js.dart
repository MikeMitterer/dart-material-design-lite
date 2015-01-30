import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Tooltip WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialTooltip {

    final element;

    MaterialTooltip(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialTooltipConstant {
  // None for now.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialTooltipCssClasses {
    final String IS_ACTIVE = 'is-active';
}

/// Handle mouseenter for tooltip.
/// @param {Event} event The event that fired.
/// MaterialTooltip.prototype.handleMouseEnter_ = function(event) {
void _handleMouseEnter(var event) {

  event.stopPropagation();

  final props = event.target.getBoundingClientRect();
  element.style.left = props.left + (props.width / 2) + 'px';
  element.style.marginLeft = -1 * (element.offsetWidth / 2) + 'px';
  element.style.top = props.top + props.height + 10 + 'px';
  element.classes.add(_cssClasses.IS_ACTIVE);
}

/// Handle mouseleave for tooltip.
/// @param {Event} event The event that fired.
/// MaterialTooltip.prototype.handleMouseLeave_ = function(event) {
void _handleMouseLeave(var event) {
git
  event.stopPropagation();
  element.classes.remove(_cssClasses.IS_ACTIVE);
}

/// Initialize element.
/// MaterialTooltip.prototype.init = /*function*/ () {
void init() {

  if (element) {

    final forElId = element.getAttribute('for');

    final forEl = document.getElementById(forElId);

    forEl.addEventListener('mouseenter', _handleMouseEnter,
        false);
    forEl.addEventListener('mouseleave', _handleMouseLeave);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialTooltip,
//   classAsString: 'MaterialTooltip',
//   cssClass: 'wsk-tooltip'
// });
