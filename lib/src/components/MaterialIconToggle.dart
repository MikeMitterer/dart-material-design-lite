part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialIconToggleCssClasses {

    final String INPUT = 'wsk-icon-toggle__input';
    final String JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';
    final String RIPPLE_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';
    final String RIPPLE_CONTAINER = 'wsk-icon-toggle__ripple-container';
    final String RIPPLE_CENTER = 'wsk-ripple--center';
    final String RIPPLE = 'wsk-ripple';
    final String IS_FOCUSED = 'is-focused';
    final String IS_DISABLED = 'is-disabled';
    final String IS_CHECKED = 'is-checked';

    const _MaterialIconToggleCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialIconToggleConstant {

    final int TINY_TIMEOUT_IN_MS = 100;

    const _MaterialIconToggleConstant();
}

/// creates WskConfig for IconToggle
WskConfig materialIconToggleConfig() => new WskConfig<MaterialIconToggle>(
    "wsk-js-icon-toggle", (final html.HtmlElement element) => new MaterialIconToggle(element));

/// registration-Helper
void registerMaterialIconToggle() => componenthandler.register(materialIconToggleConfig());

class MaterialIconToggle extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialIconToggle');

    static const _MaterialIconToggleConstant _constant = const _MaterialIconToggleConstant();
    static const _MaterialIconToggleCssClasses _cssClasses = const _MaterialIconToggleCssClasses();

    html.InputElement _btnElement = null;

    MaterialIconToggle(final html.HtmlElement element) : super(element) {
        _init();
    }

    html.InputElement get buttonElement {
        if(_btnElement == null) {
            _btnElement = element.querySelector('.${_cssClasses.INPUT}');
        }
        return _btnElement;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialIconToggle - init");

        if (element != null) {

            if (element.classes.contains(_cssClasses.JS_RIPPLE_EFFECT)) {
                element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

                final html.SpanElement rippleContainer = new html.SpanElement();
                rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
                rippleContainer.classes.add(_cssClasses.JS_RIPPLE_EFFECT);
                rippleContainer.classes.add(_cssClasses.RIPPLE_CENTER);

                final ripple = new html.SpanElement();
                ripple.classes.add(_cssClasses.RIPPLE);

                rippleContainer.append(ripple);
                element.append(rippleContainer);

                rippleContainer.onMouseUp.listen(_onMouseUp);
            }

            buttonElement.onChange.listen(_onChange);

            buttonElement.onFocus.listen( _onFocus);

            buttonElement.onBlur.listen( _onBlur);

            element.onMouseUp.listen(_onMouseUp);

            _updateClasses(_btnElement, element);
            element.classes.add('is-upgraded');
        }
    }

    /// Handle change of state.
    void _onChange(final html.Event event) {
        _updateClasses(buttonElement, element);
    }

    /// Handle focus of element.
    void _onFocus(final html.Event event) {

        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus of element.
    void _onBlur(final html.Event event) {

        element.classes.remove(_cssClasses.IS_FOCUSED);
    }

    /// Handle mouseup.
    void _onMouseUp(final html.MouseEvent event) {
        _blur();
    }

    /// Handle class updates.
    /// The [button] whose classes we should update.
    /// The [label] whose classes we should update.
    void _updateClasses(final button, label) {

        if (button.disabled) {
            label.classes.add(_cssClasses.IS_DISABLED);

        } else {
            label.classes.remove(_cssClasses.IS_DISABLED);
        }

        if (button.checked) {
            label.classes.add(_cssClasses.IS_CHECKED);

        } else {
            label.classes.remove(_cssClasses.IS_CHECKED);
        }
    }

    /// Add blur.
    void _blur() {

        // TODO: figure out why there's a focus event being fired after our blur,
        // so that we can avoid this hack.
        new Timer(new Duration(milliseconds : _constant.TINY_TIMEOUT_IN_MS ), () {
            buttonElement.blur();
        });
    }
}

