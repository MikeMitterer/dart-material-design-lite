/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdlcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialTextfieldCssClasses {

    static const String MAIN_CLASS  = "mdl-js-textfield";

    final String LABEL = 'mdl-textfield__label';

    final String INPUT = 'mdl-textfield__input';

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

/// creates MdlConfig for MaterialTextfield
MdlConfig materialTextfieldConfig() => new MdlWidgetConfig<MaterialTextfield>(
    _MaterialTextfieldCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialTextfield.fromElement(element,injector));

/// registration-Helper
void registerMaterialTextfield() => componentHandler().register(materialTextfieldConfig());

class MaterialTextfield extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialTextfield');

    static const _MaterialTextfieldConstant _constant = const _MaterialTextfieldConstant();
    static const _MaterialTextfieldCssClasses _cssClasses = const _MaterialTextfieldCssClasses();

    int _maxRows = _constant.NO_MAX_ROWS;

    dom.HtmlElement _input;
    dom.LabelElement _label;

    MaterialTextfield.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialTextfield widget(final dom.HtmlElement element) => mdlComponent(element,MaterialTextfield) as MaterialTextfield;

    /// MaterialTextfield is one of the few exception where hub != element
    dom.Element get hub => input;

    dom.HtmlElement get input {
        if(_input == null) {
            _input = element.querySelector(".${_cssClasses.INPUT}") as dom.HtmlElement;
        }
        return _input;
    }

    dom.LabelElement get label {
        if(_label == null) {
            _label = element.querySelector(".${_cssClasses.LABEL}") as dom.LabelElement;
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
        if (value != null && value != _relaxedInput.value) {

            int selStart = (_relaxedInput as dom.InputElement).selectionStart;
            int selEnd = (_relaxedInput as dom.InputElement).selectionStart;

            _relaxedInput.value = value;

            (_relaxedInput as dom.InputElement).setSelectionRange(selStart,selEnd);
        }

        _updateClasses();
    }

    /// Returns text field value
    String get value => _relaxedInput.value;

    /// Update text field value
    void set value(final String value) {
        change(value);
    }

    /// Updated the components CSS-Classes usually called from [MaterialAttribute] or [MaterialClass]
    @override
    void update() { _updateClasses(); }

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

                eventStreams.add(input.onInput.listen( (_) => _updateClasses() ));

                // .addEventListener('focus', -- .onFocus.listen(<Event>);
                eventStreams.add(input.onFocus.listen( _onFocus));

                // .addEventListener('blur', -- .onBlur.listen(<Event>);
                eventStreams.add(input.onBlur.listen( _onBlur));

                if (_maxRows != _constant.NO_MAX_ROWS) {
                    // TODO: This should handle pasting multi line text.
                    // Currently doesn't.
                    eventStreams.add(element.onKeyDown.listen( _onKeyDown ));
                }

                _updateClasses();
                element.classes.add(_cssClasses.IS_UPGRADED);
            }
        }
    }

    /// Handle input being entered.
    void _onKeyDown(final dom.KeyboardEvent event) {
        final input = element;

        final currentRowCount = input.value.split('\n').length;
        if (event.keyCode == 13) {
            if (currentRowCount >= _maxRows) {
                event.preventDefault();
            }
        }
    }

    /// Handle focus.
    void _onFocus(final dom.Event event) {
        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus.
    void _onBlur(final dom.Event event) {
        element.classes.remove(_cssClasses.IS_FOCUSED);
    }

    /// Handle class updates.
    void _updateClasses() {

        _checkDisabled();
        _checkValidity();
        _checkDirty();
    }

    /// Check the disabled state and update field accordingly.
    void _checkDisabled() {
        if (_relaxedInput.disabled) {
            element.classes.add(_cssClasses.IS_DISABLED);

        } else {
            element.classes.remove(_cssClasses.IS_DISABLED);
        }
    }

    /// Check the validity state and update field accordingly.
    void _checkValidity() {
        if (_relaxedInput.validity.valid) {
            element.classes.remove(_cssClasses.IS_INVALID);

        } else {
            element.classes.add(_cssClasses.IS_INVALID);
        }
    }

    /// Check the dirty state and update field accordingly.
    void _checkDirty() {
        if (_relaxedInput.value != null && _relaxedInput.value.isNotEmpty) {
            element.classes.add(_cssClasses.IS_DIRTY);

        } else {
            element.classes.remove(_cssClasses.IS_DIRTY);
        }
    }

    /// We have two different elements - InputElement and TextAreaElement
    dynamic get _relaxedInput => input;

}

