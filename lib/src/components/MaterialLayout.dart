/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdlcomponents;

/// Keycodes, for code readability.
///
/// enum {number}
class _MaterialLayoutKeycodes {
    static const int ENTER = 13;
    static const int ESCAPE = 27;
    static const int SPACE = 32;
}

/// Modes.
class _MaterialLayoutMode {

    final int STANDARD = 0;
    final int SEAMED = 1;
    final int WATERFALL = 2;
    final int SCROLL = 3;

    const _MaterialLayoutMode();
}

/// Controller-View for
///     <div class="demo-layout fixed-drawer-container">
///       <div class="mdl-layout mdl-layout mdl-layout--fixed-header">
///           <header class="mdl-layout__header">
///               <div class="mdl-layout__header-row">
///                   <!-- Title -->
///                   <span class="mdl-layout-title">Title</span>
///                   <!-- Add spacer, to align navigation to the right -->
///                   <div class="mdl-layout-spacer"></div>
///                   <!-- Navigation. We hide it in small screens. -->
///                   <nav class="mdl-navigation mdl-layout--large-screen-only">
///                       <a class="mdl-navigation__link" href="">Link</a>
///                   </nav>
///               </div>
///           </header>
///           <div class="mdl-layout__drawer">
///               <span class="mdl-layout-title">Title</span>
///               <nav class="mdl-navigation">
///                   <a class="mdl-navigation__link" href="">Link</a>
///               </nav>
///           </div>
///           <main class="mdl-layout__content">
///               <div class="page-content"></div>
///           </main>
///       </div>
///     </div>
///
class MaterialLayout extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialLayout');

    static const _MaterialLayoutConstant _constant = const _MaterialLayoutConstant();
    static const _MaterialLayoutCssClasses _cssClasses = const _MaterialLayoutCssClasses();
    static const _MaterialLayoutMode _mode = const _MaterialLayoutMode();

    dom.HtmlElement _header = null;
    dom.HtmlElement _drawer = null;
    dom.HtmlElement _tabBar = null;
    dom.HtmlElement _content = null;
    dom.HtmlElement _obfuscator = null;

    dom.MediaQueryList _screenSizeMediaQuery = null;

    /// All the Tabs - necessary for downgrading
    final List<MaterialLayoutTab> _tabs = new List<MaterialLayoutTab>();

    MaterialLayout.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialLayout widget(final dom.HtmlElement element) => mdlComponent(element,MaterialLayout) as MaterialLayout;

    dom.HtmlElement get header {
        //if(_header == null) { _header = element.querySelector('.' + _cssClasses.HEADER); }
        return _header;
    }

    dom.HtmlElement get drawer {
        //if(_drawer == null) { _drawer = element.querySelector('.' + _cssClasses.DRAWER); }
        return _drawer;
    }

    dom.HtmlElement get tabBar {
        //if(_tabBar == null) { _tabBar = element.querySelector('.' + _cssClasses.TAB_BAR); }
        return _tabBar;
    }

    dom.HtmlElement get content {
        //if(_content == null) { _content = element.querySelector('.' + _cssClasses.CONTENT); }
        return _content;
    }

    dom.HtmlElement get obfuscator {
        return _obfuscator;
    }

    void show() {

    }

    @override
    void downgrade() {
        super.downgrade();
        _tabs.forEach((final MaterialLayoutTab tab) => tab._downgrade());
    }

    /// Toggle drawer state
    void toggleDrawer() {
        final dom.HtmlElement drawerButton = element.querySelector(".${_cssClasses.DRAWER_BTN}");

        _drawer.classes.toggle(_cssClasses.IS_DRAWER_OPEN);
        _obfuscator.classes.toggle(_cssClasses.IS_DRAWER_OPEN);

        // Set accessibility properties.
        if (_drawer.classes.contains(_cssClasses.IS_DRAWER_OPEN)) {
            _drawer.setAttribute('aria-hidden', 'false');
            drawerButton.setAttribute('aria-expanded', 'true');

        } else {
            _drawer.setAttribute('aria-hidden', 'true');
            drawerButton.setAttribute('aria-expanded', 'false');
        }
    }

    //- private -----------------------------------------------------------------------------------

    // Keep an eye on screen size, and add/remove auxiliary class for styling
    // of small screens.
    // html.MediaQueryList get _screenSizeMediaQuery => html.window.matchMedia(_constant.MAX_WIDTH);

    void _init() {
        _logger.fine("MaterialLayout - init");

        if (element != null) {

            final dom.DivElement container = new dom.DivElement();
            container.classes.add(_cssClasses.CONTAINER);

            final focusedElement = element.querySelector(':focus');

            element.parent.insertBefore(container, element);
            element.remove(); // element.parent.removeChild (element);
            container.append(element);

            focusedElement?.focus();

            final List<dom.Node> directChildren = element.childNodes;

            directChildren.forEach((final child) {

                if(child is dom.Element) {

                    if (child.classes.contains(_cssClasses.HEADER)) {
                        _header = child;
                    }

                    if (child.classes.contains(_cssClasses.DRAWER)) {
                        _drawer = child;
                    }

                    if (child.classes.contains(_cssClasses.CONTENT)) {
                        _content = child;
                    }
                }
            });

            dom.window.onPageShow.listen( (final dom.Event event) {
                if(event is dom.PageTransitionEvent && event.persisted) {
                    // when page is loaded from back/forward cache
                    // trigger repaint to let layout scroll in safari
                    element.style.overflowY = 'hidden';
                    dom.window.requestAnimationFrame( (_) {
                        element.style.overflowY = '';
                    });
                }
            });

            if (_header != null) {
                _tabBar = _header.querySelector('.' + _cssClasses.TAB_BAR);
            }

            int mode = _mode.STANDARD;

            if (header != null) {
                if (header.classes.contains(_cssClasses.HEADER_SEAMED)) {
                    mode = _mode.SEAMED;
                }
                else if (header.classes.contains(
                    _cssClasses.HEADER_WATERFALL)) {
                    mode = _mode.WATERFALL;

                    header.addEventListener('transitionend', _headerTransitionEndHandler);

                    // .addEventListener('click', -> .onClick.listen(<MouseEvent>);
                    eventStreams.add(
                        header.onClick.listen( _headerClickHandler));

                }
                else if (header.classes.contains(
                        _cssClasses.HEADER_SCROLL)) {
                        mode = _mode.SCROLL;
                        container.classes.add(_cssClasses.HAS_SCROLLING_HEADER);
                    }

                if (mode == _mode.STANDARD) {
                    header.classes.add(_cssClasses.CASTING_SHADOW);
                    if (tabBar != null) {
                        tabBar.classes.add(_cssClasses.CASTING_SHADOW);
                    }
                }
                else if (mode == _mode.SEAMED || mode == _mode.SCROLL) {
                    header.classes.remove(_cssClasses.CASTING_SHADOW);

                    if (tabBar != null) {
                        tabBar.classes.remove(_cssClasses.CASTING_SHADOW);
                    }
                }
                else if (mode == _mode.WATERFALL) {
                        // Add and remove shadows depending on scroll position.
                        // Also add/remove auxiliary class for styling of the compact version of
                        // the header.

                        // -- .onScroll.listen(<Event>);
                        eventStreams.add(
                            content.onScroll.listen( _contentScrollHandler ));
                        _contentScrollHandler('');
                    }
            }

            // Add drawer toggling button to our layout, if we have an openable drawer.
            if (drawer != null) {

                dom.HtmlElement drawerButton = element.querySelector(".${_cssClasses.DRAWER_BTN}");

                if (drawerButton == null) {

                    drawerButton = new dom.DivElement();
                    drawerButton.setAttribute('aria-expanded', 'false');
                    drawerButton.setAttribute('role', 'button');
                    drawerButton.setAttribute('tabindex', '0');
                    drawerButton.classes.add(_cssClasses.DRAWER_BTN);

                    final dom.HtmlElement drawerButtonIcon = dom.document.createElement('i');
                    drawerButtonIcon.classes.add(_cssClasses.ICON);
                    drawerButtonIcon.innerHtml = _constant.MENU_ICON;
                    drawerButton.append(drawerButtonIcon);
                }

                if (_drawer.classes.contains(_cssClasses.ON_LARGE_SCREEN)) {
                    //If drawer has ON_LARGE_SCREEN class then add it to the drawer toggle button as well.
                    drawerButton.classes.add(_cssClasses.ON_LARGE_SCREEN);
                } else if (_drawer.classes.contains(_cssClasses.ON_SMALL_SCREEN)) {
                    //If drawer has ON_SMALL_SCREEN class then add it to the drawer toggle button as well.
                    drawerButton.classes.add(_cssClasses.ON_SMALL_SCREEN);
                }

                eventStreams.add(
                    drawerButton.onClick.listen( _drawerToggleHandler ));

                eventStreams.add(
                    drawerButton.onKeyDown.listen( _drawerToggleHandler ));

                // Add a class if the layout has a drawer, for altering the left padding.
                // Adds the HAS_DRAWER_CLASS to the elements since _header may or may
                // not be present.
                element.classes.add(_cssClasses.HAS_DRAWER);

                // If we have a fixed header, add the button to the header rather than
                // the layout.
                if (element.classes.contains(_cssClasses.FIXED_HEADER)) {
                    header.insertBefore(drawerButton, header.firstChild);
                }
                else {
                    element.insertBefore(drawerButton, content);
                }

                //_logger.info("Check: .${_cssClasses.NAVI_LINK}");
                element.querySelectorAll(".${_cssClasses.NAVI_LINK}").forEach((final dom.Element element) {
                    eventStreams.add(
                        element.onClick.listen( _drawerRemove));
                });

                final dom.DivElement obfuscator = new dom.DivElement();
                obfuscator.classes.add(_cssClasses.OBFUSCATOR);
                element.append(obfuscator);

                eventStreams.add(obfuscator.onClick.listen( _drawerToggleHandler ));
                _obfuscator = obfuscator;

                _drawer.onKeyDown.listen(_keyboardEventHandler);
                _drawer.setAttribute('aria-hidden', 'true');
            }

            // Keep an eye on screen size, and add/remove auxiliary class for styling
            // of small screens.
            _screenSizeMediaQuery = dom.window.matchMedia(_constant.MAX_WIDTH);
            _screenSizeMediaQuery.addListener( (_) => _screenSizeHandler());
            _screenSizeHandler();

            // Initialize tabs, if any.
            if (header != null && tabBar != null) {
                element.classes.add(_cssClasses.HAS_TABS);

                final dom.DivElement tabContainer = new dom.DivElement();
                tabContainer.classes.add(_cssClasses.TAB_CONTAINER);
                header.insertBefore(tabContainer, tabBar);
                tabBar.remove(); // element.removeChild(_tabBar);

                final dom.DivElement leftButton = new dom.DivElement();
                leftButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
                leftButton.classes.add(_cssClasses.TAB_BAR_LEFT_BUTTON);

                final dom.Element leftButtonIcon = dom.document.createElement('i');
                leftButtonIcon.classes.add(_cssClasses.ICON);
                leftButtonIcon.text = _constant.CHEVRON_LEFT;
                leftButton.append(leftButtonIcon);

                eventStreams.add(
                    leftButton.onClick.listen( (final dom.MouseEvent event) {
                    tabBar.scrollLeft -= _constant.TAB_SCROLL_PIXELS;
                }));

                final dom.DivElement rightButton = new dom.DivElement();
                rightButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
                rightButton.classes.add(_cssClasses.TAB_BAR_RIGHT_BUTTON);

                final dom.Element rightButtonIcon = dom.document.createElement('i');
                rightButtonIcon.classes.add(_cssClasses.ICON);
                leftButtonIcon.text = _constant.CHEVRON_RIGHT;
                rightButton.append(rightButtonIcon);

                eventStreams.add(
                    rightButton.onClick.listen( (final dom.MouseEvent event) {
                    tabBar.scrollLeft += _constant.TAB_SCROLL_PIXELS;
                }));

                tabContainer.append(leftButton);
                tabContainer.append(tabBar);
                tabContainer.append(rightButton);

                // Add and remove tab buttons depending on scroll position and total
                // window size.

                void tabUpdateHandler () {
                    if (tabBar.scrollLeft > 0) {
                        leftButton.classes.add(_cssClasses.IS_ACTIVE);
                    }
                    else {
                        leftButton.classes.remove(_cssClasses.IS_ACTIVE);
                    }

                    if (tabBar.scrollLeft < tabBar.scrollWidth - tabBar.offsetWidth) {
                        rightButton.classes.add(_cssClasses.IS_ACTIVE);
                    }
                    else {
                        rightButton.classes.remove(_cssClasses.IS_ACTIVE);
                    }
                };
                eventStreams.add(
                    tabBar.onScroll.listen( (final dom.Event event) => tabUpdateHandler()));

                tabUpdateHandler();

                // Update tabs when the window resizes.
                Timer resizeTimer = null;
                void windowResizeHandler () {
                    // Use timeouts to make sure it doesn't happen too often.
                    if (resizeTimer != null) {
                        resizeTimer.cancel();
                        resizeTimer = null;
                    }
                    resizeTimer = new Timer(new Duration(milliseconds: _constant.RESIZE_TIMEOUT),() {
                        tabUpdateHandler();
                        resizeTimer = null;
                    });
                }

                eventStreams.add(
                    dom.window.onResize.listen((_) => windowResizeHandler()));

                if (tabBar.classes.contains(_cssClasses.JS_RIPPLE_EFFECT)) {
                    tabBar.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);
                }

                // Select element tabs, document panels
                final List<dom.Element> tabs = tabBar.querySelectorAll('.' + _cssClasses.TAB);
                final List<dom.Element> panels = content.querySelectorAll('.' + _cssClasses.PANEL);

                // Create new tabs for each tab element
                for (int i = 0; i < tabs.length; i++) {
                    _tabs.add(
                        new MaterialLayoutTab(tabs[i],
                        tabs as List<dom.AnchorElement>, panels as List<dom.HtmlElement>, this));
                }
            }

            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Handles scrolling on the content.
    void _contentScrollHandler(final dynamic _ ) {

        if(header.classes.contains(_cssClasses.IS_ANIMATING)) {
            return;
        }

        final bool headerVisible =
            !element.classes.contains(_cssClasses.IS_SMALL_SCREEN) ||
                element.classes.contains(_cssClasses.FIXED_HEADER);

        if (content.scrollTop > 0 && !header.classes.contains(_cssClasses.IS_COMPACT)) {
            header.classes.add(_cssClasses.CASTING_SHADOW);
            header.classes.add(_cssClasses.IS_COMPACT);
            header.classes.add(_cssClasses.IS_ANIMATING);

            if (headerVisible) {
                _header.classes.add(_cssClasses.IS_ANIMATING);
            }
        }
        else if (content.scrollTop <= 0 && header.classes.contains(_cssClasses.IS_COMPACT)) {
            header.classes.remove(_cssClasses.CASTING_SHADOW);
            header.classes.remove(_cssClasses.IS_COMPACT);
            header.classes.add(_cssClasses.IS_ANIMATING);

            if (headerVisible) {
                _header.classes.add(_cssClasses.IS_ANIMATING);
            }
        }
    }

    /// Handles a keyboard event on the drawer.
    ///
    /// param {Event} evt The event that fired.
    ///   MaterialLayout.prototype.keyboardEventHandler_ = function(evt) {
    void _keyboardEventHandler(final dom.KeyboardEvent event ) {
        // Only react when the drawer is open.
        if (event.keyCode == _MaterialLayoutKeycodes.ESCAPE &&
                drawer.classes.contains(_cssClasses.IS_DRAWER_OPEN)) {
            toggleDrawer();
        }
    }

    /// Handles changes in screen size.
    void _screenSizeHandler() {

        if (_screenSizeMediaQuery.matches) {
            element.classes.add(_cssClasses.IS_SMALL_SCREEN);
        }
        else {
            element.classes.remove(_cssClasses.IS_SMALL_SCREEN);

            // Collapse drawer (if any) when moving to a large screen size.
            if (_drawer != null) {
                _drawer.classes.remove(_cssClasses.IS_DRAWER_OPEN);
                obfuscator.classes.remove(_cssClasses.IS_DRAWER_OPEN);
            }
        }
    }

    /// Handles events of of drawer button.
    ///
    /// param {Event} evt The event that fired.
    void _drawerToggleHandler(final dom.Event event ) {
        if (event != null && event is dom.KeyEvent) {

            if (event.keyCode == _MaterialLayoutKeycodes.SPACE || event.keyCode == _MaterialLayoutKeycodes.ENTER) {
                // prevent scrolling in drawer nav
                event.preventDefault();

            } else {
                // prevent other keys
                return;
            }
        }

        toggleDrawer();
    }

    /// Explicit remove drawer
    void _drawerRemove(final dom.MouseEvent _) {
        drawer.classes.remove(_cssClasses.IS_DRAWER_OPEN);
        obfuscator.classes.remove(_cssClasses.IS_DRAWER_OPEN);
    }

    /// Handles (un)setting the `is-animating` class
    void _headerTransitionEndHandler(final dom.Event event) {

        header.classes.remove(_cssClasses.IS_ANIMATING);
    }

    /// Handles expanding the header on click
    void _headerClickHandler(final dom.MouseEvent _) {

        if (header.classes.contains(_cssClasses.IS_COMPACT)) {
            header.classes.remove(_cssClasses.IS_COMPACT);
            header.classes.add(_cssClasses.IS_ANIMATING);
        }
    }

    /// Reset tab state, dropping active classes
    ///
    /// [tabBar] - The tabs to reset.
    void _resetTabState(final tabBar) {

        for (int k = 0; k < tabBar.length; k++) {
            tabBar[k].classes.remove(_cssClasses.IS_ACTIVE);
        }
    }

    /// Reset panel state, dropping active classes
    ///
    /// [panels] to reset
    void _resetPanelState(final panels) {

        for (int j = 0; j < panels.length; j++) {
            panels[j].classes.remove(_cssClasses.IS_ACTIVE);
        }
    }
}

