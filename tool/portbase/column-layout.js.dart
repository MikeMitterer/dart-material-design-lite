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

/// Class constructor for Column Layout MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// param {HTMLElement} element The element that will be upgraded.
class MaterialColumnLayout {

    final element;

    MaterialColumnLayout(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// enum {string | number}
class _MaterialColumnLayoutConstant {
    final int INVISIBLE_WRAPPING_ELEMENT_COUNT = 3;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// enum {string}
class _MaterialColumnLayoutCssClasses {
/// Class names should use camelCase and be prefixed with the word "material"
/// to minimize conflict with 3rd party systems.

  // TODO: Upgrade classnames in HTML / CSS / JS to use material prefix to
  // reduce conflict and convert to camelCase for consistency.
    final String INVISIBLE_WRAPPING_ELEMENT = 'mdl-column-layout__wrap-hack';
}

/// Initialize element.
/// MaterialColumnLayout.prototype.init = /*function*/ () {
void init() {

  if (element != null) {
    // Add some hidden elements to make sure everything aligns correctly. See
    // CSS file for details.

    for (final j = 0; j < _constant.INVISIBLE_WRAPPING_ELEMENT_COUNT ; j++) {

      final hiddenHackDiv = new html.DivElement();
      hiddenHackDiv.classes.add(_cssClasses.INVISIBLE_WRAPPING_ELEMENT);
      element.append(hiddenHackDiv);
    }
  }
}

//The component registers itself. It can assume componentHandler is available
//in the global scope.
componentHandler.register({
  constructor: MaterialColumnLayout,
  classAsString: 'MaterialColumnLayout',
  cssClass: 'mdl-column-layout'
});
