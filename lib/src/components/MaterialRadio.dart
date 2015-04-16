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
class _MaterialRadioCssClasses {
    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';

    final String IS_UPGRADED = 'is-upgraded';

    final String JS_RADIO = 'mdl-js-radio';

    final String RADIO_BTN = 'mdl-radio__button';

    final String RADIO_OUTER_CIRCLE = 'mdl-radio__outer-circle';

    final String RADIO_INNER_CIRCLE = 'mdl-radio__inner-circle';

    final String RIPPLE_EFFECT = 'mdl-js-ripple-effect';

    final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';

    final String RIPPLE_CONTAINER = 'mdl-radio__ripple-container';

    final String RIPPLE_CENTER = 'mdl-ripple--center';

    final String RIPPLE = 'mdl-ripple';

    const _MaterialRadioCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialRadioConstant {
    final int TINY_TIMEOUT_IN_MS = 10;
    const _MaterialRadioConstant();
}

/// creates MdlConfig for RadioConfig
MdlConfig materialRadioConfig() => new MdlWidgetConfig<MaterialRadio>(
    "mdl-js-radio", (final html.HtmlElement element) => new MaterialRadio.fromElement(element));

/// registration-Helper
void registerMaterialRadio() => componenthandler.register(materialRadioConfig());

/**
 * Sample:
 *      <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="wifi1">
 *          <input type="radio" id="wifi1" class="mdl-radio__button" name="wifi[]" value="1" checked />
 *          <span class="mdl-radio__label">Always</span>
 *      </label>
 */
class MaterialRadio extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialRadio');

    static const _MaterialRadioConstant _constant = const _MaterialRadioConstant();
    static const _MaterialRadioCssClasses _cssClasses = const _MaterialRadioCssClasses();

    html.RadioButtonInputElement _btnElement = null;

    factory MaterialRadio(final html.HtmlElement element) => mdlComponent(element) as MaterialRadio;

    MaterialRadio.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialRadio widget(final html.HtmlElement element) => mdlComponent(element) as MaterialRadio;


    html.Element get hub => btnElement;

    html.RadioButtonInputElement get btnElement {
        if(_btnElement == null) {
            _btnElement = element.querySelector(".${_cssClasses.RADIO_BTN}");
        }
        return _btnElement;
    }


    /// Disable radio.
    /// @public
    /// MaterialRadio.prototype.disable = /*function*/ () {
    void disable() {

        btnElement.disabled = true;
        _updateClasses(btnElement, element);
    }

    /// Enable radio.
    /// @public
    /// MaterialRadio.prototype.enable = /*function*/ () {
    void enable() {

        btnElement.disabled = false;
        _updateClasses(btnElement, element);
    }

    /// Check radio.
    /// @public
    /// MaterialRadio.prototype.check = /*function*/ () {
    void check() {

        btnElement.checked = true;
        _updateClasses(btnElement, element);
    }

    /// Uncheck radio.
    /// @public
    /// MaterialRadio.prototype.uncheck = /*function*/ () {
    void uncheck() {

        btnElement.checked = false;
        _updateClasses(btnElement, element);
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialRadio - init");

        if (element != null) {

            final outerCircle = new html.SpanElement();
            outerCircle.classes.add(_cssClasses.RADIO_OUTER_CIRCLE);

            final innerCircle = new html.SpanElement();
            innerCircle.classes.add(_cssClasses.RADIO_INNER_CIRCLE);

            element.append(outerCircle);
            element.append(innerCircle);

            if (element.classes.contains(
                _cssClasses.RIPPLE_EFFECT)) {
                element.classes.add(
                    _cssClasses.RIPPLE_IGNORE_EVENTS);

                final html.SpanElement rippleContainer = new html.SpanElement();
                rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
                rippleContainer.classes.add(_cssClasses.RIPPLE_EFFECT);
                rippleContainer.classes.add(_cssClasses.RIPPLE_CENTER);

                rippleContainer.onMouseUp.listen( _onMouseUp );

                final html.SpanElement ripple = new html.SpanElement();
                ripple.classes.add(_cssClasses.RIPPLE);

                rippleContainer.append(ripple);
                element.append(rippleContainer);
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
        final List<html.Element> radios = html.querySelectorAll('.' + _cssClasses.JS_RADIO);

        for (int i = 0; i < radios.length; i++) {

            final html.RadioButtonInputElement button = radios[i].querySelector('.' + _cssClasses.RADIO_BTN);
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