/// Individual Tab
class MaterialLayoutTab {

    final dom.AnchorElement tab;  // using Element instead of AnchorElement makes mdl-layout-tab-Tag with href attrib possible
    final List<dom.AnchorElement> tabs;
    final List<dom.HtmlElement> panels;
    final MaterialLayout layout;

    static const _MaterialLayoutCssClasses _cssClasses = const _MaterialLayoutCssClasses();

    /// All the registered Events - helpful for automatically downgrading the element
    /// Sample:
    ///     eventStreams.add(input.onFocus.listen( _onFocus));
    final List<StreamSubscription> eventStreams = new List<StreamSubscription>();

    /**
     * [tab] The HTML element for the tab.
     * [tabs] List with HTML elements for all tabs.
     * [panels] List with HTML elements for all panels.
     * [layout] The MaterialLayout object that owns the tab.
      */
    MaterialLayoutTab(this.tab, this.tabs, this.panels, this.layout) {

        void _selectTab() {

            final String attribHref = tab.attributes["href"];
            final href = attribHref.split('#')[1];

            final panel = layout.content.querySelector('#' + href);
            layout._resetTabState(tabs);
            layout._resetPanelState(panels);

            tab.classes.add(_cssClasses.IS_ACTIVE);
            panel.classes.add(_cssClasses.IS_ACTIVE);
        }

        if (tab != null) {
            if (layout.tabBar.classes.contains(_cssClasses.JS_RIPPLE_EFFECT)) {

                final dom.SpanElement rippleContainer = new dom.SpanElement();
                rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
                rippleContainer.classes.add(_cssClasses.JS_RIPPLE_EFFECT);

                final dom.SpanElement ripple = new dom.SpanElement();
                ripple.classes.add(_cssClasses.RIPPLE);
                rippleContainer.append(ripple);
                tab.append(rippleContainer);
            }

            if(! layout.tabBar.classes.contains(_cssClasses.TAB_MANUAL_SWITCH)) {
                eventStreams.add(
                    tab.onClick.listen((final dom.MouseEvent event) {
                        if (tab.attributes["href"].startsWith("#")) {
                            event.preventDefault();
                            event.stopPropagation();

                            _selectTab();
                        }
                    }));
            }

            //tab.show = _selectTab();
        }
    }

