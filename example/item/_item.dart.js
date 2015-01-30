import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Item WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialItem {

    final element;

    MaterialItem(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialItemConstant {
  // None for now.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialItemCssClasses {
    final String WSK_ITEM_RIPPLE_CONTAINER = 'wsk-item--ripple-container';

    final String WSK_RIPPLE = 'wsk-ripple';
}

/// Initialize element.
/// MaterialItem.prototype.init = /*function*/ () {
void init() {

  if (element != null) {

    final rippleContainer = new html.SpanElement();
    rippleContainer.classes.add(_cssClasses.WSK_ITEM_RIPPLE_CONTAINER);

    final ripple = new html.SpanElement();
    ripple.classes.add(_cssClasses.WSK_RIPPLE);
    rippleContainer.append(ripple);

    element.append(rippleContainer);
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialItem,
//   classAsString: 'MaterialItem',
//   cssClass: 'wsk-js-ripple-effect'
// });
