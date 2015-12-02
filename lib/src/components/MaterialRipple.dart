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
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialRippleCssClasses {

    static const String MAIN_CLASS                  = "mdl-js-ripple-effect";

    final String MDL_RIPPLE_CENTER                  = 'mdl-ripple--center';
    final String MDL_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
    final String MDL_RIPPLE                         = 'mdl-ripple';

    final String IS_ANIMATING                       = 'is-animating';
    final String IS_VISIBLE                         = 'is-visible';

    const _MaterialRippleCssClasses();}

/// Store constants in one place so they can be updated easily.
class _MaterialRippleConstant {
    final String INITIAL_SCALE      = 'scale(0.0001, 0.0001)';
    final String INITIAL_SIZE       = '1px';
    final String INITIAL_OPACITY    = '0.4';
    final String FINAL_OPACITY      = '0';
    final String FINAL_SCALE        = '';

    const _MaterialRippleConstant(); }

/// creates MdlConfig for MaterialRipple
/// Important!!!! Ripple uses MdlConfig and not MdlWidgetConfig
MdlConfig materialRippleConfig() {
    final MdlConfig<MaterialRipple> config = new MdlConfig<MaterialRipple>(
        _MaterialRippleCssClasses.MAIN_CLASS,
            (final dom.HtmlElement element, final di.Injector injector)
            => new MaterialRipple.fromElement(element, injector));

    config.priority = 10;
    return config;
}

/// registration-Helper
void registerMaterialRipple() => componentHandler().register(materialRippleConfig());

