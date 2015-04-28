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

    final String HEADER = 'mdl-layout__header';
    final String DRAWER = 'mdl-layout__drawer';
    final String CONTENT = 'mdl-layout__content';
    final String DRAWER_BTN = 'mdl-layout__drawer-button';

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

    final String HAS_DRAWER_CLASS = 'has-drawer';
    final String SHADOW_CLASS = 'is-casting-shadow';
    final String COMPACT_CLASS = 'is-compact';
    final String SMALL_SCREEN_CLASS = 'is-small-screen';
    final String DRAWER_OPEN_CLASS = 'is-visible';
    final String ACTIVE_CLASS = 'is-active';
    final String UPGRADED_CLASS = 'is-upgraded';
    final String ANIMATING_CLASS = 'is-animating';

    const _MaterialLayoutCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialLayoutConstant {

    final String MAX_WIDTH = '(max-width: 850px)';

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
    "mdl-js-layout", (final dom.HtmlElement element) => new MaterialLayout.fromElement(element));

/// registration-Helper
void registerMaterialLayout() => componenthandler.register(materialLayoutConfig());

class MaterialLayout extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialLayout');

    static const _MaterialLayoutConstant _constant = const _MaterialLayoutConstant();
    static const _MaterialLayoutCssClasses _cssClasses = const _MaterialLayoutCssClasses();
    static const _MaterialLayoutMode _mode = const _MaterialLayoutMode();

    dom.HtmlElement _header = null;
    dom.HtmlElement _drawer = null;
    dom.HtmlElement _tabBar = null;
    dom.HtmlElement _content = null;

    MaterialLayout.fromElement(final dom.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialLayout widget(final dom.HtmlElement element) => mdlComponent(element) as MaterialLayout;

    dom.HtmlElement get header {
        if(_header == null) { _header = element.querySelector('.' + _cssClasses.HEADER); }
        return _header;
    }

    dom.HtmlElement get drawer {
        if(_drawer == null) { _drawer = element.querySelector('.' + _cssClasses.DRAWER); }
        return _drawer;
    }

    dom.HtmlElement get tabBar {
        if(_tabBar == null) { _tabBar = element.querySelector('.' + _cssClasses.TAB_BAR); }
        return _tabBar;
    }

    dom.HtmlElement get content {
        if(_content == null) { _content = element.querySelector('.' + _cssClasses.CONTENT); }
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
            container.classes.add('mdl-layout__container');
            element.parent.insertBefore(container, element);
            element.remove(); // element.parent.removeChild (element);
            container.append(element);

            int mode = _mode.STANDARD;

            // _screenSizeMediaQuery.addListener(_screenSizeHandler);
            //_screenSizeHandler();

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
                else if (element.classes.contains(
                        _cssClasses.HEADER_SCROLL)) {
                        mode = _mode.SCROLL;
                    }

                if (mode == _mode.STANDARD) {
                    header.classes.add(_cssClasses.SHADOW_CLASS);
                    if (tabBar != null) {
                        tabBar.classes.add(_cssClasses.SHADOW_CLASS);
                    }
                }
                else if (mode == _mode.SEAMED || mode == _mode.SCROLL) {
                    header.classes.remove(_cssClasses.SHADOW_CLASS);

                    if (tabBar != null) {
                        tabBar.classes.remove(_cssClasses.SHADOW_CLASS);
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

                drawerButton.onClick.listen( _drawerToggleHandler );

                // Add a class if the layout has a drawer, for altering the left padding.
                // Adds the HAS_DRAWER_CLASS to the elements since _header may or may
                // not be present.
                element.classes.add(_cssClasses.HAS_DRAWER_CLASS);

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
                    element.onClick.listen( (_) => drawer.classes.remove(_cssClasses.DRAWER_OPEN_CLASS) );
                });

                final dom.DivElement obfuscator = new dom.DivElement();
                obfuscator.classes.add(_cssClasses.OBFUSCATOR);
                element.append(obfuscator);

                obfuscator.onClick.listen( _drawerToggleHandler );


            }

            // Initialize tabs, if any.
            if (tabBar != null) {

                final dom.DivElement tabContainer = new dom.DivElement();
                tabContainer.classes.add(_cssClasses.TAB_CONTAINER);
                element.insertBefore(tabContainer, tabBar);
                tabBar.remove(); // element.removeChild(_tabBar);

                final dom.DivElement leftButton = new dom.DivElement();
                leftButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
                leftButton.classes.add(_cssClasses.TAB_BAR_LEFT_BUTTON);

                leftButton.onClick.listen( (final dom.MouseEvent event) {
                    tabBar.scrollLeft -= 100;
                });

                final dom.DivElement rightButton = new dom.DivElement();
                rightButton.classes.add(_cssClasses.TAB_BAR_BUTTON);
                rightButton.classes.add(_cssClasses.TAB_BAR_RIGHT_BUTTON);

                rightButton.onClick.listen( (final dom.MouseEvent event) {
                    tabBar.scrollLeft += 100;
                });

                tabContainer.append(leftButton);
                tabContainer.append(tabBar);
                tabContainer.append(rightButton);

                // Add and remove buttons depending on scroll position.
                void tabScrollHandler () {
                    if (tabBar.scrollLeft > 0) {
                        leftButton.classes.add(_cssClasses.ACTIVE_CLASS);
                    }
                    else {
                        leftButton.classes.remove(_cssClasses.ACTIVE_CLASS);
                    }

                    if (tabBar.scrollLeft < tabBar.scrollWidth - tabBar.offsetWidth) {
                        rightButton.classes.add(_cssClasses.ACTIVE_CLASS);
                    }
                    else {
                        rightButton.classes.remove(_cssClasses.ACTIVE_CLASS);
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
                    new MaterialLayoutTab(tabs[i], tabs, panels, this);
                }
            }

            element.classes.add(_cssClasses.UPGRADED_CLASS);
        }
    }

    /// Handles scrolling on the content.
    void _contentScrollHandler(final dynamic _ ) {

        if(header.classes.contains(_cssClasses.ANIMATING_CLASS)) {
            return;
        }

        if (content.scrollTop > 0 && !header.classes.contains(_cssClasses.COMPACT_CLASS)) {
            header.classes.add(_cssClasses.SHADOW_CLASS);
            header.classes.add(_cssClasses.COMPACT_CLASS);
            header.classes.add(_cssClasses.ANIMATING_CLASS);
        }
        else if (content.scrollTop <= 0 && header.classes.contains(_cssClasses.COMPACT_CLASS)) {
            header.classes.remove(_cssClasses.SHADOW_CLASS);
            header.classes.remove(_cssClasses.COMPACT_CLASS);
            header.classes.add(_cssClasses.ANIMATING_CLASS);
        }
    }

    /// Handles changes in screen size.
