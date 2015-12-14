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

/// Class constructor for dropdown MDL component.
/// Implements MDL component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// 
/// constructor
/// param {HTMLElement} element The element that will be upgraded.

  final MaterialMenu = function MaterialMenu(element) {

    // Initialize instance.
    init();
  }
  window['MaterialMenu'] = MaterialMenu;

/// Store constants in one place so they can be updated easily.
/// 
/// enum {string | number}
class _  MaterialMenuConstant {
    // Total duration of the menu animation.
      final int TRANSITION_DURATION_SECONDS = 0;
    // The fraction of the total duration we want to use for menu item animations.
      final int TRANSITION_DURATION_FRACTION = 0;
    // How long the menu stays open after choosing an option (so the user can see
    // the ripple).
      final int CLOSE_TIMEOUT = 150;
  }

/// Keycodes, for code readability.
/// 
/// enum {number}
  MaterialMenu.prototype.Keycodes_ = {
      final int ENTER = 13;
      final int ESCAPE = 27;
      final int SPACE = 32;
      final int UP_ARROW = 38;
      final int DOWN_ARROW = 40;
  }

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// 
/// enum {string}
class _  MaterialMenuCssClasses {
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
  }

/// Initialize element.
///   MaterialMenu.prototype.init = /*function*/ () {
void init() {
    if (element != null) {
      // Create container for the menu.

      final container = new html.DivElement();
      container.classes.add(_cssClasses.CONTAINER);
      element.parent.insertBefore(container, element);
      element.parent.removeChild(element);
      container.append(element);
      _container = container;

      // Create outline for the menu (shadow and background).

      final outline = new html.DivElement();
      outline.classes.add(_cssClasses.OUTLINE);
      _outline = outline;
      container.insertBefore(outline, element);

      // Find the "for" element and bind events to it.

      final forElId = element.getAttribute('for') ||
                      element.getAttribute('data-mdl-for');

      final forEl = null;
      if (forElId) {
        forEl = html.document.getElementById(forElId);
        if (forEl) {
          _forElement = forEl;

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
          forEl.onClick.listen( _handleForClick);
          forEl.addEventListener('keydown',
              _handleForKeyboardEvent);
        }
      }

      final items = element.querySelectorAll('.' + _cssClasses.ITEM);
      _boundItemKeydown = _handleItemKeyboardEvent;
      _boundItemClick = _handleItemClick;

      for (final i = 0; i < items.length; i++) {
        // Add a listener to each menu item.

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
        items[i].onClick.listen( _boundItemClick);
        // Add a tab index to each menu item.
        items[i].tabIndex = '-1';
        // Add a keyboard listener to each menu item.
        items[i].addEventListener('keydown', _boundItemKeydown);
      }

      // Add ripple classes to each item, if the user has enabled ripples.
      if (element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
        element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

        for (i = 0; i < items.length; i++) {

          final item = items[i];

          final rippleContainer = new html.SpanElement();
          rippleContainer.classes.add(_cssClasses.ITEM_RIPPLE_CONTAINER);

          final ripple = new html.SpanElement();
          ripple.classes.add(_cssClasses.RIPPLE);
          rippleContainer.append(ripple);

          item.append(rippleContainer);
          item.classes.add(_cssClasses.RIPPLE_EFFECT);
        }
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

      container.classes.add(_cssClasses.IS_UPGRADED);
    }
  }

/// Handles a click on the "for" element, by positioning the menu and then
/// toggling it.
/// 
/// param {Event} evt The event that fired.
///   MaterialMenu.prototype.handleForClick_ = function(evt) {
void _handleForClick(final evt) {
    if (element && _forElement) {

      final rect = _forElement.getBoundingClientRect();

      final forRect = _forElement.parent.getBoundingClientRect();

      if (element.classes.contains(_cssClasses.UNALIGNED)) {
        // Do not position the menu automatically. Requires the developer to
        // manually specify position.
      } else if (element.classes.contains(
          _cssClasses.BOTTOM_RIGHT)) {
        // Position below the "for" element, aligned to its right.
        _container.style.right = (forRect.right - rect.right) + 'px';
        _container.style.top =
            _forElement.offsetTop + _forElement.offsetHeight + 'px';
      } else if (element.classes.contains(_cssClasses.TOP_LEFT)) {
        // Position above the "for" element, aligned to its left.
        _container.style.left = _forElement.offsetLeft + 'px';
        _container.style.bottom = (forRect.bottom - rect.top) + 'px';
      } else if (element.classes.contains(_cssClasses.TOP_RIGHT)) {
        // Position above the "for" element, aligned to its right.
        _container.style.right = (forRect.right - rect.right) + 'px';
        _container.style.bottom = (forRect.bottom - rect.top) + 'px';

      } else {
        // Default: position below the "for" element, aligned to its left.
        _container.style.left = _forElement.offsetLeft + 'px';
        _container.style.top =
            _forElement.offsetTop + _forElement.offsetHeight + 'px';
      }
    }

    toggle(evt);
  }

/// Handles a keyboard event on the "for" element.
/// 
/// param {Event} evt The event that fired.
///   MaterialMenu.prototype.handleForKeyboardEvent_ = function(evt) {
void _handleForKeyboardEvent(final evt) {
    if (element && _container && _forElement) {

      final items = element.querySelectorAll('.' + _cssClasses.ITEM +
        ':not([disabled])');

      if (items && items.length > 0 &&
          _container.classes.contains(_cssClasses.IS_VISIBLE)) {
        if (evt.keyCode == _Keycodes.UP_ARROW) {
          evt.preventDefault();
          items[items.length - 1].focus();
        } else if (evt.keyCode == _Keycodes.DOWN_ARROW) {
          evt.preventDefault();
          items[0].focus();
        }
      }
    }
  }

/// Handles a keyboard event on an item.
/// 
/// param {Event} evt The event that fired.
///   MaterialMenu.prototype.handleItemKeyboardEvent_ = function(evt) {
void _handleItemKeyboardEvent(final evt) {
    if (element && _container) {

      final items = element.querySelectorAll('.' + _cssClasses.ITEM +
        ':not([disabled])');

      if (items && items.length > 0 &&
          _container.classes.contains(_cssClasses.IS_VISIBLE)) {

        final currentIndex = Array.prototype.slice.call(items).indexOf(evt.target);

        if (evt.keyCode == _Keycodes.UP_ARROW) {
          evt.preventDefault();
          if (currentIndex > 0) {
            items[currentIndex - 1].focus();

          } else {
            items[items.length - 1].focus();
          }
        } else if (evt.keyCode == _Keycodes.DOWN_ARROW) {
          evt.preventDefault();
          if (items.length > currentIndex + 1) {
            items[currentIndex + 1].focus();

          } else {
            items[0].focus();
          }
        } else if (evt.keyCode == _Keycodes.SPACE ||
              evt.keyCode == _Keycodes.ENTER) {
          evt.preventDefault();
          // Send mousedown and mouseup to trigger ripple.

          final e = new MouseEvent('mousedown');
          evt.target.dispatchEvent(e);
          e = new MouseEvent('mouseup');
          evt.target.dispatchEvent(e);
          // Send click.
          evt.target.click();
        } else if (evt.keyCode == _Keycodes.ESCAPE) {
          evt.preventDefault();
          hide();
        }
      }
    }
  }

/// Handles a click event on an item.
/// 
/// param {Event} evt The event that fired.
///   MaterialMenu.prototype.handleItemClick_ = function(evt) {
void _handleItemClick(final evt) {
    if (evt.target.hasAttribute('disabled')) {
      evt.stopPropagation();

    } else {
      // Wait some time before closing menu, so the user can see the ripple.
      _closing = true;
      window.setTimeout(function(evt) {
        hide();
        _closing = false;
    }
  }

/// Calculates the initial clip (for opening the menu) or final clip (for closing
/// it), and applies it. This allows us to animate from or to the correct point,
/// that is, the point it's aligned to in the "for" element.
/// 
/// param {number} height Height of the clip rectangle
/// param {number} width Width of the clip rectangle
///   MaterialMenu.prototype.applyClip_ = function(height, width) {
void _applyClip(final height, width) {
    if (element.classes.contains(_cssClasses.UNALIGNED)) {
      // Do not clip.
      element.style.clip = '';
    } else if (element.classes.contains(_cssClasses.BOTTOM_RIGHT)) {
      // Clip to the top right corner of the menu.
      element.style.clip =
          'rect(0 ' + width + 'px ' + '0 ' + width + 'px)';
    } else if (element.classes.contains(_cssClasses.TOP_LEFT)) {
      // Clip to the bottom left corner of the menu.
      element.style.clip =
          'rect(' + height + 'px 0 ' + height + 'px 0)';
    } else if (element.classes.contains(_cssClasses.TOP_RIGHT)) {
      // Clip to the bottom right corner of the menu.
      element.style.clip = 'rect(' + height + 'px ' + width + 'px ' +
          height + 'px ' + width + 'px)';

    } else {
      // Default: do not clip (same as clipping to the top left corner).
      element.style.clip = '';
    }
  }

/// cleanup function to remove animation listeners.
/// 
/// param {Event} evt

///   MaterialMenu.prototype.removeAnimationEndListener_ = function(evt) {
void _removeAnimationEndListener(final evt) {
    evt.target.classes.remove(MaterialMenu.prototype._cssClasses.IS_ANIMATING);
  }

/// Adds an event listener to clean up after the animation ends.
/// 
///   MaterialMenu.prototype.addAnimationEndListener_ = /*function*/ () {
void _addAnimationEndListener() {
    element.addEventListener('transitionend', _removeAnimationEndListener);
    element.addEventListener('webkitTransitionEnd', _removeAnimationEndListener);
  }

/// Displays the menu.
/// 
/// public
///   MaterialMenu.prototype.show = function(evt) {
void show(final evt) {
    if (element && _container && _outline) {
      // Measure the inner element.

      final height = element.getBoundingClientRect().height;

      final width = element.getBoundingClientRect().width;

      // Apply the inner element's size to the container and outline.
      _container.style.width = width + 'px';
      _container.style.height = height + 'px';
      _outline.style.width = width + 'px';
      _outline.style.height = height + 'px';

      final transitionDuration = _constant.TRANSITION_DURATION_SECONDS *
          _constant.TRANSITION_DURATION_FRACTION;

      // Calculate transition delays for individual menu items, so that they fade
      // in one at a time.

      final items = element.querySelectorAll('.' + _cssClasses.ITEM);

      for (final i = 0; i < items.length; i++) {

        final itemDelay = null;
        if (element.classes.contains(_cssClasses.TOP_LEFT) ||
            element.classes.contains(_cssClasses.TOP_RIGHT)) {
          itemDelay = ((height - items[i].offsetTop - items[i].offsetHeight) /
              height * transitionDuration) + 's';

        } else {
          itemDelay = (items[i].offsetTop / height * transitionDuration) + 's';
        }
        items[i].style.transitionDelay = itemDelay;
      }

      // Apply the initial clip to the text before we start animating.
      _applyClip(height, width);

      // Wait for the next frame, turn on animation, and apply the final clip.
      // Also make it visible. This triggers the transitions.
      window.requestAnimationFrame( /*function*/ () {
        element.classes.add(_cssClasses.IS_ANIMATING);
        element.style.clip = 'rect(0 ' + width + 'px ' + height + 'px 0)';
        _container.classes.add(_cssClasses.IS_VISIBLE);
      });

      // Clean up after the animation is complete.
      _addAnimationEndListener();

      // Add a click listener to the document, to close the menu.

      final callback = function(e) {
        // Check to see if the document is processing the same event that
        // displayed the menu in the first place. If so, do nothing.
        // Also check to see if the menu is in the process of closing itself, and
        // do nothing in that case.
        // Also check if the clicked element is a menu item
        // if so, do nothing.
        if (e != evt && !_closing && e.target.parentNode != element) {
          document.removeEventListener('click', callback);
          hide();
        }
      };

	// .addEventListener('click', -> .onClick.listen(<MouseEvent>);
      document.onClick.listen( callback);
    }
  }
  MaterialMenu.prototype['show'] = MaterialMenu.prototype.show;

/// Hides the menu.
/// 
/// public
///   MaterialMenu.prototype.hide = /*function*/ () {
void hide() {
    if (element && _container && _outline) {

      final items = element.querySelectorAll('.' + _cssClasses.ITEM);

      // Remove all transition delays; menu items fade out concurrently.

      for (final i = 0; i < items.length; i++) {
        items[i].style.removeProperty('transition-delay');
      }

      // Measure the inner element.

      final rect = element.getBoundingClientRect();

      final height = rect.height;

      final width = rect.width;

      // Turn on animation, and apply the final clip. Also make invisible.
      // This triggers the transitions.
      element.classes.add(_cssClasses.IS_ANIMATING);
      _applyClip(height, width);
      _container.classes.remove(_cssClasses.IS_VISIBLE);

      // Clean up after the animation is complete.
      _addAnimationEndListener();
    }
  }
  MaterialMenu.prototype['hide'] = MaterialMenu.prototype.hide;

/// Displays or hides the menu, depending on current state.
/// 
/// public
///   MaterialMenu.prototype.toggle = function(evt) {
void toggle(final evt) {
    if (_container.classes.contains(_cssClasses.IS_VISIBLE)) {
      hide();

    } else {
      show(evt);
    }
  }
  MaterialMenu.prototype['toggle'] = MaterialMenu.prototype.toggle;

/// Downgrade the component.
/// 
///   MaterialMenu.prototype.mdlDowngrade_ = /*function*/ () {
void _mdlDowngrade() {

    final items = element.querySelectorAll('.' + _cssClasses.ITEM);

    for (final i = 0; i < items.length; i++) {
      items[i].removeEventListener('click', _boundItemClick);
      items[i].removeEventListener('keydown', _boundItemKeydown);
    }
  }

/// Public alias for the downgrade method.
/// 
/// public
  MaterialMenu.prototype.mdlDowngrade =
      MaterialMenu.prototype.mdlDowngrade_;

  MaterialMenu.prototype['mdlDowngrade'] =
      MaterialMenu.prototype.mdlDowngrade;

  // The component registers itself. It can assume componentHandler is available
//   // in the global scope.

//   componentHandler.register({
//     constructor: MaterialMenu,
//     classAsString: 'MaterialMenu',
//     cssClass: 'mdl-js-menu',
//     widget: true
//   });
// })();
