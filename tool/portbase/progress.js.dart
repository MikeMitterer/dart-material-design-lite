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

/// Class constructor for Progress MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {HTMLElement} element The element that will be upgraded.

  final MaterialProgress = function MaterialProgress(element) {

    // Initialize instance.
    init();
  }
  window['MaterialProgress'] = MaterialProgress;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialProgressConstant {
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialProgressCssClasses {
      final String INDETERMINATE_CLASS = 'mdl-progress__indeterminate';
  }

/// Set the current progress of the progressbar.
/// 
/// param {number} p Percentage of the progress (0-100)
/// public
///   MaterialProgress.prototype.setProgress = function(p) {
void setProgress(final p) {
    if (element.classes.contains(_cssClasses.INDETERMINATE_CLASS)) {
      return;
    }

    _progressbar.style.width = p + '%';
  }
  MaterialProgress.prototype['setProgress'] =
      MaterialProgress.prototype.setProgress;

/// Set the current progress of the buffer.
/// 
/// param {number} p Percentage of the buffer (0-100)
/// public
///   MaterialProgress.prototype.setBuffer = function(p) {
void setBuffer(final p) {
    _bufferbar.style.width = p + '%';
    _auxbar.style.width = (100 - p) + '%';
  }
  MaterialProgress.prototype['setBuffer'] =
      MaterialProgress.prototype.setBuffer;

/// Initialize element.
///   MaterialProgress.prototype.init = /*function*/ () {
void init() {
    if (element != null) {

      final el = new html.DivElement();
      el.className = 'progressbar bar bar1';
      element.append(el);
      _progressbar = el;

      el = new html.DivElement();
      el.className = 'bufferbar bar bar2';
      element.append(el);
      _bufferbar = el;

      el = new html.DivElement();
      el.className = 'auxbar bar bar3';
      element.append(el);
      _auxbar = el;

      _progressbar.style.width = '0%';
      _bufferbar.style.width = '100%';
      _auxbar.style.width = '0%';

      element.classes.add('is-upgraded');
    }
  }

/// Downgrade the component
/// 
///   MaterialProgress.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {
    while (element.firstChild) {
      element.removeChild(element.firstChild);
    }
  }

/// Public alias for the downgrade method.
/// 
/// public
  MaterialProgress.prototype.mdlDowngrade =
      MaterialProgress.prototype.mdlDowngrade_;

  MaterialProgress.prototype['mdlDowngrade'] =
      MaterialProgress.prototype.mdlDowngrade;

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialProgress,
//     classAsString: 'MaterialProgress',
//     cssClass: 'mdl-js-progress',
//     widget: true
//   });
// })();