//    void _screenSizeHandler() {
//
//        if (_screenSizeMediaQuery.matches) {
//            element.classes.add(_cssClasses.SMALL_SCREEN_CLASS);
//        }
//        else {
//            element.classes.remove(_cssClasses.SMALL_SCREEN_CLASS);
//
//            // Collapse drawer (if any) when moving to a large screen size.
//            if (_drawer != null) {
//                _drawer.classes.remove(_cssClasses.DRAWER_OPEN_CLASS);
//            }
//        }
//    }

    /// Handles toggling of the drawer.
    /// The [drawer] container element.
    void _drawerToggleHandler(final dom.MouseEvent _) {
        drawer.classes.toggle(_cssClasses.DRAWER_OPEN_CLASS);
    }

    /// Handles (un)setting the `is-animating` class
    /// MaterialLayout.prototype.headerTransitionEndHandler = /*function*/ () {
    void _headerTransitionEndHandler(final dom.Event event) {

        header.classes.remove(_cssClasses.ANIMATING_CLASS);
    }

    /// Handles expanding the header on click
    /// MaterialLayout.prototype.headerClickHandler = /*function*/ () {
    void _headerClickHandler(final dom.MouseEvent _) {

        if (header.classes.contains(_cssClasses.COMPACT_CLASS)) {
            header.classes.remove(_cssClasses.COMPACT_CLASS);
            header.classes.add(_cssClasses.ANIMATING_CLASS);
        }
    }

    /// Reset tab state, dropping active classes
    void _resetTabState(final tabBar) {

        for (int k = 0; k < tabBar.length; k++) {
            tabBar[k].classes.remove(_cssClasses.ACTIVE_CLASS);
        }
    }

    /// Reset panel state, dropping active classes
    /// MaterialLayout.prototype.resetPanelState_ = function(panels) {
    void _resetPanelState(final panels) {

        for (int j = 0; j < panels.length; j++) {
            panels[j].classes.remove(_cssClasses.ACTIVE_CLASS);
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

                final String attribHref = tab.attributes["href"];
                final href = attribHref.split('#')[1];

                final panel = layout.content.querySelector('#' + href);
                layout._resetTabState(tabs);
                layout._resetPanelState(panels);

                tab.classes.add(_cssClasses.ACTIVE_CLASS);
                panel.classes.add(_cssClasses.ACTIVE_CLASS);
            });

        }
    }
}

