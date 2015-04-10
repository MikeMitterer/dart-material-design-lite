part of mdldemo;

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

/// creates MdlConfig for DemoAnimation
MdlConfig demoAnimationConfig() => new MdlWidgetConfig<DemoAnimation>(
    "demo-js-animation", (final html.HtmlElement element) => new DemoAnimation.fromElement(element));

/// registration-Helper
void registerDemoAnimation() => componenthandler.register(demoAnimationConfig());

/**
 * Sample:
 *   <div class="demo-preview-block demo-animation demo-js-animation">
 *       <div class="demo-animation__container">
 *           <div class="demo-animation__container-background">Click me to animate</div>
 *           <div class="demo-animation__container-foreground"></div>
 *           <div class="demo-animation__movable demo-animation--position-1 mdl-shadow--z1"></div>
 *       </div>
 *   </div>
*/
class DemoAnimation extends MdlComponent {
    final Logger _logger = new Logger('mdl.DemoAnimation');

    static const _DemoAnimationConstant _constant = const _DemoAnimationConstant();
    static const _DemoAnimationCssClasses _cssClasses = const _DemoAnimationCssClasses();

    int _position = _constant.STARTING_POSITION;
    html.HtmlElement _moveable = null;

    DemoAnimation.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static DemoAnimation widget(final html.HtmlElement element) => mdlComponent(element) as DemoAnimation;

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

