part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialAnimationCssClasses {

    final String DEMO_JS_MOVABLE_AREA   = 'demo-js-movable-area';
    final String DEMO_POSITION_PREFIX   = 'demo-position-';

    const _MaterialAnimationCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialAnimationConstant {

    final int STARTING_POSITION = 1;

    const _MaterialAnimationConstant(); }

/// creates WskConfig for MaterialAnimation
WskConfig materialAnimationConfig() => new WskConfig<MaterialAnimation>(
    "demo-js-clickable-area", (final html.HtmlElement element) => new MaterialAnimation(element));

/// registration-Helper
void registerMaterialAnimation() => componenthandler.register(materialAnimationConfig());

class MaterialAnimation extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialAnimation');

    static const _MaterialAnimationConstant _constant = const _MaterialAnimationConstant();
    static const _MaterialAnimationCssClasses _cssClasses = const _MaterialAnimationCssClasses();

    int _position = _constant.STARTING_POSITION;
    html.HtmlElement _moveable = null;

    MaterialAnimation(final html.HtmlElement element) : super(element) {
        _init();
    }

    html.HtmlElement get moveable {
        if(_moveable == null) {
            _moveable = html.querySelector(".${_cssClasses.DEMO_JS_MOVABLE_AREA}");
        }
        return _moveable;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialAnimation - init");

        if(moveable == null) {
            _logger.severe('Was expecting to find an element with class ' +
            'name .demo-js-movable-area in side of: ${element}');
            return;
        }
        element.onClick.listen(_handleClick);
    }

    void _handleClick(final html.MouseEvent event) {
        moveable.classes.remove("${_cssClasses.DEMO_POSITION_PREFIX}${_position}");
        _position++;

        if (_position > 6) {
            _position = 1;
        }
        moveable.classes.add("${_cssClasses.DEMO_POSITION_PREFIX}${_position}");
    }
}

