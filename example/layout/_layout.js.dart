import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Layout WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/wsk-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialLayout {

    final element;

    MaterialLayout(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialLayoutConstant {
    final String MAX_WIDTH = '(max-width: 850px)';
}

/// Modes.
/// @enum {number}
class _MaterialLayoutMode {
    final int STANDARD = 0;
    final int SEAMED = 1;
    final int WATERFALL = 2;
    final int SCROLL = 3;
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialLayoutCssClasses {
    final String HEADER = 'wsk-layout__header';
    final String DRAWER = 'wsk-layout__drawer';
    final String CONTENT = 'wsk-layout__content';
    final String DRAWER_BTN = 'wsk-layout__drawer-button';

    final String JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';
    final String RIPPLE_CONTAINER = 'wsk-layout__tab-ripple-container';
    final String RIPPLE = 'wsk-ripple';
    final String RIPPLE_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    final String HEADER_SEAMED = 'wsk-layout__header--seamed';
    final String HEADER_WATERFALL = 'wsk-layout__header--waterfall';
    final String HEADER_SCROLL = 'wsk-layout__header--scroll';

    final String FIXED_HEADER = 'wsk-layout--fixed-header';
    final String OBFUSCATOR = 'wsk-layout__obfuscator';

    final String TAB_BAR = 'wsk-layout__tab-bar';
    final String TAB_CONTAINER = 'wsk-layout__tab-bar-container';
    final String TAB = 'wsk-layout__tab';
    final String TAB_BAR_BUTTON = 'wsk-layout__tab-bar-button';
    final String TAB_BAR_LEFT_BUTTON = 'wsk-layout__tab-bar-left-button';
    final String TAB_BAR_RIGHT_BUTTON = 'wsk-layout__tab-bar-right-button';
    final String PANEL = 'wsk-layout__tab-panel';

    final String SHADOW_CLASS = 'is-casting-shadow';
    final String COMPACT_CLASS = 'is-compact';
    final String SMALL_SCREEN_CLASS = 'is-small-screen';
    final String DRAWER_OPEN_CLASS = 'is-visible';
    final String ACTIVE_CLASS = 'is-active';
    final String UPGRADED_CLASS = 'is-upgraded';
}

/// Handles scrolling on the content.
/// MaterialLayout.prototype.contentScrollHandler_ = /*function*/ () {
void _contentScrollHandler() {

  if (_content.scrollTop > 0) {
    _header.classes.add(_cssClasses.SHADOW_CLASS);
    _header.classes.add(_cssClasses.COMPACT_CLASS);

  } else {
    _header.classes.remove(_cssClasses.SHADOW_CLASS);
    _header.classes.remove(_cssClasses.COMPACT_CLASS);
  }
}

/// Handles changes in screen size.
/// MaterialLayout.prototype.screenSizeHandler_ = /*function*/ () {
void _screenSizeHandler() {

  if (_screenSizeMediaQuery.matches) {
    element.classes.add(_cssClasses.SMALL_SCREEN_CLASS);
  }
  else {
    element.classes.remove(_cssClasses.SMALL_SCREEN_CLASS);
    // Collapse drawer (if any) when moving to a large screen size.
    if (_drawer) {
      _drawer.classes.remove(_cssClasses.DRAWER_OPEN_CLASS);
    }
  }
}

/// Handles toggling of the drawer.
/// @param {Element} drawer The drawer container element.
/// MaterialLayout.prototype.drawerToggleHandler_ = /*function*/ () {
void _drawerToggleHandler() {

  _drawer.classes.toggle(_cssClasses.DRAWER_OPEN_CLASS);
}

/// Reset tab state, dropping active classes
/// MaterialLayout.prototype.resetTabState_ = function(tabBar) {
void _resetTabState(final tabBar) {

  for (final k = 0; k < tabBar.length; k++) {
    tabBar[k].classes.remove(_cssClasses.ACTIVE_CLASS);
  }
}

/// Reset panel state, droping active classes
/// MaterialLayout.prototype.resetPanelState_ = function(panels) {
void _resetPanelState(final panels) {

  for (final j = 0; j < panels.length; j++) {
    panels[j].classes.remove(_cssClasses.ACTIVE_CLASS);
  }
}

/// Initialize element.
/// MaterialLayout.prototype.init = /*function*/ () {
void init() {

  if (element != null) {

    final container = new html.DivElement();
    container.classes.add('wsk-layout__container');
    element.parent.insertBefore(container, element);
    element.parent.removeChild(element);
    container.append(element);

    _header = element.querySelector('.' + _cssClasses.HEADER);
    _drawer = element.querySelector('.' + _cssClasses.DRAWER);
    _tabBar = element.querySelector('.' + _cssClasses.TAB_BAR);
    _content = element.querySelector('.' + _cssClasses.CONTENT);

    final mode = _Mode.STANDARD;

    // Keep an eye on screen size, and add/remove auxiliary class for styling
    // of small screens.
    _screenSizeMediaQuery = window.matchMedia(_constant.MAX_WIDTH);
    _screenSizeMediaQuery.addListener(_screenSizeHandler);
    _screenSizeHandler();

    if (_header) {
      if (_header.classes.contains(_cssClasses.HEADER_SEAMED)) {
        mode = _Mode.SEAMED;
      } else if (_header.classes.contains(
          _cssClasses.HEADER_WATERFALL)) {
        mode = _Mode.WATERFALL;
      } else if (element.classes.contains(
          _cssClasses.HEADER_SCROLL)) {
        mode = _Mode.SCROLL;
      }

      if (mode == _Mode.STANDARD) {
        _header.classes.add(_cssClasses.SHADOW_CLASS);
        if (_tabBar) {
          _tabBar.classes.add(_cssClasses.SHADOW_CLASS);
        }
      } else if (mode == _Mode.SEAMED || mode == _Mode.SCROLL) {
        _header.classes.remove(_cssClasses.SHADOW_CLASS);
        if (_tabBar) {
          _tabBar.classes.remove(_cssClasses.SHADOW_CLASS);
        }
      } else if (mode == _Mode.WATERFALL) {
        // Add and remove shadows depending on scroll position.
        // Also add/remove auxiliary class for styling of the compact version of
        // the header.

	// -- .onScroll.listen(<Event>);
        _content.addEventListener('scroll',
            _contentScrollHandler);
        _contentScrollHandler();
      }
    }

    // Add drawer toggling button to our layout, if we have an openable drawer.
    if (_drawer) {

      final drawerButton = new html.DivElement();
      drawerButton.classes.add(_cssClasses.DRAWER_BTN);

	// -- .onClick.listen(<MouseEvent>);
      drawerButton.addEventListener('click',
          _drawerToggleHandler);

      // If we have a fixed header, add the button to the header rather than
      // the layout.
      if (element.classes.contains(_cssClasses.FIXED_HEADER)) {
        _header.insertBefore(drawerButton, _header.firstChild);

      } else {
        element.insertBefore(drawerButton, _content);
      }

      final obfuscator = new html.DivElement();
      obfuscator.classes.add(_cssClasses.OBFUSCATOR);
      element.append(obfuscator);

	// -- .onClick.listen(<MouseEvent>);
      obfuscator.addEventListener('click',
          _drawerToggleHandler);
    }

    // Initialize tabs, if any.
    if (_tabBar) {

      final tabContainer = new html.DivElement();
      tabContainer.classes.add(_cssClasses.TAB_CONTAINER);
      element.insertBefore(tabContainer, _tabBar);
      element.removeChild(_tabBar);

      final leftButton = new html.DivElement();
      leftButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
      leftButton.classes.add(_cssClasses.TAB_BAR_LEFT_BUTTON);

	// -- .onClick.listen(<MouseEvent>);
      leftButton.addEventListener('click', /*function*/ () {
        _tabBar.scrollLeft -= 100;
      });

      final rightButton = new html.DivElement();
      rightButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
      rightButton.classes.add(_cssClasses.TAB_BAR_RIGHT_BUTTON);

	// -- .onClick.listen(<MouseEvent>);
      rightButton.addEventListener('click', /*function*/ () {
        _tabBar.scrollLeft += 100;
      });

      tabContainer.append(leftButton);
      tabContainer.append(_tabBar);
      tabContainer.append(rightButton);

      // Add and remove buttons depending on scroll position.

      final tabScrollHandler = /*function*/ () {
        if (_tabBar.scrollLeft > 0) {
          leftButton.classes.add(_cssClasses.ACTIVE_CLASS);

        } else {
          leftButton.classes.remove(_cssClasses.ACTIVE_CLASS);
        }

        if (_tabBar.scrollLeft <
            _tabBar.scrollWidth - _tabBar.offsetWidth) {
          rightButton.classes.add(_cssClasses.ACTIVE_CLASS);

        } else {
          rightButton.classes.remove(_cssClasses.ACTIVE_CLASS);
        }
      };

	// -- .onScroll.listen(<Event>);
      _tabBar.addEventListener('scroll', tabScrollHandler);
      tabScrollHandler();

      if (_tabBar.classes.contains(_cssClasses.JS_RIPPLE_EFFECT)) {
        _tabBar.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);
      }

      // Select element tabs, document panels

      final tabs = _tabBar.querySelectorAll('.' + _cssClasses.TAB);

      final panels = _content.querySelectorAll('.' + _cssClasses.PANEL);

      // Create new tabs for each tab element

      for (final i = 0; i < tabs.length; i++) {
        new MaterialLayoutTab(tabs[i], tabs, panels, this);
      }
    }

    element.classes.add(_cssClasses.UPGRADED_CLASS);
  }
}

class MaterialLayoutTab {

    final tab;
    final tabs;
    final panels;
    final layout;

    MaterialLayoutTab(this.tab,this.tabs,this.panels,this.layout);

  if (tab) {
    if (layout._tabBar.classes.contains(
        layout._cssClasses.JS_RIPPLE_EFFECT)) {

      final rippleContainer = new html.SpanElement();
      rippleContainer.classes.add(layout._cssClasses.RIPPLE_CONTAINER);
      rippleContainer.classes.add(layout._cssClasses.JS_RIPPLE_EFFECT);

      final ripple = new html.SpanElement();
      ripple.classes.add(layout._cssClasses.RIPPLE);
      rippleContainer.append(ripple);
      tab.append(rippleContainer);
    }

	// -- .onClick.listen(<MouseEvent>);
    tab.addEventListener('click', /*function*/ (e) {
      e.preventDefault();

      final href = tab.href.split('#')[1];

      final panel = layout._content.querySelector('#' + href);
      layout._resetTabState(tabs);
      layout._resetPanelState(panels);
      tab.classes.add(layout._cssClasses.ACTIVE_CLASS);
      panel.classes.add(layout._cssClasses.ACTIVE_CLASS);
    });

  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialLayout,
//   classAsString: 'MaterialLayout',
//   cssClass: 'wsk-js-layout'
// });
