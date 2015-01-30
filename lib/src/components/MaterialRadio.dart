part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialRadioCssClasses {
    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';

    final String IS_UPGRADED = 'is-upgraded';

    final String WSK_JS_RADIO = 'wsk-js-radio';

    final String WSK_RADIO_BTN = 'wsk-radio__button';

    final String WSK_RADIO_OUTER_CIRCLE = 'wsk-radio__outer-circle';

    final String WSK_RADIO_INNER_CIRCLE = 'wsk-radio__inner-circle';

    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    final String WSK_RADIO_RIPPLE_CONTAINER = 'wsk-radio__ripple-container';

    final String WSK_RIPPLE_CENTER = 'wsk-ripple--center';

    final String WSK_RIPPLE = 'wsk-ripple';
    const _MaterialRadioCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialRadioConstant {
    final int TINY_TIMEOUT_IN_MS = 10;
    const _MaterialRadioConstant();
}

/// registration-Helper
void registerMaterialRadio() => _componenthandler.register(new WskConfig<MaterialRadio>(
    "wsk-js-radio", (final html.HtmlElement element) => new MaterialRadio(element)));

class MaterialRadio extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialRadio');

    static const _MaterialRadioConstant _constant = const _MaterialRadioConstant();
    static const _MaterialRadioCssClasses _cssClasses = const _MaterialRadioCssClasses();

    html.RadioButtonInputElement _btnElement = null;

    MaterialRadio(final html.HtmlElement element) : super(element) {
        _init();
    }

    html.RadioButtonInputElement get btnElement {
        if(_btnElement == null) {
            _btnElement = element.querySelector(".${_cssClasses.WSK_RADIO_BTN}");
        }
        return _btnElement;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialRadio - init");

        if (element != null) {

            final outerCircle = new html.SpanElement();
            outerCircle.classes.add(_cssClasses.WSK_RADIO_OUTER_CIRCLE);

            final innerCircle = new html.SpanElement();
            innerCircle.classes.add(_cssClasses.WSK_RADIO_INNER_CIRCLE);

            element.append(outerCircle);
            element.append(innerCircle);

            if (element.classes.contains(
                _cssClasses.WSK_JS_RIPPLE_EFFECT)) {
                element.classes.add(
                    _cssClasses.WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS);

                final html.SpanElement rippleContainer = new html.SpanElement();
                rippleContainer.classes.add(_cssClasses.WSK_RADIO_RIPPLE_CONTAINER);
                rippleContainer.classes.add(_cssClasses.WSK_JS_RIPPLE_EFFECT);
                rippleContainer.classes.add(_cssClasses.WSK_RIPPLE_CENTER);

                final html.SpanElement ripple = new html.SpanElement();
                ripple.classes.add(_cssClasses.WSK_RIPPLE);

                rippleContainer.append(ripple);
                element.append(rippleContainer);

                rippleContainer.onMouseUp.listen( _onMouseUp );

            }

            btnElement.onChange.listen( _onChange );

            btnElement.onFocus.listen( _onFocus );

            btnElement.onBlur.listen( _onBlur );

            element.onMouseUp.listen( _onMouseUp );

            _updateClasses(btnElement, element);
            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Handle change of state.
    /// @param {Event} event The event that fired.
    void _onChange(final html.Event event) {

        _updateClasses(_btnElement, element);

        // Since other radio buttons don't get change events, we need to look for
        // them to update their classes.
        final List<html.HtmlElement> radios = html.querySelectorAll('.' + _cssClasses.WSK_JS_RADIO);

        for (int i = 0; i < radios.length; i++) {

            final html.RadioButtonInputElement button = radios[i].querySelector('.' + _cssClasses.WSK_RADIO_BTN);
            // Different name == different group, so no point updating those.
            if (button.getAttribute('name') == _btnElement.getAttribute('name')) {
                _updateClasses(button, radios[i]);
            }
        }
    }

    /// Handle focus.
    void _onFocus(final html.Event event) {
        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus.
    void _onBlur(final html.Event event) {
        element.classes.remove(_cssClasses.IS_FOCUSED);
    }

    /// Handle mouseup.
    void _onMouseUp(final html.MouseEvent event) {
        _blur();
    }

    /// Update classes.
    void _updateClasses(final html.RadioButtonInputElement  button, final html.HtmlElement label) {

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

    void _blur() {
        new Timer(new Duration(milliseconds : _constant.TINY_TIMEOUT_IN_MS ), () {
            btnElement.blur();
        });
    }

}

