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

part of mdldirective;

abstract class ModelObserver {
    final Logger _logger = new Logger('mdldirective.ModelObserver');

    /// Returns the registered Stream so that they can be cleaned up in
    /// [MdlComponent#downgrade]
    List<StreamSubscription> observe(final Scope scope,final String fieldname);

    static int toInt(final dynamic value) {
        if(value is num) {
            return value.toInt();
        }
        return int.parse(value.toString());
    }

    //- private -----------------------------------------------------------------------------------
}


class _TextFieldObserver implements ModelObserver {
    final Logger _logger = new Logger('mdldirective.TextFieldObserver');

    final MaterialTextfield _textfield;

    /// StreamSubscriptions registered by this Observer
    final List<StreamSubscription> _subscriptions = new List<StreamSubscription>();

    List<StreamSubscription> observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _subscriptions.add(
                _textfield.onInput.listen((_) => prop.value = _textfield.value));

            _subscriptions.add(
                prop.onChange.listen( (final PropertyChangeEvent event) => _textfield.value = prop.value.toString()));

            // Changes the value in the _textfield only if prop.value is different
            // Avoids unnecessary _textfield-updates
            if(_textfield.value != prop.value.toString()) {
                _textfield.value = prop.value.toString();
            }

        } else if(val != null) {

            if(_textfield.value != val.toString()) {
                _textfield.value = val.toString();
            }
            _logger.warning("${fieldname} is not Observable, MaterialTextfield will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
        return _subscriptions;
    }

    //- private -----------------------------------------------------------------------------------

    _TextFieldObserver._internal(this._textfield) {
        Validate.notNull(_textfield);
    }
}


class _CheckBoxObserver implements ModelObserver {
    final Logger _logger = new Logger('mdldirective.CheckBoxObserver');

    final MaterialCheckbox _checkbox;

    /// StreamSubscriptions registered by this Observer
    final List<StreamSubscription> _subscriptions = new List<StreamSubscription>();

    List<StreamSubscription> observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _subscriptions.add(
                _checkbox.onClick.listen((_) => prop.value = _checkbox.checked ? _checkbox.value : ""));

            _subscriptions.add(
                prop.onChange.listen( (final PropertyChangeEvent event) =>
                _checkbox.value == prop.value.toString() || prop.toBool() ? _checkbox.checked = true : _checkbox.checked = false));

            // Check avoids unnecessary updates
            final bool newState = _checkbox.value == prop.value.toString() || prop.toBool();
            if(_checkbox.checked != newState) {
                _checkbox.checked = newState;
            }

        } else if(val != null) {

            _checkbox.checked = val.toString() == _checkbox.value;
            _logger.warning("${fieldname} is not Observable, MaterialCheckbox will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
        return _subscriptions;
    }

    //- private -----------------------------------------------------------------------------------

    _CheckBoxObserver._internal(this._checkbox) {
        Validate.notNull(_checkbox);
    }

}

class _RadioObserver implements ModelObserver {
    final Logger _logger = new Logger('mdldirective.RadioObserver');

    final MaterialRadioGroup _radioGroup;

    /// StreamSubscriptions registered by this Observer
    final List<StreamSubscription> _subscriptions = new List<StreamSubscription>();

    List<StreamSubscription> observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _subscriptions.add(
                _radioGroup.onGroupChange.listen((_) => _radioGroup.hasValue ? prop.value = _radioGroup.value : prop.value = ""));

            _subscriptions.add(
                prop.onChange.listen( (final PropertyChangeEvent event) => _radioGroup.value = prop.value.toString()));

            // Avoids unnecessary updates
            if(_radioGroup.value != prop.value.toString()) {
                _radioGroup.value = prop.value.toString();
            }

        } else if(val != null) {

            _radioGroup.value = val.toString();
            _logger.warning("${fieldname} is not Observable, RadioObserver will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
        return _subscriptions;
    }

    //- private -----------------------------------------------------------------------------------

    _RadioObserver._internal(this._radioGroup) {
        Validate.notNull(_radioGroup);
    }

}

