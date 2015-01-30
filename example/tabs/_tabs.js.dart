import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Tabs WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialTabs {

    final element;

    MaterialTabs(this.element);

  // Stores the HTML element.

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string}
class _MaterialTabsConstant {
  // None at the moment.
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialTabsCssClasses {
    final String TAB_CLASS = 'wsk-tabs__tab';
    final String PANEL_CLASS = 'wsk-tabs__panel';
    final String ACTIVE_CLASS = 'is-active';
    final String UPGRADED_CLASS = 'is-upgraded';

    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';
    final String WSK_RIPPLE_CONTAINER = 'wsk-tabs__ripple-container';
    final String WSK_RIPPLE = 'wsk-ripple';
    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';
}

/// Handle clicks to a tabs component
/// MaterialTabs.prototype.initTabs_ = function(e) {
void _initTabs(var e) {

  if (element.classes.contains(_cssClasses.WSK_JS_RIPPLE_EFFECT)) {
    element.classes.add(
      _cssClasses.WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS);
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
/// MaterialTabs.prototype.resetTabState_ = /*function*/ () {
void _resetTabState() {

  for (final k = 0; k < _tabs.length; k++) {
    _tabs[k].classes.remove(_cssClasses.ACTIVE_CLASS);
  }
}

/// Reset panel state, droping active classes
/// MaterialTabs.prototype.resetPanelState_ = /*function*/ () {
void _resetPanelState() {

  for (final j = 0; j < _panels.length; j++) {
    _panels[j].classes.remove(_cssClasses.ACTIVE_CLASS);
  }
}

/// MaterialTabs.prototype.init = /*function*/ () {
void init() {

  if (element) {
    _initTabs();
  }
}

class MaterialTab {

    final tab;
    final ctx;

    MaterialTab(this.tab,this.ctx);

  if (tab) {
    if (ctx._element.classes.contains(ctx._cssClasses.WSK_JS_RIPPLE_EFFECT)) {

      final rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(ctx._cssClasses.WSK_RIPPLE_CONTAINER);
      rippleContainer.classes.add(ctx._cssClasses.WSK_JS_RIPPLE_EFFECT);

      final ripple = new html.SpanElement();
      ripple.classes.add(ctx._cssClasses.WSK_RIPPLE);
      rippleContainer.append(ripple);
      tab.append(rippleContainer);
    }

		// -- .onClick.listen(<MouseEvent>);
    tab.addEventListener('click', /*function*/ (e) {
      e.preventDefault();

      final href = tab.href.split('#')[1];

      final panel = html.querySelector('#' + href);
      ctx._resetTabState();
      ctx._resetPanelState();
      tab.classes.add(ctx._cssClasses.ACTIVE_CLASS);
      panel.classes.add(ctx._cssClasses.ACTIVE_CLASS);
    });

  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialTabs,
//   classAsString: 'MaterialTabs',
//   cssClass: 'wsk-js-tabs'
// });
