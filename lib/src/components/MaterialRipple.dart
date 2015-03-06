part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialRippleCssClasses {
    final String WSK_RIPPLE_CENTER                  = 'wsk-ripple--center';
    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';
    final String WSK_RIPPLE                         = 'wsk-ripple';
    final String IS_ANIMATING                       = 'is-animating';

    const _MaterialRippleCssClasses();}

/// Store constants in one place so they can be updated easily.
class _MaterialRippleConstant {
    final String INITIAL_SCALE      = 'scale(0.0001, 0.0001)';
    final String INITIAL_SIZE       = '1px';
    final String INITIAL_OPACITY    = '0.4';
    final String FINAL_OPACITY      = '0';
    final String FINAL_SCALE        = '';

    const _MaterialRippleConstant(); }

/// creates WskConfig for MaterialRipple
WskConfig materialRippleConfig() {
    final WskConfig<MaterialRipple> config = new WskConfig<MaterialRipple>(
    "wsk-js-ripple-effect",(final html.HtmlElement element) => new MaterialRipple(element));

    config.priority = 10;
    return config;
}

/// registration-Helper
void registerMaterialRipple() => componenthandler.register(materialRippleConfig());

class MaterialRipple extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialRipple');

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

    MaterialRipple(final html.HtmlElement element) : super(element) {
        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialRipple - init");

        _recentering = element.classes.contains(_cssClasses.WSK_RIPPLE_CENTER);
        if(!element.classes.contains(_cssClasses.WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS)) {

            _updateDimension();

            element.onMouseDown.listen(_downHandler);
            element.onTouchStart.listen(_downHandler);
        }
    }

    html.HtmlElement get rippleElement {
        if(_rippleElement == null) {
            _rippleElement = element.querySelector(".${_cssClasses.WSK_RIPPLE}");
        }
        return _rippleElement;
    }

    Math.Rectangle get bound => element.getBoundingClientRect();

    void _setRippleXY(final int newX,final int newY) { _x = newX; _y = newY; }

    void _updateDimension() {
        if (rippleElement != null) {
            _rippleSize = (Math.max(bound.width, bound.height) * 2).toInt();
            rippleElement.style.width = "${_rippleSize}px";
            rippleElement.style.height = "${_rippleSize}px";
        }
    }

    void _downHandler(final html.UIEvent event) {
        //event.preventDefault();
        //event.stopPropagation();

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

            bool _isKeyboardClick() {
                return (event is html.TouchEvent ||
                ((event as html.MouseEvent).client.x == 0 && (event as html.MouseEvent).client.y == 0));
            }

            // Check if we are handling a keyboard click.
            if (_isKeyboardClick()) {
                x = (bound.width / 2).round();
                y = (bound.height / 2).round();

            }
            else {
                Math.Point _getPoint() {
                    if(event is html.MouseEvent) {
                        return (event as html.MouseEvent).client;
                    } else {
                        return (event as html.TouchEvent).touches[0].client;
                    }
                }
                final Math.Point client = _getPoint();
                x = (client.x - bound.left).round();
                y = (client.y - bound.top).round();
            }

            _updateDimension();
            _setRippleXY(x, y);
            _setRippleStyles(true);

            html.window.requestAnimationFrame(_animFrameHandler);
            // new Future.delayed(new Duration(milliseconds: 50), () {
            //    _setRippleStyles(false);
            // }).then((_) => _frameCount = 0);
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
                rippleElement.style.opacity = _constant.INITIAL_OPACITY;
                rippleElement.classes.remove(_cssClasses.IS_ANIMATING);
            } else {
                rippleElement.style.opacity = _constant.FINAL_OPACITY;
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
