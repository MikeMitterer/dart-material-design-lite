part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialSliderCssClasses {

    final String WSK_SLIDER_IE_CONTAINER = 'wsk-slider__ie-container';

    final String WSK_SLIDER_CONTAINER = 'wsk-slider__container';

    final String WSK_SLIDER_BACKGROUND_FLEX = 'wsk-slider__background-flex';

    final String WSK_SLIDER_BACKGROUND_LOW = 'wsk-slider__background-lower';

    final String WSK_SLIDER_BACKGROUND_UP = 'wsk-slider__background-upper';

    final String IS_LOWEST_VALUE = 'is-lowest-value';
    const _MaterialSliderCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialSliderConstant {
    const _MaterialSliderConstant();
}

/// creates WskConfig for MaterialSlider
WskConfig materialSliderConfig() => new WskWidgetConfig<MaterialSlider>(
    "wsk-js-slider", (final html.HtmlElement element) => new MaterialSlider.fromElement(element));

/// registration-Helper
void registerMaterialSlider() => componenthandler.register(materialSliderConfig());

class MaterialSlider extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialSlider');

    static const _MaterialSliderConstant _constant = const _MaterialSliderConstant();
    static const _MaterialSliderCssClasses _cssClasses = const _MaterialSliderCssClasses();

    // Browser feature detection.
    final bool _isIE = false; // browser.isIe;

    html.DivElement _backgroundLower = null;
    html.DivElement _backgroundUpper = null;

    MaterialSlider.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialSlider widget(final html.HtmlElement element) => wskComponent(element) as MaterialSlider;

    html.RangeInputElement get slider => super.element as html.RangeInputElement;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialSlider - init");

        if (element != null) {
            if (_isIE) {

                // Since we need to specify a very large height in IE due to
                // implementation limitations, we add a parent here that trims it down to
                // a reasonable size.
                final html.DivElement containerIE = new html.DivElement();
                containerIE.classes.add(_cssClasses.WSK_SLIDER_IE_CONTAINER);
                element.parent.insertBefore(containerIE, element);
                element.remove();
                containerIE.append(element);

            } else {
                // For non-IE browsers, we need a div structure that sits behind the
                // slider and allows us to style the left and right sides of it with
                // different colors.

                final html.DivElement container = new html.DivElement();
                container.classes.add(_cssClasses.WSK_SLIDER_CONTAINER);
                element.parent.insertBefore(container, element);
                element.remove();
                container.append(element);

                final html.DivElement backgroundFlex = new html.DivElement();
                backgroundFlex.classes.add(_cssClasses.WSK_SLIDER_BACKGROUND_FLEX);
                container.append(backgroundFlex);

                _backgroundLower = new html.DivElement();
                _backgroundLower.classes.add(_cssClasses.WSK_SLIDER_BACKGROUND_LOW);
                backgroundFlex.append(_backgroundLower);

                _backgroundUpper = new html.DivElement();
                _backgroundUpper.classes.add(_cssClasses.WSK_SLIDER_BACKGROUND_UP);
                backgroundFlex.append(_backgroundUpper);
            }

            element.onInput.listen( _onInput );

            element.onChange.listen( _onChange );

            element.onMouseUp.listen( _onMouseUp );

            _updateValue();
            element.classes.add('is-upgraded');
        }
    }

    /// Handle input on element.
    void _onInput(final html.Event event) {
        _updateValue();
    }

    /// Handle change on element.
    void _onChange(final html.Event event) {
        _updateValue();
    }

    /// Handle mouseup on element.
    void _onMouseUp(final html.MouseEvent event) {
        element.blur();
    }

    /// Handle updating of values.
    void _updateValue() {

        // Calculate and apply percentages to div structure behind slider.
        final num fraction = (int.parse(slider.value) - int.parse(slider.min)) /
        (int.parse(slider.max) - int.parse(slider.min));

        if (fraction == 0) {
            element.classes.add(_cssClasses.IS_LOWEST_VALUE);

        } else {
            element.classes.remove(_cssClasses.IS_LOWEST_VALUE);
        }

        if (! _isIE ) {
            _backgroundLower.style.flex = fraction.toString();
            _backgroundUpper.style.flex = (1 - fraction).toString();
        }
    }
}

