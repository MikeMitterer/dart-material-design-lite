part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialTextfieldCssClasses {

    final String LABEL = 'wsk-textfield__label';

    final String INPUT = 'wsk-textfield__input';

    final String IS_DIRTY = 'is-dirty';

    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_INVALID = 'is-invalid';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialTextfieldCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialTextfieldConstant {

    final int NO_MAX_ROWS = -1;
    final String MAX_ROWS_ATTRIBUTE = 'maxrows';

    const _MaterialTextfieldConstant();
}

/// creates WskConfig for MaterialButton
WskConfig materialTextfieldConfig() => new WskWidgetConfig<MaterialTextfield>(
    "wsk-js-textfield", (final html.HtmlElement element) => new MaterialTextfield.fromElement(element));

/// registration-Helper
void registerMaterialTextfield() => componenthandler.register(materialTextfieldConfig());

class MaterialTextfield extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialTextfield');

    static const _MaterialTextfieldConstant _constant = const _MaterialTextfieldConstant();
    static const _MaterialTextfieldCssClasses _cssClasses = const _MaterialTextfieldCssClasses();

    int _maxRows = _constant.NO_MAX_ROWS;

    html.InputElement _input;
    html.LabelElement _label;

    MaterialTextfield.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialTextfield widget(final html.HtmlElement element) => wskComponent(element) as MaterialTextfield;

    html.Element get hub => input;

    html.HtmlElement get input {
        if(_input == null) {
            _input = element.querySelector(".${_cssClasses.INPUT}") as html.HtmlElement;
        }
        return _input;
    }

    html.LabelElement get label {
        if(_label == null) {
            _label = element.querySelector(".${_cssClasses.LABEL}") as html.LabelElement;
        }
        return _label;
    }

    /// Disable text field.
    void disable() {
        _relaxedInput.disabled = true;
        _updateClasses();
    }

    /// Enable text field.
    void enable() {
        _relaxedInput.disabled = false;
        _updateClasses();
    }

    /// Update text field value.
    void change(final String value) {

        if (value != null) {
            _relaxedInput.value = value;
        }
        _updateClasses();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialTextfield - init");

        if (element != null) {

            if (input != null) {
                if (element.attributes.containsKey(_constant.MAX_ROWS_ATTRIBUTE) &&
                    element.attributes[_constant.MAX_ROWS_ATTRIBUTE] != null &&
                    element.attributes[_constant.MAX_ROWS_ATTRIBUTE].isNotEmpty ) {

                    _maxRows = int.parse(element.getAttribute(_constant.MAX_ROWS_ATTRIBUTE),
                    onError: (final String value) {
                        _logger.severe('maxrows attribute provided, but wasn\'t a number: $value');
                        _maxRows = _constant.NO_MAX_ROWS;
                    });
                }

                input.onInput.listen( (_) => _updateClasses() );

                // .addEventListener('focus', -- .onFocus.listen(<Event>);
                input.onFocus.listen( _onFocus);

                // .addEventListener('blur', -- .onBlur.listen(<Event>);
                input.onBlur.listen( _onBlur);

                if (_maxRows != _constant.NO_MAX_ROWS) {
                    // TODO: This should handle pasting multi line text.
                    // Currently doesn't.
                    element.onKeyDown.listen( _onKeyDown );
                }

                _updateClasses();
                element.classes.add(_cssClasses.IS_UPGRADED);
            }
        }
    }

    /// Handle input being entered.
    void _onKeyDown(final html.KeyboardEvent event) {
        final input = element;

        final currentRowCount = input.value.split('\n').length;
        if (event.keyCode == 13) {
            if (currentRowCount >= _maxRows) {
                event.preventDefault();
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

    /// Handle class updates.
    void _updateClasses() {

        if (_relaxedInput.disabled) {
            element.classes.add(_cssClasses.IS_DISABLED);

        } else {
            element.classes.remove(_cssClasses.IS_DISABLED);
        }

        if (_relaxedInput.validity.valid) {
            element.classes.remove(_cssClasses.IS_INVALID);

        } else {
            element.classes.add(_cssClasses.IS_INVALID);
        }

        if (_relaxedInput.value != null && _relaxedInput.value.isNotEmpty) {
            element.classes.add(_cssClasses.IS_DIRTY);

        } else {
            element.classes.remove(_cssClasses.IS_DIRTY);
        }
    }

    /// We have two different elements - InputElement and TextAreaElement
    dynamic get _relaxedInput => input;

}

