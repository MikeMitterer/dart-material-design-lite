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

part of mdltemplate;

abstract class ModelObserver<T extends MdlComponent> {
    final Logger _logger = new Logger('mdltemplate.ModelObserver');

    factory ModelObserver(final dom.Element element) {
        Validate.notNull(element);

        final MdlComponent component = mdlComponent(element,null);
        if(component is MaterialTextfield) {

            return new TextFieldObserver._internal(component);

        } else if(component is MaterialCheckbox) {

            return new CheckBoxObserver._internal(component);

        } else if(component is MaterialRadioGroup) {

            return new RadioObserver._internal(component);

        }

        throw new ArgumentError("${element} cannot be observed. Probably not a MdlComponent!");
    }

    void observe(final Scope scope,final String fieldname);

    //- private -----------------------------------------------------------------------------------
}


class TextFieldObserver implements ModelObserver<MaterialTextfield> {
    final Logger _logger = new Logger('mdltemplate.TextFieldObserver');

    final MaterialTextfield _textfield;

    void observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _textfield.onInput.listen((_) => prop.value = _textfield.value);
            prop.onChange.listen( (final PropertyChangeEvent event) => _textfield.value = prop.value);

            _textfield.value = prop.value;

        } else if(val != null) {

            _textfield.value = val.toString();
            _logger.warning("${fieldname} is not Observable, MaterialTextfield will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
    }

    //- private -----------------------------------------------------------------------------------

    TextFieldObserver._internal(this._textfield) {
        Validate.notNull(_textfield);
    }
}

class CheckBoxObserver implements ModelObserver<MaterialCheckbox> {
    final Logger _logger = new Logger('mdltemplate.CheckBoxObserver');

    final MaterialCheckbox _checkbox;

    void observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _checkbox.onClick.listen((_) => prop.value = _checkbox.checked ? _checkbox.value : "");

            prop.onChange.listen( (final PropertyChangeEvent event) =>
                _checkbox.value == prop.value ? _checkbox.checked = true : _checkbox.checked = false);

        } else if(val != null) {

            _checkbox.checked = val.toString() == _checkbox.value;
            _logger.warning("${fieldname} is not Observable, MaterialCheckbox will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
    }

    //- private -----------------------------------------------------------------------------------

    CheckBoxObserver._internal(this._checkbox) {
        Validate.notNull(_checkbox);
    }

}

class RadioObserver implements ModelObserver<MaterialRadioGroup> {
    final Logger _logger = new Logger('mdltemplate.RadioObserver');

    final MaterialRadioGroup _radioGroup;

    void observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _radioGroup.onChange.listen((_) => _radioGroup.hasValue ? prop.value = _radioGroup.value : prop.value = "");

            prop.onChange.listen( (final PropertyChangeEvent event) => _radioGroup.value = prop.value.toString() );
            _radioGroup.value = prop.value.toString();

        } else if(val != null) {

            _radioGroup.value = val.toString();
            _logger.warning("${fieldname} is not Observable, MaterialRadioGroup will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
    }

    //- private -----------------------------------------------------------------------------------

    RadioObserver._internal(this._radioGroup) {
        Validate.notNull(_radioGroup);
    }

}