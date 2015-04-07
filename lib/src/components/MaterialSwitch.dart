part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialSwitchCssClasses {

    final String WSK_SWITCH_INPUT = 'wsk-switch__input';

    final String WSK_SWITCH_TRACK = 'wsk-switch__track';

    final String WSK_SWITCH_THUMB = 'wsk-switch__thumb';

    final String WSK_SWITCH_FOCUS_HELPER = 'wsk-switch__focus-helper';

    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    final String WSK_SWITCH_RIPPLE_CONTAINER = 'wsk-switch__ripple-container';

    final String WSK_RIPPLE_CENTER = 'wsk-ripple--center';

    final String WSK_RIPPLE = 'wsk-ripple';

    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';

    const _MaterialSwitchCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialSwitchConstant {
    final int TINY_TIMEOUT_IN_MS = 100;

    const _MaterialSwitchConstant();
}

/// creates WskConfig for MaterialSwitch
WskConfig materialSwitchConfig() => new WskWidgetConfig<MaterialSwitch>(
    "wsk-js-switch", (final html.HtmlElement element) => new MaterialSwitch.fromElement(element));

/// registration-Helper
void registerMaterialSwitch() => componenthandler.register(materialSwitchConfig());

class MaterialSwitch extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialSwitch');

    static const _MaterialSwitchConstant _constant = const _MaterialSwitchConstant();
    static const _MaterialSwitchCssClasses _cssClasses = const _MaterialSwitchCssClasses();

    html.CheckboxInputElement _btnElement = null;

    MaterialSwitch.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialSwitch widget(final html.HtmlElement element) => wskComponent(element) as MaterialSwitch;

    html.CheckboxInputElement get btnElement {
        if(_btnElement == null) { _btnElement = element.querySelector(".${_cssClasses.WSK_SWITCH_INPUT}"); }
        return _btnElement;
    }
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialSwitch - init");

        if (element != null) {

            final html.DivElement track = new html.DivElement();
            track.classes.add(_cssClasses.WSK_SWITCH_TRACK);

            final html.DivElement thumb = new html.DivElement();
            thumb.classes.add(_cssClasses.WSK_SWITCH_THUMB);

            final html.SpanElement focusHelper = new html.SpanElement();
            focusHelper.classes.add(_cssClasses.WSK_SWITCH_FOCUS_HELPER);

            thumb.append(focusHelper);

            element.append(track);
            element.append(thumb);


            if (element.classes.contains(
                _cssClasses.WSK_JS_RIPPLE_EFFECT)) {
                element.classes.add(
                    _cssClasses.WSK_JS_RIPPLE_EFFECT_IGNORE_EVENTS);

                final html.SpanElement rippleContainer = new html.SpanElement();
                rippleContainer.classes.add(_cssClasses.WSK_SWITCH_RIPPLE_CONTAINER);
                rippleContainer.classes.add(_cssClasses.WSK_JS_RIPPLE_EFFECT);
                rippleContainer.classes.add(_cssClasses.WSK_RIPPLE_CENTER);

                final html.SpanElement ripple = new html.SpanElement();
                ripple.classes.add(_cssClasses.WSK_RIPPLE);

                rippleContainer.append(ripple);
                element.append(rippleContainer);

                rippleContainer.onMouseUp.listen( _onMouseUp);
            }

            btnElement.onChange.listen( _onChange );

            btnElement.onFocus.listen( _onFocus );

            btnElement.onBlur.listen( _onBlur );

            element.onMouseUp.listen( _onMouseUp );

            _updateClasses(btnElement, element);
            element.classes.add('is-upgraded');
        }
    }

    /// Handle change of state.
    void _onChange(final html.Event event) {
        _updateClasses(btnElement, element);
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
    void _onMouseUp(final html.Event event) {
        _blur();
    }

    /// Handle class updates.
    void _updateClasses(final html.CheckboxInputElement button, final html.HtmlElement label) {

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
        // TODO: figure out why there's a focus event being fired after our blur,
        // so that we can avoid this hack.
        new Timer(new Duration(milliseconds : _constant.TINY_TIMEOUT_IN_MS ), () {
            btnElement.blur();
        });
    }
}

