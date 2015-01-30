import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Spinner WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialSpinner {

    final element;

    MaterialSpinner(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialSpinnerConstant {
    final int WSK_SPINNER_LAYER_COUNT = 4;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialSpinnerCssClasses {
    final String WSK_SPINNER_LAYER = 'wsk-spinner__layer';
    final String WSK_SPINNER_CIRCLE_CLIPPER = 'wsk-spinner__circle-clipper';
    final String WSK_SPINNER_CIRCLE = 'wsk-spinner__circle';
    final String WSK_SPINNER_GAP_PATCH = 'wsk-spinner__gap-patch';
    final String WSK_SPINNER_LEFT = 'wsk-spinner__left';
    final String WSK_SPINNER_RIGHT = 'wsk-spinner__right';
}

* Auxiliary method to create a spinner layer.
*/
/// MaterialSpinner.prototype.createLayer = function(index) {
void createLayer(final index) {

  final layer = document.createElement('div');
  layer.classes.add(_cssClasses.WSK_SPINNER_LAYER);
  layer.classes.add(_cssClasses.WSK_SPINNER_LAYER + '-' + index);

  final leftClipper = document.createElement('div');
  leftClipper.classes.add(_cssClasses.WSK_SPINNER_CIRCLE_CLIPPER);
  leftClipper.classes.add(_cssClasses.WSK_SPINNER_LEFT);

  final gapPatch = document.createElement('div');
  gapPatch.classes.add(_cssClasses.WSK_SPINNER_GAP_PATCH);

  final rightClipper = document.createElement('div');
  rightClipper.classes.add(_cssClasses.WSK_SPINNER_CIRCLE_CLIPPER);
  rightClipper.classes.add(_cssClasses.WSK_SPINNER_RIGHT);

  final circleOwners = [leftClipper, gapPatch, rightClipper];

  for (final i = 0; i < circleOwners.length; i++) {

    final circle = document.createElement('div');
    circle.classes.add(_cssClasses.WSK_SPINNER_CIRCLE);
    circleOwners[i].append(circle);
  }

  layer.append(leftClipper);
  layer.append(gapPatch);
  layer.append(rightClipper);

  element.append(layer);
}

* Stops the spinner animation.
*/
/// MaterialSpinner.prototype.stop = /*function*/ () {
void stop() {

  element.classlist.remove('is-active');
}

* Starts the spinner animation.
*/
/// MaterialSpinner.prototype.stop = /*function*/ () {
void stop() {

  element.classlist.add('is-active');
}

/// Initialize element.
/// MaterialSpinner.prototype.init = /*function*/ () {
void init() {

  if (element) {

    for (final i = 1; i <= _constant.WSK_SPINNER_LAYER_COUNT; i++) {
      createLayer(i);
    }

    element.classes.add('is-upgraded');
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialSpinner,
//   classAsString: 'MaterialSpinner',
//   cssClass: 'wsk-js-spinner'
// });
