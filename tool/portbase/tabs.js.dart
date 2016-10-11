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

/// Class constructor for Tabs MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {Element} element The element that will be upgraded.

  final MaterialTabs = function MaterialTabs(element) {
    // Stores the HTML element.

    // Initialize instance.
    init();
  }
  window['MaterialTabs'] = MaterialTabs;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string}
class _  MaterialTabsConstant {
    // None at the moment.
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialTabsCssClasses {
      final String TAB_CLASS = 'mdl-tabs__tab';
      final String PANEL_CLASS = 'mdl-tabs__panel';
      final String ACTIVE_CLASS = 'is-active';
      final String UPGRADED_CLASS = 'is-upgraded';

      final String MDL_JS_RIPPLE_EFFECT = 'mdl-js-ripple-effect';
      final String MDL_RIPPLE_CONTAINER = 'mdl-tabs__ripple-container';
      final String MDL_RIPPLE = 'mdl-ripple';
      final String MDL_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
  }

/// Handle clicks to a tabs component
/// 
///   MaterialTabs.prototype.initTabs_ = /*function*/ () {
void _initTabs() {
    if (element.classes.contains(_cssClasses.MDL_JS_RIPPLE_EFFECT)) {
      element.classes.add(
        _cssClasses.MDL_JS_RIPPLE_EFFECT_IGNORE_EVENTS);
    }

    // Select element tabs, document panels
    _tabs = element.querySelectorAll('.' + _cssClasses.TAB_CLASS);
    _panels =
        element.querySelectorAll('.' + _cssClasses.PANEL_CLASS);

    // Create new tabs for each tab element

    for (final i = 0; i < _tabs.length; i++) {
      new MaterialTab(_tabs[i], this);
    }

    element.classes.add(_cssClasses.UPGRADED_CLASS);
  }

/// Reset tab state, dropping active classes
/// 
///   MaterialTabs.prototype.resetTabState_ = /*function*/ () {
void _resetTabState() {

    for (final k = 0; k < _tabs.length; k++) {
      _tabs[k].classes.remove(_cssClasses.ACTIVE_CLASS);
    }
  }

/// Reset panel state, droping active classes
/// 
///   MaterialTabs.prototype.resetPanelState_ = /*function*/ () {
void _resetPanelState() {

    for (final j = 0; j < _panels.length; j++) {
      _panels[j].classes.remove(_cssClasses.ACTIVE_CLASS);
    }
  }

/// Initialize element.
///   MaterialTabs.prototype.init = /*function*/ () {
void init() {
    if (element != null) {
      _initTabs();
    }
  }

/// Constructor for an individual tab.
/// 
/// constructor
/// param {Element} tab The HTML element for the tab.
/// param {MaterialTabs} ctx The MaterialTabs object that owns the tab.
  function MaterialTab(tab, ctx) {
    if (tab) {
      if (ctx._element.classes.contains(ctx._cssClasses.MDL_JS_RIPPLE_EFFECT)) {

        final rippleContainer = new html.SpanElement();
        rippleContainer.classes.add(ctx._cssClasses.MDL_RIPPLE_CONTAINER);
        rippleContainer.classes.add(ctx._cssClasses.MDL_JS_RIPPLE_EFFECT);

        final ripple = new html.SpanElement();
        ripple.classes.add(ctx._cssClasses.MDL_RIPPLE);
        rippleContainer.append(ripple);
        tab.append(rippleContainer);
      }

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
      tab.onClick.listen( /*function*/ (e) {
        e.preventDefault();

        final href = tab.href.split('#')[1];

        final panel = ctx._element.querySelector('#' + href);
        ctx._resetTabState();
        ctx._resetPanelState();
        tab.classes.add(ctx._cssClasses.ACTIVE_CLASS);
        panel.classes.add(ctx._cssClasses.ACTIVE_CLASS);
      });

    }
  }

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialTabs,
//     classAsString: 'MaterialTabs',
//     cssClass: 'mdl-js-tabs'
//   });
// })();
