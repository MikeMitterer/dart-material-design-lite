/*
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

/// Controller-View for
///
///     <div class="mdl-textfield">
///         <input class="mdl-textfield__input" type="text" id="sample1">
///         <label class="mdl-textfield__label" for="sample1">Type Something...</label>
///     </div>
///
class MaterialTextfield extends MdlComponent with FallbackFormatter {
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

    /// First checks if [element] is a [MaterialTextfield] - if so, it returns the widget,
    /// if not it queries for the input-element (this is where MaterialTextfield is registered)
    static MaterialTextfield widget(final dom.HtmlElement element) {
        MaterialTextfield textfield;
        try {
            textfield = mdlComponent(element,MaterialTextfield,showWarning: false) as MaterialTextfield;

        } on String {
            final dom.HtmlElement inputField = element.querySelector(".${_cssClasses.INPUT}");
            textfield = mdlComponent(inputField,MaterialTextfield) as MaterialTextfield;
        }
        return textfield;
    }

    /// MaterialTextfield is one of the few exception where hub != element
    dom.Element get hub => inputElement;

    dom.HtmlElement get inputElement {
        if(_input == null) {
            _input = element.querySelector(".${_cssClasses.INPUT}") as dom.HtmlElement;
        }
        return _input;
    }

    dom.LabelElement get labelElement {
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
            int selStart = (_relaxedInput).selectionStart;

            void _placeTheCursorWhereItWasBefore(final int position) {
                (_relaxedInput).setSelectionRange(position,position);
            }

            _relaxedInput.value = MaterialFormatter.widget(element).format(value);
            _placeTheCursorWhereItWasBefore(selStart);
        }

        _updateClasses();
    }

    String get label {
        final dom.HtmlElement _label = labelElement;
        return _label != null ? _label.text.trim() : "";
    }

    void set label(final String v) {
        Validate.notNull(v);

        final dom.HtmlElement _label = labelElement;
        _label?.text = formatterFor(_label,element).format(v.trim());
    }

    /// Returns text field value
    String get value => _relaxedInput.value;

    /// Update text field value
    void set value(final String value) {
        change(value);
    }

    @override
    /// Updates the components CSS-Classes usually called from [MaterialAttribute] or [MaterialClass]
    void update() { _updateClasses(); }

    /// If this input field has a validity-check and if this check fails it returns [false]
    /// If this input field has NO validity-check or if the check goes OK it returns [true]
    bool get isValid => _relaxedInput.validity != null && !_relaxedInput.validity.valid ? false : true;

    /// Inverts [isValid]
    bool get isNotValid => !isValid;

    /// Focus text field.
    void focus() {
        _relaxedInput.focus();
        _updateClasses();
    }

    /// Blur text field.
    void blur() {
        _relaxedInput.blur();
        _updateClasses();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialTextfield - init");

        if (element != null) {

            if (inputElement != null) {
                if (element.attributes.containsKey(_constant.MAX_ROWS_ATTRIBUTE) &&
                    element.attributes[_constant.MAX_ROWS_ATTRIBUTE] != null &&
                    element.attributes[_constant.MAX_ROWS_ATTRIBUTE].isNotEmpty ) {

                    _maxRows = int.parse(element.getAttribute(_constant.MAX_ROWS_ATTRIBUTE),
                    onError: (final String value) {
                        _logger.severe('maxrows attribute provided, but wasn\'t a number: $value');
                        _maxRows = _constant.NO_MAX_ROWS;
                    });
                }

                if (inputElement.attributes.containsKey('placeholder')) {
                    element.classes.add(_cssClasses.HAS_PLACEHOLDER);
                }

                eventStreams.add(inputElement.onInput.listen( (_) => _updateClasses() ));

                // .addEventListener('focus', -- .onFocus.listen(<Event>);
                eventStreams.add(inputElement.onFocus.listen( _onFocus));

                // .addEventListener('blur', -- .onBlur.listen(<Event>);
                eventStreams.add(inputElement.onBlur.listen( _onBlur));

                eventStreams.add(inputElement.onReset.listen( _onReset));

                if (_maxRows != _constant.NO_MAX_ROWS) {
                    // TODO: This should handle pasting multi line text.
                    // Currently doesn't.
                    eventStreams.add(element.onKeyDown.listen( _onKeyDown ));
                }

                _updateClasses();

                /// Reformat according to [MaterialFormatter] definition
                void _kickInFormatter() {
                    value = value;
                }
                _kickInFormatter();

                // If field is invalid but empty we reset the invalid-class during this initialization
                // phase.
                //
                // E.g. - solves the problem of showing an empty Login-Form empty fields marked as error.
                // We turn this flag on after the user keys something in or field looses focus
                // (Form becomes dirty)
                final bool isInvalid = element.classes.contains(_cssClasses.IS_INVALID);
                if (isInvalid && value.isEmpty) {
                    element.classes.remove(_cssClasses.IS_INVALID);
                }
                element.classes.add(_cssClasses.IS_UPGRADED);
            }
        }
    }

    /// Handle input being entered.
    void _onKeyDown(final dom.KeyboardEvent event) {
        //final input = element;

        final currentRowCount = value.split('\n').length;
        if (event.keyCode == 13) {
            if (currentRowCount >= _maxRows) {
                event.preventDefault();
            }
        }
    }

    /// Handle focus.
    void _onFocus(_) {
        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus.
    void _onBlur(_) {
        element.classes.remove(_cssClasses.IS_FOCUSED);
    }


    /// Handle class updates.
    void _updateClasses() {

        _checkDisabled();
        _checkValidity();
        _checkDirty();
        _checkFocus();
    }

    /// Handle reset event from out side.
    void _onReset(_) {
        _updateClasses();
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
        if (_relaxedInput.validity != null) {

            if (_relaxedInput.validity.valid) {
                element.classes.remove(_cssClasses.IS_INVALID);
            }
            else {
                element.classes.add(_cssClasses.IS_INVALID);
            }
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

    /// Check the focus state and update field accordingly.
    void _checkFocus() {
        if (element.querySelector(':focus') != null) {
            element.classes.add(_cssClasses.IS_FOCUSED);

        } else {
            element.classes.remove(_cssClasses.IS_FOCUSED);
        }
    }

    /// We have two different elements - InputElement and TextAreaElement
    dynamic get _relaxedInput => inputElement;

}

/// creates MdlConfig for MaterialTextfield
MdlConfig materialTextfieldConfig() => new MdlWidgetConfig<MaterialTextfield>(
    _MaterialTextfieldCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
=> new MaterialTextfield.fromElement(element,injector));

/// registration-Helper
void registerMaterialTextfield() => componentHandler().register(materialTextfieldConfig());


/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialTextfieldCssClasses {

    static const String MAIN_CLASS  = "mdl-textfield";

    final String LABEL = 'mdl-textfield__label';

    final String INPUT = 'mdl-textfield__input';

    final String IS_DIRTY = 'is-dirty';

    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_INVALID = 'is-invalid';

    final String IS_UPGRADED = 'is-upgraded';

    final String HAS_PLACEHOLDER = 'has-placeholder';

    const _MaterialTextfieldCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialTextfieldConstant {

    final int NO_MAX_ROWS = -1;
    final String MAX_ROWS_ATTRIBUTE = 'maxrows';

    const _MaterialTextfieldConstant();
}