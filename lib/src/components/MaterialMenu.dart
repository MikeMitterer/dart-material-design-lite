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

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialMenuCssClasses {

    static const String MAIN_CLASS  = "mdl-js-menu";

    final String CONTAINER = 'mdl-menu__container';
    final String OUTLINE = 'mdl-menu__outline';
    final String ITEM = 'mdl-menu__item';
    final String ITEM_RIPPLE_CONTAINER = 'mdl-menu__item-ripple-container';
    final String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
    final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
    final String RIPPLE = 'mdl-ripple';

    // Statuses
    final String IS_UPGRADED = 'is-upgraded';
    final String IS_VISIBLE = 'is-visible';
    final String IS_ANIMATING = 'is-animating';

    // Alignment options
    final String BOTTOM_LEFT = 'mdl-menu--bottom-left';
    final String BOTTOM_RIGHT = 'mdl-menu--bottom-right';
    final String TOP_LEFT = 'mdl-menu--top-left';
    final String TOP_RIGHT = 'mdl-menu--top-right';
    final String UNALIGNED = 'mdl-menu--unaligned';

    const _MaterialMenuCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialMenuConstant {

    // Total duration of the menu animation.
    final int TRANSITION_DURATION_SECONDS = 0;

    // The fraction of the total duration we want to use for menu item animations.
    final int TRANSITION_DURATION_FRACTION = 0;

    // How long the menu stays open after choosing an option (so the user can see
    // the ripple).
    final int CLOSE_TIMEOUT = 150;


    const _MaterialMenuConstant();
}

/// KeyCodes, for code readability.
class _KeyCode {
    final int value;

    static const _KeyCode ENTER = const _KeyCode(13);
    static const _KeyCode ESCAPE = const _KeyCode(27);
    static const _KeyCode SPACE = const _KeyCode(32);
    static const _KeyCode UP_ARROW = const _KeyCode(38);
    static const _KeyCode DOWN_ARROW = const _KeyCode(40);

    const _KeyCode(this.value);
}

/// creates MdlConfig for MaterialMenu
MdlConfig materialMenuConfig() => new MdlWidgetConfig<MaterialMenu>(
    _MaterialMenuCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialMenu.fromElement(element,injector));

/// registration-Helper
void registerMaterialMenu() => componentHandler().register(materialMenuConfig());

class MaterialMenu extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialMenu');

    static const _MaterialMenuConstant _constant = const _MaterialMenuConstant();
    static const _MaterialMenuCssClasses _cssClasses = const _MaterialMenuCssClasses();

    bool _closing = false;

    dom.DivElement _container;
    dom.DivElement _outline;
    dom.Element _forElement;

    StreamSubscription _animationStream = null;

    dom.Element get forElement {
        if(_forElement == null) {
            _initForElement();
        }
        return _forElement;
    }

    MaterialMenu.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialMenu widget(final dom.HtmlElement element) => mdlComponent(element,MaterialMenu) as MaterialMenu;

    /// Displays the menu.
    void show() {

        _recalcPosition();

        if (element != null && _container != null && _outline != null ) {
            // Measure the inner element.

            final height = element.getBoundingClientRect().height as num;
            final width = element.getBoundingClientRect().width as num;

            // Apply the inner element's size to the container and outline.
            _container.style.width = "${width}px";
            _container.style.height = "${height}px";
            _outline.style.width = "${width}px";
            _outline.style.height = "${height}px";

            final transitionDuration = (_constant.TRANSITION_DURATION_SECONDS * _constant.TRANSITION_DURATION_FRACTION);

            // Calculate transition delays for individual menu items, so that they fade
            // in one at a time.
            final List<dom.Element> items = element.querySelectorAll('.' + _cssClasses.ITEM);

            items.forEach((final dom.Element item) {
                double itemDelay = 0.0;
                if (element.classes.contains(_cssClasses.TOP_LEFT) || element.classes.contains(_cssClasses.TOP_RIGHT)) {
                    itemDelay = ((height - item.offsetTop - item.offsetHeight) / height * transitionDuration);

                } else {
                    itemDelay = (item.offsetTop / height * transitionDuration);
                }
                item.style.transitionDelay = "${itemDelay}s";

            });

            // Apply the initial clip to the text before we start animating.
            _applyClip(height, width);

            // Wait for the next frame, turn on animation, and apply the final clip.
            // Also make it visible. This triggers the transitions.
            dom.window.requestAnimationFrame( (_) {
                element.classes.add(_cssClasses.IS_ANIMATING);
                element.style.clip = 'rect(0 ${width}px ${height}px 0)';
                _container.classes.add(_cssClasses.IS_VISIBLE);
            });

            // Clean up after the animation is complete.
            _addAnimationEndListener();
        }
    }

    /// Hides the menu.
    void hide() {

        if (element != null && _container != null && _outline != null ) {

            final items = element.querySelectorAll('.' + _cssClasses.ITEM);

            // Remove all transition delays; menu items fade out concurrently.
            items.forEach((final dom.Element item) {
                item.style.removeProperty('transition-delay');
            });

            // Measure the inner element.

            final height = element.getBoundingClientRect().height;

            final width = element.getBoundingClientRect().width;

            // Turn on animation, and apply the final clip. Also make invisible.
            // This triggers the transitions.
            element.classes.add(_cssClasses.IS_ANIMATING);
            _applyClip(height, width);
            _container.classes.remove(_cssClasses.IS_VISIBLE);

            // Clean up after the animation is complete.
            _addAnimationEndListener();
        }
    }

    /// Displays or hides the menu, depending on current state.
    void toggle() {

        if (_container.classes.contains(_cssClasses.IS_VISIBLE)) {
            hide();

        } else {
            show();
        }
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialMenu - init");

        if (element != null) {
            // Create container for the menu.

            final container = new dom.DivElement();
            container.classes.add(_cssClasses.CONTAINER);
            element.parent.insertBefore(container, element);
            element.remove(); // element.parent.removeChild(element);
            container.append(element);
            _container = container;

            // Create outline for the menu (shadow and background).
            final outline = new dom.DivElement();
            outline.classes.add(_cssClasses.OUTLINE);
            _outline = outline;
            container.insertBefore(outline, element);

            _initForElement();

            final List<dom.Element> items = element.querySelectorAll('.' + _cssClasses.ITEM );
            items.forEach((final dom.Element item) {
                // Add a listener to each menu item.

                // .addEventListener('click', -> .onClick.listen(<MouseEvent>);
                eventStreams.add(item.onClick.listen(_handleItemClick));

                // Add a tab index to each menu item.
                item.tabIndex = -1;

                // Add a keyboard listener to each menu item.
                eventStreams.add(item.onKeyDown.listen( _handleItemKeyboardEvent ));
            });

            // Add ripple classes to each item, if the user has enabled ripples.
            if (element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
                element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

                items.forEach((final dom.Element item) {

                    final rippleContainer = new dom.SpanElement();
                    rippleContainer.classes.add(_cssClasses.ITEM_RIPPLE_CONTAINER);

                    final ripple = new dom.SpanElement();
                    ripple.classes.add(_cssClasses.RIPPLE);
                    rippleContainer.append(ripple);

                    item.append(rippleContainer);
                    item.classes.add(_cssClasses.RIPPLE_EFFECT);
                });
            }

            // Copy alignment classes to the container, so the outline can use them.
            if (element.classes.contains(_cssClasses.BOTTOM_LEFT)) {
                _outline.classes.add(_cssClasses.BOTTOM_LEFT);
            }
            if (element.classes.contains(_cssClasses.BOTTOM_RIGHT)) {
                _outline.classes.add(_cssClasses.BOTTOM_RIGHT);
            }
            if (element.classes.contains(_cssClasses.TOP_LEFT)) {
                _outline.classes.add(_cssClasses.TOP_LEFT);
            }
            if (element.classes.contains(_cssClasses.TOP_RIGHT)) {
                _outline.classes.add(_cssClasses.TOP_RIGHT);
            }
            if (element.classes.contains(_cssClasses.UNALIGNED)) {
                _outline.classes.add(_cssClasses.UNALIGNED);
            }

            void _closeMenu(final dom.Event event) {
                //event.preventDefault();
                if(!_closing) {
                    hide();
                }
            }

            dom.document.onClick.listen( (final dom.Event event) => _closeMenu(event));
            dom.document.onKeyDown.listen((final dom.KeyboardEvent event) {
                if(event.keyCode == _KeyCode.ESCAPE.value ) {
                    _closeMenu(event);
                }
            });

            container.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// searching the for-Element is a bit complex so it got it's own function.
    void _initForElement() {
        final forElId = element.getAttribute('for') != null ?
            element.getAttribute('for') : element.getAttribute('data-mdl-for');

        _logger.fine("forElId $forElId");

        dom.Element forEl = null;
        if (forElId != null) {

            void _addEventListeners(final dom.HtmlElement forEl) {
                _logger.fine("forEL $forEl #${forElId}");
                if (forEl != null) {
                    _logger.fine("$element has a for-ID: #$forElId pointing to $forEl");
                    _forElement = forEl;

                    // .addEventListener('click', -> .onClick.listen(<MouseEvent>);
                    forEl.onClick.listen( _handleForClick );
                    forEl.onKeyDown.listen( _handleForKeyboardEvent );
                }
            }

            // getElementById is OK here! element.querySelector not possible!
            forEl = dom.document.getElementById(forElId);
            if(forEl != null) {
                _addEventListeners(forEl);
            } else {
                // forEl was not found but maybe just because it takes a while for the DOM
                // to recognize it... so we wait 50ms
                new Future.delayed(new Duration(milliseconds: 50),() {
                    _addEventListeners(dom.document.getElementById(forElId));
                });
            }
        }
    }

    /// Handles a click on the "for" element, by positioning the menu and then
    /// toggling it.
    void _handleForClick(final dom.MouseEvent evt) {
        _recalcPosition();
        toggle();
    }

    /// Recalculates the position of the menu-container depending on the menu settings (left, right...)
    void _recalcPosition() {
        _logger.fine("Recalc $element $forElement");

        if (element != null && forElement != null) {

            final rect = forElement.getBoundingClientRect();

            final forRect = forElement.parent.getBoundingClientRect();

            if (element.classes.contains(_cssClasses.UNALIGNED)) {
                // Do not position the menu automatically. Requires the developer to
                // manually specify position.

            } else if (element.classes.contains(_cssClasses.BOTTOM_RIGHT)) {

                // Position below the "for" element, aligned to its right.
                _container.style.right = "${forRect.right - rect.right + 10}px";
                _container.style.top = "${forElement.offsetTop + forElement.offsetHeight}px";

            } else if (element.classes.contains(_cssClasses.TOP_LEFT)) {

                // Position above the "for" element, aligned to its left.
                _container.style.left = "${forElement.offsetLeft}px";
                _container.style.bottom = "${forRect.bottom - rect.top}px";

            } else if (element.classes.contains(_cssClasses.TOP_RIGHT)) {
                // Position above the "for" element, aligned to its right.
                _container.style.right = "${forRect.right - rect.right}px";
                _container.style.bottom = "${forRect.bottom - rect.top}px";

            } else {
                // Default: position below the "for" element, aligned to its left.
                _container.style.left = "${forElement.offsetLeft}px";
                _container.style.top = "${forElement.offsetTop + forElement.offsetHeight}px";
            }
        }
    }

    /// Handles a keyboard event on the "for" element.
    void _handleForKeyboardEvent(final dom.KeyboardEvent event) {
        _logger.fine("_handleForKeyboardEvent: $event");

        if (element != null && _container != null && forElement != null) {

            final List<dom.Element> items = element.querySelectorAll('.' + _cssClasses.ITEM + ':not([disabled])');

            if (items != null && items.length > 0 &&
            _container.classes.contains(_cssClasses.IS_VISIBLE)) {
                if (event.keyCode == _KeyCode.UP_ARROW.value ) {
                    event.preventDefault();
                    items.last.focus();
                } else if (event.keyCode == _KeyCode.DOWN_ARROW.value ) {
                    event.preventDefault();
                    items.first.focus();
                }
            }
        }
    }

    /// Handles a keyboard event on an item.
    void _handleItemKeyboardEvent(final dom.KeyboardEvent event) {
        _logger.fine("_handleItemKeyboardEvent: $event");

        if (element != null && _container != null) {

            final List<dom.Element> items = element.querySelectorAll('.' + _cssClasses.ITEM + ':not([disabled])');

            if (items != null && items.length > 0 && _container.classes.contains(_cssClasses.IS_VISIBLE)) {

                final currentIndex = items.indexOf(event.target);
                _logger.fine("${event.target} -> $currentIndex");

                if (event.keyCode == _KeyCode.UP_ARROW.value) {
                    event.preventDefault();
                    if (currentIndex > 0) {
                        items[currentIndex - 1].focus();

                    } else {
                        items[items.length - 1].focus();
                    }
                } else if (event.keyCode == _KeyCode.DOWN_ARROW.value) {
                    event.preventDefault();
                    if (items.length > currentIndex + 1) {
                        items[currentIndex + 1].focus();

                    } else {
                        items[0].focus();
                    }
                } else if (event.keyCode == _KeyCode.SPACE.value || event.keyCode == _KeyCode.ENTER.value) {
                    event.preventDefault();
                    // Send mousedown and mouseup to trigger ripple.

                    var dynEvent = new dom.MouseEvent('mousedown');
                    event.target.dispatchEvent(dynEvent);

                    dynEvent = new dom.MouseEvent('mouseup');
                    event.target.dispatchEvent(dynEvent);
                    // Send click.
                    (event.target as dom.Element).click();

                } else if (event.keyCode == _KeyCode.ESCAPE.value) {
                    event.preventDefault();
                    hide();
                }
            }
        }
    }

    /// Handles a click event on an item.
    void _handleItemClick(final dom.MouseEvent event) {
        event.stopPropagation();

        if ((event.target as dom.Element).attributes.containsKey('disabled') ) {
            event.stopPropagation();

        } else {
            // Wait some time before closing menu, so the user can see the ripple.
            _closing = true;
            new Timer(new Duration(milliseconds: _constant.CLOSE_TIMEOUT), () {
                hide();
                _closing = false;
            });
        }
    }

    /// Calculates the initial clip (for opening the menu) or final clip (for closing
    /// it), and applies it. This allows us to animate from or to the correct point,
    /// that is, the point it's aligned to in the "for" element.
    void _applyClip(final num height,final num width) {

        if (element.classes.contains(_cssClasses.UNALIGNED)) {
            // Do not clip.
            element.style.clip = '';

        } else if (element.classes.contains(_cssClasses.BOTTOM_RIGHT)) {
            // Clip to the top right corner of the menu.
            element.style.clip = 'rect(0 ${width}px 0 ${width}px)';

        } else if (element.classes.contains(_cssClasses.TOP_LEFT)) {
            // Clip to the bottom left corner of the menu.
            element.style.clip = 'rect(${height}px 0 ${height}px 0)';

        } else if (element.classes.contains(_cssClasses.TOP_RIGHT)) {
            // Clip to the bottom right corner of the menu.
            element.style.clip = 'rect(${height}px ${width}px ${height}px ${width}px)';

        } else {
            // Default: do not clip (same as clipping to the top left corner).
            element.style.clip = '';
        }
    }

    /// Adds an event listener to clean up after the animation ends.
    void _addAnimationEndListener() {

        /// Cleanup function to remove animation listeners.
        final _removeAnimationEndListener = (_) {
            if(_animationStream != null) {
                _animationStream.cancel();
                _animationStream = null;
            }
            element.classes.remove(_cssClasses.IS_ANIMATING);
        };

        // Remove animation class once the transition is done.
        _animationStream = element.onTransitionEnd.listen(_removeAnimationEndListener);
    }
}

