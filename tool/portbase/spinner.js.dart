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

/// Class constructor for Spinner MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// param {HTMLElement} element The element that will be upgraded.
/// constructor

  final MaterialSpinner = function MaterialSpinner(element) {

    // Initialize instance.
    init();
  }
  window['MaterialSpinner'] = MaterialSpinner;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialSpinnerConstant {
      final int MDL_SPINNER_LAYER_COUNT = 4;
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialSpinnerCssClasses {
      final String MDL_SPINNER_LAYER = 'mdl-spinner__layer';
      final String MDL_SPINNER_CIRCLE_CLIPPER = 'mdl-spinner__circle-clipper';
      final String MDL_SPINNER_CIRCLE = 'mdl-spinner__circle';
      final String MDL_SPINNER_GAP_PATCH = 'mdl-spinner__gap-patch';
      final String MDL_SPINNER_LEFT = 'mdl-spinner__left';
      final String MDL_SPINNER_RIGHT = 'mdl-spinner__right';
  }

/// Auxiliary method to create a spinner layer.
/// 
/// param {number} index Index of the layer to be created.
/// public
///   MaterialSpinner.prototype.createLayer = function(index) {
void createLayer(final index) {

    final layer = new html.DivElement();
    layer.classes.add(_cssClasses.MDL_SPINNER_LAYER);
    layer.classes.add(_cssClasses.MDL_SPINNER_LAYER + '-' + index);

    final leftClipper = new html.DivElement();
    leftClipper.classes.add(_cssClasses.MDL_SPINNER_CIRCLE_CLIPPER);
    leftClipper.classes.add(_cssClasses.MDL_SPINNER_LEFT);

    final gapPatch = new html.DivElement();
    gapPatch.classes.add(_cssClasses.MDL_SPINNER_GAP_PATCH);

    final rightClipper = new html.DivElement();
    rightClipper.classes.add(_cssClasses.MDL_SPINNER_CIRCLE_CLIPPER);
    rightClipper.classes.add(_cssClasses.MDL_SPINNER_RIGHT);

    final circleOwners = [leftClipper, gapPatch, rightClipper];

    for (final i = 0; i < circleOwners.length; i++) {

      final circle = new html.DivElement();
      circle.classes.add(_cssClasses.MDL_SPINNER_CIRCLE);
      circleOwners[i].append(circle);
    }

    layer.append(leftClipper);
    layer.append(gapPatch);
    layer.append(rightClipper);

    element.append(layer);
  }
  MaterialSpinner.prototype['createLayer'] =
      MaterialSpinner.prototype.createLayer;

/// Stops the spinner animation.
/// Public method for users who need to stop the spinner for any reason.
/// 
/// public
///   MaterialSpinner.prototype.stop = /*function*/ () {
void stop() {
    element.classes.remove('is-active');
  }
  MaterialSpinner.prototype['stop'] = MaterialSpinner.prototype.stop;

/// Starts the spinner animation.
/// Public method for users who need to manually start the spinner for any reason
/// instead of just adding the 'is-active' class to their markup).
/// 
/// public
///   MaterialSpinner.prototype.start = /*function*/ () {
void start() {
    element.classes.add('is-active');
  }
  MaterialSpinner.prototype['start'] = MaterialSpinner.prototype.start;

/// Initialize element.
///   MaterialSpinner.prototype.init = /*function*/ () {
void init() {
    if (element != null) {

      for (final i = 1; i <= _constant.MDL_SPINNER_LAYER_COUNT; i++) {
        createLayer(i);
      }

      element.classes.add('is-upgraded');
    }
  }

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialSpinner,
//     classAsString: 'MaterialSpinner',
//     cssClass: 'mdl-js-spinner',
//     widget: true
//   });
// })();