class _SwitchObserver implements ModelObserver {
    final Logger _logger = new Logger('mdldirective.SwitchObserver');

    final MaterialSwitch _switch;

    /// StreamSubscriptions registered by this Observer
    final List<StreamSubscription> _subscriptions = new List<StreamSubscription>();

    List<StreamSubscription> observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _subscriptions.add(
                _switch.onClick.listen((_) => prop.value = _switch.checked ? _switch.value : ""));

            _subscriptions.add(
                prop.onChange.listen( (final PropertyChangeEvent event) =>
                _switch.value == prop.value.toString() || prop.toBool() ? _switch.checked = true : _switch.checked = false));

            // Avoids unnecessary updates
            final bool newState = _switch.value.toString() == prop.value || prop.toBool();
            if(_switch.checked != newState) {
                _switch.checked = newState;
            }

        } else if(val != null) {

            _switch.checked = _switch.value.toString() == val.toString();
            _logger.warning("${fieldname} is not Observable, SwitchObserver will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
        return _subscriptions;
    }

    //- private -----------------------------------------------------------------------------------

    _SwitchObserver._internal(this._switch) {
        Validate.notNull(_switch);
    }
}

class _SliderObserver implements ModelObserver {
    final Logger _logger = new Logger('mdldirective.SliderObserver');

    final MaterialSlider _slider;

    /// StreamSubscriptions registered by this Observer
    final List<StreamSubscription> _subscriptions = new List<StreamSubscription>();

    List<StreamSubscription> observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _subscriptions.add(
                _slider.onInput.listen( (_) => prop.value = _slider.value));

            _subscriptions.add(
                prop.onChange.listen( (final PropertyChangeEvent event) => _slider.value = ModelObserver.toInt(prop.value)));

            // Avoids unnecessary updates
            final int newValue = ModelObserver.toInt(prop.value);
            if(_slider.value != newValue) {
                _slider.value = newValue;
            }

        } else if(val != null) {

            _slider.value = ModelObserver.toInt(val.toString());
            _logger.warning("${fieldname} is not Observable, SliderObserver will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
        return _subscriptions;
    }

    //- private -----------------------------------------------------------------------------------

    _SliderObserver._internal(this._slider) {
        Validate.notNull(_slider);
    }
}

/// Default-Observer
///
/// Fits e.g. for span or div elements
class _HtmlElementObserver implements ModelObserver {
    final Logger _logger = new Logger('mdldirective.HtmlElementObserver');

    final MaterialModel _model;

    /// StreamSubscriptions registered by this Observer
    final List<StreamSubscription> _subscriptions = new List<StreamSubscription>();

    List<StreamSubscription> observe(final Scope scope,final String fieldname) {
        Validate.notNull(scope);
        Validate.notBlank(fieldname);

        final dom.HtmlElement _element = _model.element;

        final val = (new Invoke(scope)).field(fieldname);
        if (val != null && val is ObservableProperty) {

            final ObservableProperty prop = val;

            _subscriptions.add(
                prop.onChange.listen( (_) => _element.text = prop.value.toString()));

            // Changes the value in the _textfield only if prop.value is different
            // Avoids unnecessary _textfield-updates
            if(_element.text != prop.value.toString()) {
                _element.text = prop.value.toString();
            }

        } else if(val != null) {

            if(_element.text != val.toString()) {
                _element.text = val.toString();
            }
            _logger.warning("${fieldname} is not Observable, _HtmlElementObserver will not be able to set its value!");

        } else {

            throw new ArgumentError("${fieldname} is null!");
        }
        return _subscriptions;
    }

    //- private -----------------------------------------------------------------------------------

    _HtmlElementObserver._internal(this._model) {
        Validate.notNull(_model);
    }
}