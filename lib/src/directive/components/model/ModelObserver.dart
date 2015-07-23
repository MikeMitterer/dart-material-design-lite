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

part of mdldirective;

abstract class ModelObserver<T extends MdlComponent> {
    final Logger _logger = new Logger('mdldirective.ModelObserver');


    void observe(final Scope scope,final String fieldname);

    static int toInt(final dynamic value) {
        if(value is num) {
            return (value as num).toInt();
        }
        return int.parse(value.toString());
    }

    //- private -----------------------------------------------------------------------------------
}


class _TextFieldObserver implements ModelObserver<MaterialTextfield> {
    final Logger _logger = new Logger('mdldirective.TextFieldObserver');

    final MaterialTextfield _textfield;

    void observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _textfield.onInput.listen((_) => prop.value = _textfield.value);
            prop.onChange.listen( (final PropertyChangeEvent event) => _textfield.value = prop.value.toString());

            _textfield.value = prop.value.toString();

        } else if(val != null) {

            _textfield.value = val.toString();
            _logger.warning("${fieldname} is not Observable, MaterialTextfield will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
    }

    //- private -----------------------------------------------------------------------------------

    _TextFieldObserver._internal(this._textfield) {
        Validate.notNull(_textfield);
    }
}

class _CheckBoxObserver implements ModelObserver<MaterialCheckbox> {
    final Logger _logger = new Logger('mdldirective.CheckBoxObserver');

    final MaterialCheckbox _checkbox;

    void observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _checkbox.onClick.listen((_) => prop.value = _checkbox.checked ? _checkbox.value : "");

            prop.onChange.listen( (final PropertyChangeEvent event) =>
                _checkbox.value == prop.value.toString() || prop.toBool() ? _checkbox.checked = true : _checkbox.checked = false);

            _checkbox.checked = _checkbox.value == prop.value.toString() || prop.toBool();

        } else if(val != null) {

            _checkbox.checked = val.toString() == _checkbox.value;
            _logger.warning("${fieldname} is not Observable, MaterialCheckbox will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
    }

    //- private -----------------------------------------------------------------------------------

    _CheckBoxObserver._internal(this._checkbox) {
        Validate.notNull(_checkbox);
    }

}

class _RadioObserver implements ModelObserver<MaterialRadioGroup> {
    final Logger _logger = new Logger('mdldirective.RadioObserver');

    final MaterialRadioGroup _radioGroup;

    void observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _radioGroup.onGroupChange.listen((_) => _radioGroup.hasValue ? prop.value = _radioGroup.value : prop.value = "");

            prop.onChange.listen( (final PropertyChangeEvent event) => _radioGroup.value = prop.value.toString() );
            _radioGroup.value = prop.value.toString();

        } else if(val != null) {

            _radioGroup.value = val.toString();
            _logger.warning("${fieldname} is not Observable, RadioObserver will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
    }

    //- private -----------------------------------------------------------------------------------

    _RadioObserver._internal(this._radioGroup) {
        Validate.notNull(_radioGroup);
    }

}

class _SwitchObserver implements ModelObserver<MaterialSwitch> {
    final Logger _logger = new Logger('mdldirective.SwitchObserver');

    final MaterialSwitch _switch;

    void observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _switch.onClick.listen((_) => prop.value = _switch.checked ? _switch.value : "");

            prop.onChange.listen( (final PropertyChangeEvent event) =>
                _switch.value == prop.value.toString() || prop.toBool() ? _switch.checked = true : _switch.checked = false);

            _switch.checked = _switch.value.toString() == prop.value || prop.toBool();

        } else if(val != null) {

            _switch.checked = _switch.value.toString() == val.toString();
            _logger.warning("${fieldname} is not Observable, SwitchObserver will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
    }

    //- private -----------------------------------------------------------------------------------

    _SwitchObserver._internal(this._switch) {
        Validate.notNull(_switch);
    }
}

class _SliderObserver implements ModelObserver<MaterialSlider> {
    final Logger _logger = new Logger('mdldirective.SliderObserver');

    final MaterialSlider _slider;

    void observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _slider.onInput.listen( (_) => prop.value = _slider.value);

            prop.onChange.listen( (final PropertyChangeEvent event) => _slider.value = ModelObserver.toInt(prop.value));

            _slider.value = ModelObserver.toInt(prop.value);

        } else if(val != null) {

            _slider.value = ModelObserver.toInt(val.toString());
            _logger.warning("${fieldname} is not Observable, SliderObserver will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
    }

    //- private -----------------------------------------------------------------------------------

    _SliderObserver._internal(this._slider) {
        Validate.notNull(_slider);
    }
}