class MaterialRipple extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialRipple');

    static const _MaterialRippleConstant _constant = const _MaterialRippleConstant();
    static const _MaterialRippleCssClasses _cssClasses = const _MaterialRippleCssClasses();

    dom.HtmlElement _rippleElement = null;
    bool _recentering = false;
    int _frameCount = 0;
    int _rippleSize = 0;
    int _x = 0;
    int _y = 0;
    int _boundHeight = 0;
    int _boundWidth = 0;

    // Touch start produces a compat mouse down event, which would cause a
    // second ripples. To avoid that, we use this property to ignore the first
    // mouse down after a touch start.
    bool _ignoringMouseDown = false;

    bool _initialized = false;

    MaterialRipple.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialRipple widget(final dom.HtmlElement element) => mdlComponent(element,MaterialRipple) as MaterialRipple;

    dom.HtmlElement get rippleElement {
        if(_rippleElement == null) {
            _rippleElement = element.querySelector(".${_cssClasses.MDL_RIPPLE}");
            if(_rippleElement == null && _initialized == true && visualDebugging == true) {
                _logger.warning("No child found with ${_cssClasses.MDL_RIPPLE} in ${element}");
                element.style.border = "1px solid red";
            }
        }
        return _rippleElement;
    }

    Math.Rectangle get bound => element.getBoundingClientRect();

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialRipple - init");

        _recentering = element.classes.contains(_cssClasses.MDL_RIPPLE_CENTER);
        if(!element.classes.contains(_cssClasses.MDL_JS_RIPPLE_EFFECT_IGNORE_EVENTS)) {

            _frameCount = 0;
            _rippleSize = 0;
            _x = 0;
            _y = 0;

            // Touch start produces a compat mouse down event, which would cause a
            // second ripples. To avoid that, we use this property to ignore the first
            // mouse down after a touch start.
            _ignoringMouseDown = false;

            //_updateDimension();

            eventStreams.add(element.onMouseDown.listen(_downHandler));
            eventStreams.add(element.onTouchStart.listen(_downHandler));

            // .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
            eventStreams.add(element.onMouseUp.listen( _upHandler));

            // .addEventListener('mouseleave', -- .onMouseLeave.listen(<MouseEvent>);
            eventStreams.add(element.onMouseLeave.listen( _upHandler));
            eventStreams.add(element.onTouchEnd.listen( _upHandler));

            // .addEventListener('blur', -- .onBlur.listen(<Event>);
            eventStreams.add(element.onBlur.listen( _upHandler));
        }
        _initialized = true;
    }

    void _downHandler(final dom.Event event) {
        //event.preventDefault();
        //event.stopPropagation();

        bool _hasRipple(final dom.Element element) {
            if(element is dom.HtmlElement == false) { return false; }

            final dom.Element child = element.firstChild;
            return element.classes.contains(_cssClasses.MDL_RIPPLE) ||
            (child != null && child is dom.HtmlElement && child.classes.contains(_cssClasses.MDL_RIPPLE));
        }

        final bool hasRipple = _hasRipple(event.target);
        if(!hasRipple) {
            return;
        }

        if (rippleElement.style.width == null && rippleElement.style.height == null) {

            final dom.Rectangle rect = bound;
            _boundHeight = rect.height;
            _boundWidth = rect.width;
            _rippleSize = (Math.sqrt(rect.width * rect.width + rect.height * rect.height) * 2 + 2).toInt();
            rippleElement.style.width = "${_rippleSize}px";
            rippleElement.style.height = "${_rippleSize}px";

        }
        
        rippleElement.classes.add(_cssClasses.IS_VISIBLE);

        if (event.type == 'mousedown' && _ignoringMouseDown) {
            _ignoringMouseDown = false;

        }
        else {
            if (event.type == 'touchstart') {
                _ignoringMouseDown = true;
            }

            if (_frameCount > 0) {
                return;
            }
            _frameCount = 1;

            int x;
            int y;

            // Check if we are handling a keyboard click.
            if (event == dom.MouseEvent &&
                (event as dom.MouseEvent).client.x == 0 && (event as dom.MouseEvent).client.y == 0) {

                x = ((bound.width / 2) as double).round();
                y = ((bound.height / 2) as double).round();

            } else {

                int clientX;
                int clientY;

                if(event is dom.MouseEvent) {

                    clientX = event.client.x;
                    clientY = event.client.y;

                } else if(event is dom.TouchEvent) {

                    clientX = event.touches.first.client.x;
                    clientY = event.touches.first.client.y;

                } else {
                    throw "$event must bei either MouseEvent or TouchEvent!";
                }

                x = (clientX - bound.left).round();
                y = (clientY - bound.top).round();
            }

            //_logger.info("X $x Y $y ${bound} ${event.target} T ${hasRipple}");

            if(hasRipple) {
                _updateDimension();
                _setRippleXY(x, y);
                _setRippleStyles(true);

                dom.window.requestAnimationFrame(_animFrameHandler);
            }
        }
    }

    /// Handle mouse / finger up on element.
    /// @param {Event} event The event that fired.
    /// MaterialRipple.prototype.upHandler_ = function(event) {
    void _upHandler(final dom.Event event) {

        // Don't fire for the artificial "mouseup" generated by a double-click.
        //if (event != null && event is event.detail != 2) {
        if(_rippleElement != null) {

            // Allow a repaint to occur before removing this class, so the animation
            // shows for tap events, which seem to trigger a mouseup too soon after
            // mousedown.
            new Future(() {
                _rippleElement.classes.remove(_cssClasses.IS_VISIBLE);
            });

        }
        //}
    }


    void _setRippleXY(final int newX,final int newY) { _x = newX; _y = newY; }

    /// Necessary if element is hidden when page is diplayed
    void _updateDimension() {
        if (rippleElement != null) {
            _rippleSize = (Math.sqrt(bound.width * bound.width + bound.height * bound.height) * 2 + 2).toInt();
            _rippleElement.style.width = "${_rippleSize}px";
            _rippleElement.style.height = "${_rippleSize}px";
        }
    }

    void _setRippleStyles(final bool start) {
        if (rippleElement != null) {
            String transformString;
            String scale;
            String offset = "translate(${_x}px,${_y}px)";

            if (start) {
                scale = _constant.INITIAL_SCALE;
            } else {
                scale = _constant.FINAL_SCALE;
                if (_recentering) {
                    offset = "translate(${_boundWidth / 2}px, ${_boundHeight / 2}'px)";
                }
            }

            transformString = 'translate(-50%, -50%) ' + offset + scale;

            rippleElement.style.transform = transformString;

            if (start) {
                rippleElement.classes.remove(_cssClasses.IS_ANIMATING);
            } else {
                rippleElement.classes.add(_cssClasses.IS_ANIMATING);
            }
        }
    }

    void _animFrameHandler(_) {
        if (this._frameCount-- > 0) {
            dom.window.requestAnimationFrame(_animFrameHandler);
        }
        else {
            _setRippleStyles(false);
        }
    }
}
