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
///     <label class="mdl-switch mdl-ripple-effect" for="switch-1">
///       <input type="checkbox" id="switch-1" class="mdl-switch__input" >
///       <span class="mdl-switch__label">Switch me</span>
///     </label>
///
///     final MaterialSwitch materialswitch = MaterialSwitch.widget(querySelector("#switch-1"));
///     materialswitch.off();
///
class MaterialSwitch extends MdlComponent with FallbackFormatter {
    final Logger _logger = new Logger('mdlcomponents.MaterialSwitch');

    static const _MaterialSwitchConstant _constant = const _MaterialSwitchConstant();
    static const _MaterialSwitchCssClasses _cssClasses = const _MaterialSwitchCssClasses();

    dom.CheckboxInputElement _inputElement = null;

    MaterialSwitch.fromElement(final dom.HtmlElement element,final Injector injector)
        : super(element,injector) {
        _init();
    }

    /// First checks if [element] is a [MaterialSwitch] - if so, it returns the widget,
    /// if not it queries for the input-element (this is where MaterialSwitch is registered)
    static MaterialSwitch widget(final dom.HtmlElement element) {
        MaterialSwitch switchElement;
        try {
            switchElement = mdlComponent(element,MaterialSwitch,showWarning: false) as MaterialSwitch;

        } on String {
            final dom.HtmlElement inputField = element.querySelector(".${_cssClasses.INPUT}");
            switchElement = mdlComponent(inputField,MaterialSwitch) as MaterialSwitch;
        }
        return switchElement;
    }
    

    /**
     * Makes it possible to get the "widget" from the components input-element instead of its mdl-class
     * Sample:
     *      <label class="mdl-switch mdl-ripple-effect" for="switch-1">
     *          <input type="checkbox" id="switch-1" class="mdl-switch__input" />
     *          <span class="mdl-switch__label">Switch me</span>
     *      </label>
     *
     *      final MaterialSwitch switch = MaterialSwitch.widget(dom.querySelector("#switch-1"));
     */
    dom.Element get hub => inputElement;

    dom.CheckboxInputElement get inputElement {
        if(_inputElement == null) { _inputElement = element.querySelector(".${_cssClasses.INPUT}"); }
        return _inputElement;
    }

    /// Disable switch.
    void disable() {
        inputElement.disabled = true;
        _updateClasses();
    }

    /// Enable switch.
    void enable() {
        inputElement.disabled = false;
        _updateClasses();
    }

    /// Activate switch.
    void on() {
        inputElement.checked = true;
        _updateClasses();
    }

    /// Deactivate switch.
    void off() {
        inputElement.checked = false;
        _updateClasses();
    }

    /// Returns the checked-state
    bool get checked => inputElement.checked;

    void set checked(final bool _checked) => _checked ? on() : off();

    String get label {
        final dom.HtmlElement _label = element.querySelector(".${_cssClasses.LABEL}");
        return _label != null ? _label.text.trim() : "";
    }

    void set label(final String v) {
        Validate.notNull(v);

        final dom.HtmlElement _label = element.querySelector(".${_cssClasses.LABEL}");
        _label?.text = formatterFor(_label,element).format(v.trim());
    }

    /// Returns the value for the given [inputElement]
    String get value => inputElement.value.trim();

    void set value(final String value) {
        Validate.notNull(value);
        inputElement.value = formatterFor(inputElement,element).format(value);
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialSwitch - init");

        if (element != null) {

            final dom.DivElement track = new dom.DivElement();
            track.classes.add(_cssClasses.TRACK);

            final dom.DivElement thumb = new dom.DivElement();
            thumb.classes.add(_cssClasses.THUMB);

            final dom.SpanElement focusHelper = new dom.SpanElement();
            focusHelper.classes.add(_cssClasses.FOCUS_HELPER);

            thumb.append(focusHelper);

            element.append(track);
            element.append(thumb);


            if (element.classes.contains(
                _cssClasses.RIPPLE_EFFECT)) {
                element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

                final dom.SpanElement rippleContainerElement = new dom.SpanElement();
                rippleContainerElement.classes.add(_cssClasses.RIPPLE_CONTAINER);
                rippleContainerElement.classes.add(_cssClasses.RIPPLE_EFFECT);
                rippleContainerElement.classes.add(_cssClasses.RIPPLE_CENTER);

                eventStreams.add(rippleContainerElement.onMouseUp.listen( _onMouseUp));

                final dom.SpanElement ripple = new dom.SpanElement();
                ripple.classes.add(_cssClasses.RIPPLE);

                rippleContainerElement.append(ripple);
                element.append(rippleContainerElement);
            }

            eventStreams.add(inputElement.onChange.listen( _onChange ));

            eventStreams.add(inputElement.onFocus.listen( _onFocus ));

            eventStreams.add(inputElement.onBlur.listen( _onBlur ));

            eventStreams.add(element.onMouseUp.listen( _onMouseUp ));

            _updateClasses();

            /// Reformat according to [MaterialFormatter] definition
            void _kickInFormatter() {
                label = label;
                value = value;
            }
            _kickInFormatter();

            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Handle change of state.
    void _onChange(_) {
        _updateClasses();
    }

    /// Handle focus of element.
    void _onFocus(_) {
        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus of element.
    void _onBlur(_) {
        element.classes.remove(_cssClasses.IS_FOCUSED);
    }

    /// Handle mouseup.
    void _onMouseUp(_) {
        _blur();
    }

    /// Handle class updates.
    void _updateClasses() {

        _checkDisabled();
        _checkToggleState();

    }

    /// Check the components disabled state.
    void _checkDisabled() {
        if (_inputElement.disabled) {
            element.classes.add(_cssClasses.IS_DISABLED);

        } else {
            element.classes.remove(_cssClasses.IS_DISABLED);
        }
    }

    /// Check the components toggled state.
    void _checkToggleState() {
        if (_inputElement.checked) {
            element.classes.add(_cssClasses.IS_CHECKED);

        } else {
            element.classes.remove(_cssClasses.IS_CHECKED);
        }
    }

    void _blur() {
        // TODO: figure out why there's a focus event being fired after our blur,
        // so that we can avoid this hack.
        new Timer(new Duration(milliseconds : _constant.TINY_TIMEOUT_IN_MS ), () {
            inputElement.blur();
        });
    }
}

/// creates MdlConfig for MaterialSwitch
MdlConfig materialSwitchConfig() => new MdlWidgetConfig<MaterialSwitch>(
    _MaterialSwitchCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final Injector injector)
=> new MaterialSwitch.fromElement(element,injector));

/// registration-Helper
void registerMaterialSwitch() => componentHandler().register(materialSwitchConfig());

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialSwitchCssClasses {

    static const String MAIN_CLASS  = "mdl-switch";

    final String INPUT = 'mdl-switch__input';

    final String LABEL = 'mdl-switch__label';

    final String TRACK = 'mdl-switch__track';

    final String THUMB = 'mdl-switch__thumb';

    final String FOCUS_HELPER = 'mdl-switch__focus-helper';

    final String RIPPLE_EFFECT = 'mdl-ripple-effect';

    final String RIPPLE_IGNORE_EVENTS = 'mdl-ripple-effect--ignore-events';

    final String RIPPLE_CONTAINER = 'mdl-switch__ripple-container';

    final String RIPPLE_CENTER = 'mdl-ripple--center';

    final String RIPPLE = 'mdl-ripple';

    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialSwitchCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialSwitchConstant {
    final int TINY_TIMEOUT_IN_MS = 100;

    const _MaterialSwitchConstant();
}