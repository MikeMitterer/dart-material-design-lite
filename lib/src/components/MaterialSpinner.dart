part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialSpinnerCssClasses {

    final String SPINNER_LAYER = 'wsk-spinner__layer';
    final String SPINNER_CIRCLE_CLIPPER = 'wsk-spinner__circle-clipper';
    final String SPINNER_CIRCLE = 'wsk-spinner__circle';
    final String SPINNER_GAP_PATCH = 'wsk-spinner__gap-patch';
    final String SPINNER_LEFT = 'wsk-spinner__left';
    final String SPINNER_RIGHT = 'wsk-spinner__right';

    final String IS_UPGRADED = 'is-upgraded';
    final String IS_ACTIVE = 'is-active';

    const _MaterialSpinnerCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialSpinnerConstant {
    final int SPINNER_LAYER_COUNT = 4;

    const _MaterialSpinnerConstant();
}

/// creates WskConfig for MaterialSpinner
WskConfig materialSpinnerConfig() => new WskWidgetConfig<MaterialSpinner>(
    "wsk-js-spinner", (final html.HtmlElement element) => new MaterialSpinner.fromElement(element));

/// registration-Helper
void registerMaterialSpinner() => componenthandler.register(materialSpinnerConfig());

class MaterialSpinner extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialSpinner');

    static const _MaterialSpinnerConstant _constant = const _MaterialSpinnerConstant();
    static const _MaterialSpinnerCssClasses _cssClasses = const _MaterialSpinnerCssClasses();

    MaterialSpinner.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialSpinner widget(final html.HtmlElement element) => wskComponent(element) as MaterialSpinner;

    /**
    * Stops the spinner animation.
    * Public method for users who need to stop the spinner for any reason.
    * @public
    */
    void stop() {
        element.classes.remove(_cssClasses.IS_ACTIVE);
    }

    /**
    * Starts the spinner animation.
    * Public method for users who need to manually start the spinner for any reason
    * (instead of just adding the 'is-active' class to their markup).
    * @public
    */
    void start() {
        element.classes.add(_cssClasses.IS_ACTIVE);
    }

    void set active(final bool active) => active ? start() : stop();
    bool get active => element.classes.contains(_cssClasses.IS_ACTIVE);

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialSpinner - init");

        if (element != null) {

            for (int i = 1; i <= _constant.SPINNER_LAYER_COUNT; i++) {
                _createLayer(i);
            }

            //_start();
            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Auxiliary method to create a spinner layer.
    void _createLayer(final int index) {

        final html.DivElement layer = new html.DivElement();
        layer.classes.add(_cssClasses.SPINNER_LAYER);
        layer.classes.add(_cssClasses.SPINNER_LAYER + '-' + index.toString());

        final html.DivElement leftClipper = new html.DivElement();
        leftClipper.classes.add(_cssClasses.SPINNER_CIRCLE_CLIPPER);
        leftClipper.classes.add(_cssClasses.SPINNER_LEFT);

        final html.DivElement gapPatch = new html.DivElement();
        gapPatch.classes.add(_cssClasses.SPINNER_GAP_PATCH);

        final html.DivElement rightClipper = new html.DivElement();
        rightClipper.classes.add(_cssClasses.SPINNER_CIRCLE_CLIPPER);
        rightClipper.classes.add(_cssClasses.SPINNER_RIGHT);

        final circleOwners = [leftClipper, gapPatch, rightClipper];

        for (int i = 0; i < circleOwners.length; i++) {

            final circle = new html.DivElement();
            circle.classes.add(_cssClasses.SPINNER_CIRCLE);
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

