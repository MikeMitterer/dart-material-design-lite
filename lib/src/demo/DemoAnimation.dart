part of wskdemo;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _DemoAnimationCssClasses {

    final String MOVABLE   = 'demo-animation__movable';
    final String POSITION_PREFIX   = 'demo-animation--position-';

    const _DemoAnimationCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _DemoAnimationConstant {

    final int STARTING_POSITION = 1;

    const _DemoAnimationConstant(); }

/// creates WskConfig for DemoAnimation
WskConfig demoAnimationConfig() => new WskConfig<DemoAnimation>(
    "demo-js-animation", (final html.HtmlElement element) => new DemoAnimation(element));

/// registration-Helper
void registerDemoAnimation() => componenthandler.register(demoAnimationConfig());

class DemoAnimation extends WskComponent {
    final Logger _logger = new Logger('wskdemo.DemoAnimation');

    static const _DemoAnimationConstant _constant = const _DemoAnimationConstant();
    static const _DemoAnimationCssClasses _cssClasses = const _DemoAnimationCssClasses();

    int _position = _constant.STARTING_POSITION;
    html.HtmlElement _moveable = null;

    DemoAnimation(final html.HtmlElement element) : super(element) {
        _init();
    }

    html.HtmlElement get movable {
        if(_moveable == null) {
            _moveable = html.querySelector(".${_cssClasses.MOVABLE}");
        }
        return _moveable;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("DemoAnimation - init");

        if(movable == null) {
            _logger.severe('Was expecting to find an element with class name ' +
            '${_cssClasses.MOVABLE} in side of: ${element}');
            return;
        }
        element.onClick.listen(_handleClick);
    }

    void _handleClick(final html.MouseEvent event) {
        movable.classes.remove("${_cssClasses.POSITION_PREFIX}${_position}");
        _position++;

        if (_position > 6) {
            _position = 1;
        }
        movable.classes.add("${_cssClasses.POSITION_PREFIX}${_position}");
    }
}

