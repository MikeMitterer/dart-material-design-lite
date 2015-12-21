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

/// Class constructor for Layout MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {HTMLElement} element The element that will be upgraded.

  final MaterialLayout = function MaterialLayout(element) {

    // Initialize instance.
    init();
  }
  window['MaterialLayout'] = MaterialLayout;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialLayoutConstant {
      final String MAX_WIDTH = '(max-width: 1024px)';
      final int TAB_SCROLL_PIXELS = 100;

      final String MENU_ICON = '&#xE5D2;';
      final String CHEVRON_LEFT = 'chevron_left';
      final String CHEVRON_RIGHT = 'chevron_right';
  }

/// Keycodes, for code readability.
/// 
/// enum {number}
  MaterialLayout.prototype.Keycodes_ = {
      final int ENTER = 13;
      final int ESCAPE = 27;
      final int SPACE = 32;
  }

/// Modes.
/// 
/// enum {number}
class _  MaterialLayoutMode {
      final int STANDARD = 0;
      final int SEAMED = 1;
      final int WATERFALL = 2;
      final int SCROLL = 3;
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialLayoutCssClasses {
      final String CONTAINER = 'mdl-layout__container';
      final String HEADER = 'mdl-layout__header';
      final String DRAWER = 'mdl-layout__drawer';
      final String CONTENT = 'mdl-layout__content';
      final String DRAWER_BTN = 'mdl-layout__drawer-button';

      final String ICON = 'material-icons';

      final String JS_RIPPLE_EFFECT = 'mdl-js-ripple-effect';
      final String RIPPLE_CONTAINER = 'mdl-layout__tab-ripple-container';
      final String RIPPLE = 'mdl-ripple';
      final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';

      final String HEADER_SEAMED = 'mdl-layout__header--seamed';
      final String HEADER_WATERFALL = 'mdl-layout__header--waterfall';
      final String HEADER_SCROLL = 'mdl-layout__header--scroll';

      final String FIXED_HEADER = 'mdl-layout--fixed-header';
      final String OBFUSCATOR = 'mdl-layout__obfuscator';

      final String TAB_BAR = 'mdl-layout__tab-bar';
      final String TAB_CONTAINER = 'mdl-layout__tab-bar-container';
      final String TAB = 'mdl-layout__tab';
      final String TAB_BAR_BUTTON = 'mdl-layout__tab-bar-button';
      final String TAB_BAR_LEFT_BUTTON = 'mdl-layout__tab-bar-left-button';
      final String TAB_BAR_RIGHT_BUTTON = 'mdl-layout__tab-bar-right-button';
      final String PANEL = 'mdl-layout__tab-panel';

      final String HAS_DRAWER = 'has-drawer';
      final String HAS_TABS = 'has-tabs';
      final String HAS_SCROLLING_HEADER = 'has-scrolling-header';
      final String CASTING_SHADOW = 'is-casting-shadow';
      final String IS_COMPACT = 'is-compact';
      final String IS_SMALL_SCREEN = 'is-small-screen';
      final String IS_DRAWER_OPEN = 'is-visible';
      final String IS_ACTIVE = 'is-active';
      final String IS_UPGRADED = 'is-upgraded';
      final String IS_ANIMATING = 'is-animating';

      final String ON_LARGE_SCREEN = 'mdl-layout--large-screen-only';
      final String ON_SMALL_SCREEN = 'mdl-layout--small-screen-only';

  }

/// Handles scrolling on the content.
/// 
///   MaterialLayout.prototype.contentScrollHandler_ = /*function*/ () {
void _contentScrollHandler() {
    if (_header.classes.contains(_cssClasses.IS_ANIMATING)) {
      return;
    }

    if (_content.scrollTop > 0 &&
        !_header.classes.contains(_cssClasses.IS_COMPACT)) {
      _header.classes.add(_cssClasses.CASTING_SHADOW);
      _header.classes.add(_cssClasses.IS_COMPACT);
      _header.classes.add(_cssClasses.IS_ANIMATING);
    } else if (_content.scrollTop <= 0 &&
        _header.classes.contains(_cssClasses.IS_COMPACT)) {
      _header.classes.remove(_cssClasses.CASTING_SHADOW);
      _header.classes.remove(_cssClasses.IS_COMPACT);
      _header.classes.add(_cssClasses.IS_ANIMATING);
    }
  }

/// Handles a keyboard event on the drawer.
/// 
/// param {Event} evt The event that fired.
///   MaterialLayout.prototype.keyboardEventHandler_ = function(evt) {
void _keyboardEventHandler(final evt) {
    if (evt.keyCode == _Keycodes.ESCAPE) {
      toggleDrawer();
    }
  }

/// Handles changes in screen size.
/// 
///   MaterialLayout.prototype.screenSizeHandler_ = /*function*/ () {
void _screenSizeHandler() {
    if (_screenSizeMediaQuery.matches) {
      element.classes.add(_cssClasses.IS_SMALL_SCREEN);

    } else {
      element.classes.remove(_cssClasses.IS_SMALL_SCREEN);
      // Collapse drawer (if any) when moving to a large screen size.
      if (_drawer) {
        _drawer.classes.remove(_cssClasses.IS_DRAWER_OPEN);
        _obfuscator.classes.remove(_cssClasses.IS_DRAWER_OPEN);
      }
    }
  }

/// Handles events of of drawer button.
/// 
/// param {Event} evt The event that fired.
///   MaterialLayout.prototype.drawerToggleHandler_ = function(evt) {
void _drawerToggleHandler(final evt) {
    if (evt && (evt.type == 'keydown')) {
      if (evt.keyCode == _Keycodes.SPACE || evt.keyCode == _Keycodes.ENTER) {
        // prevent scrolling in drawer nav
        evt.preventDefault();

      } else {
        // prevent other keys
        return;
      }
    }

    toggleDrawer();
  }

/// Handles (un)setting the `is-animating` class
/// 
///   MaterialLayout.prototype.headerTransitionEndHandler_ = /*function*/ () {
void _headerTransitionEndHandler() {
    _header.classes.remove(_cssClasses.IS_ANIMATING);
  }

/// Handles expanding the header on click
/// 
///   MaterialLayout.prototype.headerClickHandler_ = /*function*/ () {
void _headerClickHandler() {
    if (_header.classes.contains(_cssClasses.IS_COMPACT)) {
      _header.classes.remove(_cssClasses.IS_COMPACT);
      _header.classes.add(_cssClasses.IS_ANIMATING);
    }
  }

/// Reset tab state, dropping active classes
/// 
///   MaterialLayout.prototype.resetTabState_ = function(tabBar) {
void _resetTabState(final tabBar) {

    for (final k = 0; k < tabBar.length; k++) {
      tabBar[k].classes.remove(_cssClasses.IS_ACTIVE);
    }
  }

/// Reset panel state, droping active classes
/// 
///   MaterialLayout.prototype.resetPanelState_ = function(panels) {
void _resetPanelState(final panels) {

    for (final j = 0; j < panels.length; j++) {
      panels[j].classes.remove(_cssClasses.IS_ACTIVE);
    }
  }

/// Toggle drawer state
/// 
/// public
///   MaterialLayout.prototype.toggleDrawer = /*function*/ () {
void toggleDrawer() {

    final drawerButton = element.querySelector('.' + _cssClasses.DRAWER_BTN);

    final firstLink = html.querySelector('.' + _cssClasses.DRAWER + ' a');
    _drawer.classes.toggle(_cssClasses.IS_DRAWER_OPEN);
    _obfuscator.classes.toggle(_cssClasses.IS_DRAWER_OPEN);

    // focus first link if drawer will be opened otherwise focus the drawer button
    if (_drawer.classes.contains(_cssClasses.IS_DRAWER_OPEN)) {
      _drawer.setAttribute('aria-hidden', 'false');
      drawerButton.setAttribute('aria-expanded', 'true');
      if (firstLink) {
        firstLink.focus();
      }

    } else {
      _drawer.setAttribute('aria-hidden', 'true');
      drawerButton.setAttribute('aria-expanded', 'false');
      drawerButton.focus();
    }
  }
  MaterialLayout.prototype['toggleDrawer'] =
      MaterialLayout.prototype.toggleDrawer;

/// Initialize element.
///   MaterialLayout.prototype.init = /*function*/ () {
void init() {
    if (element != null) {

      final container = new html.DivElement();
      container.classes.add(_cssClasses.CONTAINER);
      element.parent.insertBefore(container, element);
      element.parent.removeChild(element);
      container.append(element);

      final directChildren = element.childNodes;

      final numChildren = directChildren.length;

      for (final c = 0; c < numChildren; c++) {

        final child = directChildren[c];
        if (child.classList &&
            child.classes.contains(_cssClasses.HEADER)) {
          _header = child;
        }

        if (child.classList &&
            child.classes.contains(_cssClasses.DRAWER)) {
          _drawer = child;
        }

        if (child.classList &&
            child.classes.contains(_cssClasses.CONTENT)) {
          _content = child;
        }
      }

      if (_header) {
        _tabBar = _header.querySelector('.' + _cssClasses.TAB_BAR);
      }

      final mode = _Mode.STANDARD;

      if (_header) {
        if (_header.classes.contains(_cssClasses.HEADER_SEAMED)) {
          mode = _Mode.SEAMED;
        } else if (_header.classes.contains(
            _cssClasses.HEADER_WATERFALL)) {
          mode = _Mode.WATERFALL;
          _header.addEventListener('transitionend',
            _headerTransitionEndHandler);

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
          _header.onClick.listen(
            _headerClickHandler);
        } else if (_header.classes.contains(
            _cssClasses.HEADER_SCROLL)) {
          mode = _Mode.SCROLL;
          container.classes.add(_cssClasses.HAS_SCROLLING_HEADER);
        }

        if (mode == _Mode.STANDARD) {
          _header.classes.add(_cssClasses.CASTING_SHADOW);
          if (_tabBar) {
            _tabBar.classes.add(_cssClasses.CASTING_SHADOW);
          }
        } else if (mode == _Mode.SEAMED || mode == _Mode.SCROLL) {
          _header.classes.remove(_cssClasses.CASTING_SHADOW);
          if (_tabBar) {
            _tabBar.classes.remove(_cssClasses.CASTING_SHADOW);
          }
        } else if (mode == _Mode.WATERFALL) {
          // Add and remove shadows depending on scroll position.
          // Also add/remove auxiliary class for styling of the compact version of
          // the header.

	// .addEventListener('scroll', -- .onScroll.listen(<Event>);
          _content.onScroll.listen(
              _contentScrollHandler);
          _contentScrollHandler();
        }
      }

      // Add drawer toggling button to our layout, if we have an openable drawer.
      if (_drawer) {

        final drawerButton = element.querySelector('.' +
          _cssClasses.DRAWER_BTN);
        if (!drawerButton) {

          drawerButton = new html.DivElement();
          drawerButton.setAttribute('aria-expanded', 'false');
          drawerButton.setAttribute('role', 'button');
          drawerButton.setAttribute('tabindex', '0');
          drawerButton.classes.add(_cssClasses.DRAWER_BTN);

          final drawerButtonIcon = document.createElement('i');
          drawerButtonIcon.classes.add(_cssClasses.ICON);
          drawerButtonIcon.innerHTML = _constant.MENU_ICON;
          drawerButton.append(drawerButtonIcon);
        }

        if (_drawer.classes.contains(_cssClasses.ON_LARGE_SCREEN)) {
          //If drawer has ON_LARGE_SCREEN class then add it to the drawer toggle button as well.
          drawerButton.classes.add(_cssClasses.ON_LARGE_SCREEN);
        } else if (_drawer.classes.contains(_cssClasses.ON_SMALL_SCREEN)) {
          //If drawer has ON_SMALL_SCREEN class then add it to the drawer toggle button as well.
          drawerButton.classes.add(_cssClasses.ON_SMALL_SCREEN);
        }

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
        drawerButton.onClick.listen(
            _drawerToggleHandler);

        drawerButton.addEventListener('keydown',
            _drawerToggleHandler);

        // Add a class if the layout has a drawer, for altering the left padding.
        // Adds the HAS_DRAWER to the elements since _header may or may
        // not be present.
        element.classes.add(_cssClasses.HAS_DRAWER);

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

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
        obfuscator.onClick.listen(
            _drawerToggleHandler);
        _obfuscator = obfuscator;

        _drawer.addEventListener('keydown', _keyboardEventHandler);
        _drawer.setAttribute('aria-hidden', 'true');
      }

      // Keep an eye on screen size, and add/remove auxiliary class for styling
      // of small screens.
      _screenSizeMediaQuery = window.matchMedia(
      _screenSizeMediaQuery.addListener(_screenSizeHandler);
      _screenSizeHandler();

      // Initialize tabs, if any.
      if (_header && _tabBar) {
        element.classes.add(_cssClasses.HAS_TABS);

        final tabContainer = new html.DivElement();
        tabContainer.classes.add(_cssClasses.TAB_CONTAINER);
        _header.insertBefore(tabContainer, _tabBar);
        _header.removeChild(_tabBar);

        final leftButton = new html.DivElement();
        leftButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
        leftButton.classes.add(_cssClasses.TAB_BAR_LEFT_BUTTON);

        final leftButtonIcon = document.createElement('i');
        leftButtonIcon.classes.add(_cssClasses.ICON);
        leftButtonIcon.textContent = _constant.CHEVRON_LEFT;
        leftButton.append(leftButtonIcon);

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
        leftButton.onClick.listen( /*function*/ () {
          _tabBar.scrollLeft -= _constant.TAB_SCROLL_PIXELS;
        });

        final rightButton = new html.DivElement();
        rightButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
        rightButton.classes.add(_cssClasses.TAB_BAR_RIGHT_BUTTON);

        final rightButtonIcon = document.createElement('i');
        rightButtonIcon.classes.add(_cssClasses.ICON);
        rightButtonIcon.textContent = _constant.CHEVRON_RIGHT;
        rightButton.append(rightButtonIcon);

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
        rightButton.onClick.listen( /*function*/ () {
          _tabBar.scrollLeft += _constant.TAB_SCROLL_PIXELS;
        });

        tabContainer.append(leftButton);
        tabContainer.append(_tabBar);
        tabContainer.append(rightButton);

        // Add and remove buttons depending on scroll position.

        final tabScrollHandler = /*function*/ () {
          if (_tabBar.scrollLeft > 0) {
            leftButton.classes.add(_cssClasses.IS_ACTIVE);

          } else {
            leftButton.classes.remove(_cssClasses.IS_ACTIVE);
          }

          if (_tabBar.scrollLeft <
              _tabBar.scrollWidth - _tabBar.offsetWidth) {
            rightButton.classes.add(_cssClasses.IS_ACTIVE);

          } else {
            rightButton.classes.remove(_cssClasses.IS_ACTIVE);
          }
        };

	// .addEventListener('scroll', -- .onScroll.listen(<Event>);
        _tabBar.onScroll.listen( tabScrollHandler);
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

      element.classes.add(_cssClasses.IS_UPGRADED);
    }
  }

/// Constructor for an individual tab.
/// 
/// constructor
/// param {HTMLElement} tab The HTML element for the tab.
/// param {!Array<HTMLElement>} tabs Array with HTML elements for all tabs.
/// param {!Array<HTMLElement>} panels Array with HTML elements for all panels.
/// param {MaterialLayout} layout The MaterialLayout object that owns the tab.
  function MaterialLayoutTab(tab, tabs, panels, layout) {

/// Auxiliary method to programmatically select a tab in the UI.
    function selectTab() {

      final href = tab.href.split('#')[1];

      final panel = layout._content.querySelector('#' + href);
      layout._resetTabState(tabs);
      layout._resetPanelState(panels);
      tab.classes.add(layout._cssClasses.IS_ACTIVE);
      panel.classes.add(layout._cssClasses.IS_ACTIVE);
    }

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

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
    tab.onClick.listen( /*function*/ (e) {
      if (tab.getAttribute('href').charAt(0) == '#') {
        e.preventDefault();
        selectTab();
      }
    });

    tab.show = selectTab;

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
    tab.onClick.listen( /*function*/ (e) {
      e.preventDefault();

      final href = tab.href.split('#')[1];

      final panel = layout._content.querySelector('#' + href);
      layout._resetTabState(tabs);
      layout._resetPanelState(panels);
      tab.classes.add(layout._cssClasses.IS_ACTIVE);
      panel.classes.add(layout._cssClasses.IS_ACTIVE);
    });
  }
  window['MaterialLayoutTab'] = MaterialLayoutTab;

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialLayout,
//     classAsString: 'MaterialLayout',
//     cssClass: 'mdl-js-layout'
//   });
// })();
