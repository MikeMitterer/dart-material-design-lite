part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialButtonCssClasses {

    final String RIPPLE_EFFECT =      'wsk-js-ripple-effect';
    final String RIPPLE_CONTAINER =   'wsk-button__ripple-container';
    final String RIPPLE =             'wsk-ripple';

    const _MaterialButtonCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialButtonConstant { const _MaterialButtonConstant(); }

/// creates WskConfig for MaterialButton
WskConfig materialButtonConfig() => new WskConfig<MaterialButton>(
    "wsk-js-button",(final html.HtmlElement element) => new MaterialButton(element));

/// registration-Helper
void registerMaterialButton() => componenthandler.register(materialButtonConfig());

class MaterialButton extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialButton');

    static const _MaterialButtonConstant _constant = const _MaterialButtonConstant();
    static const _MaterialButtonCssClasses _cssClasses = const _MaterialButtonCssClasses();

    MaterialButton(final html.HtmlElement element) : super(element) {
        _logger.fine("MaterialButton - CTOR");
        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialButton - init");

        if(element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
            final html.SpanElement rippleContainer = new html.Element.span();
            rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);

            final html.SpanElement ripple = new html.Element.span();
            ripple.classes.add(_cssClasses.RIPPLE);
            rippleContainer.append(ripple);

            ripple.onMouseUp.listen(_blurHandler);
            element.append(rippleContainer);

            _logger.fine("MaterialButton - init done...");
        }

        element.onMouseUp.listen(_blurHandler);

        element.onMouseLeave.listen(_blurHandler);
    }

    void _blurHandler(final html.MouseEvent event) {
        _logger.fine("blur...");
        element.blur();
    }
}

