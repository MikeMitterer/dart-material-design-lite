import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Textfield WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialTextfield {

    final element;

    MaterialTextfield(this.element);

  _maxRows = constant.NO_MAX_ROWS;
  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialTextfieldConstant {
    final int NO_MAX_ROWS = -1;
    final String MAX_ROWS_ATTRIBUTE = 'maxrows';
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialTextfieldCssClasses {
    final String WSK_TEXT_EXP_ICO_RIP_CONTAINER = 'wsk-textfield-expandable-icon__ripple__';
      'container',

    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String WSK_RIPPLE_CENTER = 'wsk-ripple--center';

    final String WSK_RIPPLE = 'wsk-ripple';

    final String IS_DIRTY = 'is-dirty';
}

/// Handle upgrade of icon element.
/// @param {HTMLElement} iconElement HTML element to contain icon.
/// MaterialTextfield.prototype.expandableIcon_ = function(iconElement) {
void _expandableIcon(var iconElement) {

  if (!iconElement.getAttribute('data-upgraded')) {

    final container = new html.SpanElement();
    container.classes.add(_cssClasses.WSK_TEXT_EXP_ICO_RIP_CONTAINER);
    container.classes.add(_cssClasses.WSK_JS_RIPPLE_EFFECT);
    container.classes.add(_cssClasses.WSK_RIPPLE_CENTER);

    final ripple = new html.SpanElement();
    ripple.classes.add(_cssClasses.WSK_RIPPLE);
    container.append(ripple);

    iconElement.append(container);
    iconElement.setAttribute('data-upgraded', '');
  }
}

/// Handle input being entered.
/// @param {Event} event The event that fired.
/// MaterialTextfield.prototype.onInputChange_ = function(event) {
void _onInputChange(var event) {

  if (event.target.value && event.target.value.length > 0) {
    event.target.classes.add(_cssClasses.IS_DIRTY);

  } else {
    event.target.classes.remove(_cssClasses.IS_DIRTY);
  }
}

/// Handle input being entered.
/// @param {Event} event The event that fired.
/// MaterialTextfield.prototype.onKeyDown_ = function(event) {
void _onKeyDown(var event) {

  final currentRowCount = event.target.value.split('\n').length;
  if (event.keyCode == 13) {
    if (currentRowCount >= maxRows) {
      event.preventDefault();
    }
  }
}

/// Initialize element.
/// MaterialTextfield.prototype.init = /*function*/ () {
void init() {

  if (element) {

    final expandableIcons =
        document.querySelectorAll('.wsk-textfield-expandable-icon');

    for (final i = 0; i < expandableIcons.length; ++i) {
      _expandableIcon(expandableIcons[i]);
    }

    if (element.hasAttribute(_constant.MAX_ROWS_ATTRIBUTE)) {
      maxRows = parseInt(element.getAttribute(
          _constant.MAX_ROWS_ATTRIBUTE), 10);
      if (isNaN(maxRows)) {
        console.log(
            'maxrows attribute provided, but wasn\'t a number: ' +
            maxRows);
        _maxRows = constant.NO_MAX_ROWS;
      }
    }

    element.addEventListener('input', _onInputChange);
    if (_maxRows !== constant.NO_MAX_ROWS) {
      // TODO: This should handle pasting multi line text.
      // Currently doesn't.
      element.addEventListener('keydown', _onKeyDown);
    }
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialTextfield,
//   classAsString: 'MaterialTextfield',
//   cssClass: 'wsk-js-textfield'
// });
