part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialSpinnerCssClasses {

    final String WSK_SPINNER_LAYER = 'wsk-spinner__layer';
    final String WSK_SPINNER_CIRCLE_CLIPPER = 'wsk-spinner__circle-clipper';
    final String WSK_SPINNER_CIRCLE = 'wsk-spinner__circle';
    final String WSK_SPINNER_GAP_PATCH = 'wsk-spinner__gap-patch';
    final String WSK_SPINNER_LEFT = 'wsk-spinner__left';
    final String WSK_SPINNER_RIGHT = 'wsk-spinner__right';

    const _MaterialSpinnerCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialSpinnerConstant {
    final int WSK_SPINNER_LAYER_COUNT = 4;

    const _MaterialSpinnerConstant();
}

/// creates WskConfig for MaterialSpinner
WskConfig materialSpinnerConfig() => new WskConfig<MaterialSpinner>(
    "wsk-js-spinner", (final html.HtmlElement element) => new MaterialSpinner(element));

/// registration-Helper
void registerMaterialSpinner() => componenthandler.register(materialSpinnerConfig());

class MaterialSpinner extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialSpinner');

    static const _MaterialSpinnerConstant _constant = const _MaterialSpinnerConstant();
    static const _MaterialSpinnerCssClasses _cssClasses = const _MaterialSpinnerCssClasses();

    MaterialSpinner(final html.HtmlElement element) : super(element) {
        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialSpinner - init");

        if (element != null) {

            for (int i = 1; i <= _constant.WSK_SPINNER_LAYER_COUNT; i++) {
                _createLayer(i);
            }

            //_start();
            element.classes.add('is-upgraded');
        }
    }

    /// Auxiliary method to create a spinner layer.
    void _createLayer(final int index) {

        final html.DivElement layer = new html.DivElement();
        layer.classes.add(_cssClasses.WSK_SPINNER_LAYER);
        layer.classes.add(_cssClasses.WSK_SPINNER_LAYER + '-' + index.toString());

        final html.DivElement leftClipper = new html.DivElement();
        leftClipper.classes.add(_cssClasses.WSK_SPINNER_CIRCLE_CLIPPER);
        leftClipper.classes.add(_cssClasses.WSK_SPINNER_LEFT);

        final html.DivElement gapPatch = new html.DivElement();
        gapPatch.classes.add(_cssClasses.WSK_SPINNER_GAP_PATCH);

        final html.DivElement rightClipper = new html.DivElement();
        rightClipper.classes.add(_cssClasses.WSK_SPINNER_CIRCLE_CLIPPER);
        rightClipper.classes.add(_cssClasses.WSK_SPINNER_RIGHT);

        final circleOwners = [leftClipper, gapPatch, rightClipper];

        for (int i = 0; i < circleOwners.length; i++) {

            final circle = new html.DivElement();
            circle.classes.add(_cssClasses.WSK_SPINNER_CIRCLE);
            circleOwners[i].append(circle);
        }

        layer.append(leftClipper);
        layer.append(gapPatch);
        layer.append(rightClipper);

        element.append(layer);
    }

    /// Stops the spinner animation.
    void _stop() {
        element.classes.remove('is-active');
    }

    /// Starts the spinner animation.
    void _start() {
        element.classes.add('is-active');
    }

}

