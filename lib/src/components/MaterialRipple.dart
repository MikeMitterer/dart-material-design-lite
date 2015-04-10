part of mdlcomponents;

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialRippleCssClasses {
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
    "mdl-js-ripple-effect",(final html.HtmlElement element) => new MaterialRipple.fromElement(element));

    config.priority = 10;
    return config;
}

/// registration-Helper
void registerMaterialRipple() => componenthandler.register(materialRippleConfig());

class MaterialRipple extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialRipple');

    static const _MaterialRippleConstant _constant = const _MaterialRippleConstant();
    static const _MaterialRippleCssClasses _cssClasses = const _MaterialRippleCssClasses();

    html.HtmlElement _rippleElement = null;
    bool _recentering = false;
    int _frameCount = 0;
    int _rippleSize = 0;
    int _x = 0;
    int _y = 0;

    // Touch start produces a compat mouse down event, which would cause a
    // second ripples. To avoid that, we use this property to ignore the first
    // mouse down after a touch start.
    bool _ignoringMouseDown = false;

    MaterialRipple.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialRipple widget(final html.HtmlElement element) => mdlComponent(element) as MaterialRipple;

    html.HtmlElement get rippleElement {
        if(_rippleElement == null) {
            _rippleElement = element.querySelector(".${_cssClasses.MDL_RIPPLE}");
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

            _updateDimension();

            element.onMouseDown.listen(_downHandler);
            element.onTouchStart.listen(_downHandler);

            // .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);
            element.onMouseUp.listen( _upHandler);

            // .addEventListener('mouseleave', -- .onMouseLeave.listen(<MouseEvent>);
            element.onMouseLeave.listen( _upHandler);
            element.onTouchEnd.listen( _upHandler);

            // .addEventListener('blur', -- .onBlur.listen(<Event>);
            element.onBlur.listen( _upHandler);
        }
    }

    void _downHandler(final html.Event event) {
        //event.preventDefault();
        //event.stopPropagation();

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
            if (event == html.MouseEvent &&
                (event as html.MouseEvent).client.x == 0 && (event as html.MouseEvent).client.y == 0) {

                x = ((bound.width / 2) as double).round();
                y = ((bound.height / 2) as double).round();

            } else {

                int clientX;
                int clientY;

                if(event is html.MouseEvent) {

                    clientX = (event as html.MouseEvent).client.x;
                    clientY = (event as html.MouseEvent).client.y;

                } else if(event is html.TouchEvent) {

                    clientX = (event as html.TouchEvent).touches.first.client.x;
                    clientY = (event as html.TouchEvent).touches.first.client.y;

                } else {
                    throw "$event must bei either MouseEvent or TouchEvent!";
                }

                x = ((clientX - bound.left) as double).round();
                y = ((clientY - bound.top) as double).round();
            }

            //
            _updateDimension();
            _setRippleXY(x, y);
            _setRippleStyles(true);

            html.window.requestAnimationFrame(_animFrameHandler);
        }
    }

    /// Handle mouse / finger up on element.
    /// @param {Event} event The event that fired.
    /// MaterialRipple.prototype.upHandler_ = function(event) {
    void _upHandler(final html.Event event) {

        // Don't fire for the artificial "mouseup" generated by a double-click.
        //if (event != null && event is event.detail != 2) {
            _rippleElement.classes.remove(_cssClasses.IS_VISIBLE);
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
            //String size;
            String offset = "translate(${_x}px,${_y}px)";

            if (start) {
                scale = _constant.INITIAL_SCALE;
                // size = _constant.INITIAL_SIZE;
            } else {
                scale = _constant.FINAL_SCALE;
                // size = "${_rippleSize}px";
                if (_recentering) {
                    offset = "translate(${bound.width / 2}px, ${bound.height / 2}'px)";
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
            html.window.requestAnimationFrame(_animFrameHandler);
        }
        else {
            _setRippleStyles(false);
        }
    }
}