    //- private -----------------------------------------------------------------------------------

    /// Cancels all the registered streams
    void _downgrade() {
        eventStreams.forEach((final StreamSubscription stream) {
            stream?.cancel();
        });
        eventStreams.clear();
    }
}

/// creates MdlConfig for MaterialLayout
MdlConfig materialLayoutConfig() => new MdlWidgetConfig<MaterialLayout>(
    _MaterialLayoutCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
=> new MaterialLayout.fromElement(element,injector));

/// registration-Helper
void registerMaterialLayout() => componentHandler().register(materialLayoutConfig());

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialLayoutCssClasses {

    static const String MAIN_CLASS  = "mdl-layout";

    final String CONTAINER = 'mdl-layout__container';
    final String HEADER = 'mdl-layout__header';
    final String DRAWER = 'mdl-layout__drawer';
    final String CONTENT = 'mdl-layout__content';
    final String DRAWER_BTN = 'mdl-layout__drawer-button';

    final String ICON = 'material-icons';

    final String JS_RIPPLE_EFFECT = 'mdl-ripple-effect';
    final String RIPPLE_CONTAINER = 'mdl-layout__tab-ripple-container';
    final String RIPPLE = 'mdl-ripple';
    final String RIPPLE_IGNORE_EVENTS = 'mdl-ripple-effect--ignore-events';

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
    final String TAB_MANUAL_SWITCH = 'mdl-layout__tab-manual-switch';
    final String PANEL = 'mdl-layout__tab-panel';

    final String NAVI_LINK = "mdl-navigation__link";

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
    final String ON_SMALL_SCREEN  = 'mdl-layout--small-screen-only';

    const _MaterialLayoutCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialLayoutConstant {

    final String MAX_WIDTH = '(max-width: 1024px)';
    final int TAB_SCROLL_PIXELS = 100;
    final int RESIZE_TIMEOUT = 100;

    final String MENU_ICON = '&#xE5D2;';
    final String CHEVRON_LEFT = 'chevron_left';
    final String CHEVRON_RIGHT = 'chevron_right';

    const _MaterialLayoutConstant();
}