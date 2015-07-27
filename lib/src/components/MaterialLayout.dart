/**
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

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialLayoutCssClasses {

    static const String MAIN_CLASS  = "mdl-js-layout";

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

    final String MENU_ICON = 'menu';
    final String CHEVRON_LEFT = 'chevron_left';
    final String CHEVRON_RIGHT = 'chevron_right';

    const _MaterialLayoutConstant();
}

/// Modes.
class _MaterialLayoutMode {

    final int STANDARD = 0;
    final int SEAMED = 1;
    final int WATERFALL = 2;
    final int SCROLL = 3;

    const _MaterialLayoutMode();
}

/// creates MdlConfig for MaterialLayout
MdlConfig materialLayoutConfig() => new MdlWidgetConfig<MaterialLayout>(
    _MaterialLayoutCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialLayout.fromElement(element,injector));

/// registration-Helper
void registerMaterialLayout() => componentHandler().register(materialLayoutConfig());

class MaterialLayout extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialLayout');

    static const _MaterialLayoutConstant _constant = const _MaterialLayoutConstant();
    static const _MaterialLayoutCssClasses _cssClasses = const _MaterialLayoutCssClasses();
    static const _MaterialLayoutMode _mode = const _MaterialLayoutMode();

    dom.HtmlElement _header = null;
    dom.HtmlElement _drawer = null;
    dom.HtmlElement _tabBar = null;
    dom.HtmlElement _content = null;
    dom.MediaQueryList _screenSizeMediaQuery = null;

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

    //- private -----------------------------------------------------------------------------------


    // Keep an eye on screen size, and add/remove auxiliary class for styling
    // of small screens.
    // html.MediaQueryList get _screenSizeMediaQuery => html.window.matchMedia(_constant.MAX_WIDTH);

    void _init() {
        _logger.fine("MaterialLayout - init");

        if (element != null) {

            final dom.DivElement container = new dom.DivElement();
            container.classes.add(_cssClasses.CONTAINER);
            element.parent.insertBefore(container, element);
            element.remove(); // element.parent.removeChild (element);
            container.append(element);

            final List<dom.Element> directChildren = element.childNodes;

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

            if (_header != null) {
                _tabBar = _header.querySelector('.' + _cssClasses.TAB_BAR);
            }

            int mode = _mode.STANDARD;

            // Keep an eye on screen size, and add/remove auxiliary class for styling
            // of small screens.
            _screenSizeMediaQuery = dom.window.matchMedia(_constant.MAX_WIDTH);
            _screenSizeMediaQuery.addListener( (_) => _screenSizeHandler());
            _screenSizeHandler();

            if (header != null) {
                if (header.classes.contains(_cssClasses.HEADER_SEAMED)) {
                    mode = _mode.SEAMED;
                }
                else if (header.classes.contains(
                    _cssClasses.HEADER_WATERFALL)) {
                    mode = _mode.WATERFALL;

                    header.addEventListener('transitionend', _headerTransitionEndHandler);

                    // .addEventListener('click', -> .onClick.listen(<MouseEvent>);
                    header.onClick.listen( _headerClickHandler);

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
                        content.onScroll.listen( _contentScrollHandler );
                        _contentScrollHandler('');
                    }
            }

            // Add drawer toggling button to our layout, if we have an openable drawer.
            if (drawer != null) {

                final dom.DivElement drawerButton = new dom.DivElement();
                drawerButton.classes.add(_cssClasses.DRAWER_BTN);

                if (_drawer.classes.contains(_cssClasses.ON_LARGE_SCREEN)) {
                    //If drawer has ON_LARGE_SCREEN class then add it to the drawer toggle button as well.
                    drawerButton.classes.add(_cssClasses.ON_LARGE_SCREEN);
                } else if (_drawer.classes.contains(_cssClasses.ON_SMALL_SCREEN)) {
                    //If drawer has ON_SMALL_SCREEN class then add it to the drawer toggle button as well.
                    drawerButton.classes.add(_cssClasses.ON_SMALL_SCREEN);
                }

                final dom.Element drawerButtonIcon = dom.document.createElement('i');
                drawerButtonIcon.classes.add(_cssClasses.ICON);
                drawerButtonIcon.text = _constant.MENU_ICON;
                drawerButton.append(drawerButtonIcon);

                drawerButton.onClick.listen( _drawerToggleHandler );

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
                    //_logger.info("click $element");
                    element.onClick.listen( (_) => drawer.classes.remove(_cssClasses.IS_DRAWER_OPEN) );
                });

                final dom.DivElement obfuscator = new dom.DivElement();
                obfuscator.classes.add(_cssClasses.OBFUSCATOR);
                element.append(obfuscator);

                obfuscator.onClick.listen( _drawerToggleHandler );
            }

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

                leftButton.onClick.listen( (final dom.MouseEvent event) {
                    tabBar.scrollLeft -= _constant.TAB_SCROLL_PIXELS;
                });

                final dom.DivElement rightButton = new dom.DivElement();
                rightButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
                rightButton.classes.add(_cssClasses.TAB_BAR_RIGHT_BUTTON);

                final dom.Element rightButtonIcon = dom.document.createElement('i');
                rightButtonIcon.classes.add(_cssClasses.ICON);
                leftButtonIcon.text = _constant.CHEVRON_RIGHT;
                rightButton.append(rightButtonIcon);

                rightButton.onClick.listen( (final dom.MouseEvent event) {
                    tabBar.scrollLeft += _constant.TAB_SCROLL_PIXELS;
                });

                tabContainer.append(leftButton);
                tabContainer.append(tabBar);
                tabContainer.append(rightButton);

                // Add and remove buttons depending on scroll position.
                void tabScrollHandler () {
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
                tabBar.onScroll.listen( (final dom.Event event) => tabScrollHandler());
                tabScrollHandler();

                if (tabBar.classes.contains(_cssClasses.JS_RIPPLE_EFFECT)) {
                    tabBar.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);
                }

                // Select element tabs, document panels
                final List<dom.Element> tabs = tabBar.querySelectorAll('.' + _cssClasses.TAB);
                final List<dom.Element> panels = content.querySelectorAll('.' + _cssClasses.PANEL);

                // Create new tabs for each tab element
                for (int i = 0; i < tabs.length; i++) {
                    new MaterialLayoutTab(tabs[i],
                        tabs as List<dom.AnchorElement>, panels as List<dom.HtmlElement>, this);
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

        if (content.scrollTop > 0 && !header.classes.contains(_cssClasses.IS_COMPACT)) {
            header.classes.add(_cssClasses.CASTING_SHADOW);
            header.classes.add(_cssClasses.IS_COMPACT);
            header.classes.add(_cssClasses.IS_ANIMATING);
        }
        else if (content.scrollTop <= 0 && header.classes.contains(_cssClasses.IS_COMPACT)) {
            header.classes.remove(_cssClasses.CASTING_SHADOW);
            header.classes.remove(_cssClasses.IS_COMPACT);
            header.classes.add(_cssClasses.IS_ANIMATING);
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
            }
        }
    }

    /// Handles toggling of the drawer.
    /// The [drawer] container element.
    void _drawerToggleHandler(final dom.MouseEvent _) {
        drawer.classes.toggle(_cssClasses.IS_DRAWER_OPEN);
    }

    /// Handles (un)setting the `is-animating` class
    /// MaterialLayout.prototype.headerTransitionEndHandler = /*function*/ () {
    void _headerTransitionEndHandler(final dom.Event event) {

        header.classes.remove(_cssClasses.IS_ANIMATING);
    }

    /// Handles expanding the header on click
    /// MaterialLayout.prototype.headerClickHandler = /*function*/ () {
    void _headerClickHandler(final dom.MouseEvent _) {

        if (header.classes.contains(_cssClasses.IS_COMPACT)) {
            header.classes.remove(_cssClasses.IS_COMPACT);
            header.classes.add(_cssClasses.IS_ANIMATING);
        }
    }

    /// Reset tab state, dropping active classes
    void _resetTabState(final tabBar) {

        for (int k = 0; k < tabBar.length; k++) {
            tabBar[k].classes.remove(_cssClasses.IS_ACTIVE);
        }
    }

    /// Reset panel state, dropping active classes
    /// MaterialLayout.prototype.resetPanelState_ = function(panels) {
    void _resetPanelState(final panels) {

        for (int j = 0; j < panels.length; j++) {
            panels[j].classes.remove(_cssClasses.IS_ACTIVE);
        }
    }
}

class MaterialLayoutTab {

    final dom.Element tab;  // using Element instead of AnchorElement makes mdl-layout-tab-Tag with href attrib possible
    final List<dom.AnchorElement> tabs;
    final List<dom.HtmlElement> panels;
    final MaterialLayout layout;

    static const _MaterialLayoutCssClasses _cssClasses = const _MaterialLayoutCssClasses();

    MaterialLayoutTab(this.tab, this.tabs, this.panels, this.layout) {

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

            tab.onClick.listen( (final dom.MouseEvent event) {
                event.preventDefault();
                event.stopPropagation();

                final String attribHref = tab.attributes["href"];
                final href = attribHref.split('#')[1];

                final panel = layout.content.querySelector('#' + href);
                layout._resetTabState(tabs);
                layout._resetPanelState(panels);

                tab.classes.add(_cssClasses.IS_ACTIVE);
                panel.classes.add(_cssClasses.IS_ACTIVE);
            });

        }
    }
}

