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

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialCheckboxCssClasses {
    static const String MAIN_CLASS = "mdl-js-checkbox";

    final String INPUT = 'mdl-checkbox__input';

    final String BOX_OUTLINE = 'mdl-checkbox__box-outline';

    final String FOCUS_HELPER = 'mdl-checkbox__focus-helper';

    final String TICK_OUTLINE = 'mdl-checkbox__tick-outline';

    final String RIPPLE_EFFECT = 'mdl-js-ripple-effect';

    final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';

    final String RIPPLE_CONTAINER = 'mdl-checkbox__ripple-container';

    final String RIPPLE_CENTER = 'mdl-ripple--center';

    final String RIPPLE = 'mdl-ripple';

    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialCheckboxCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialCheckboxConstant {
    
    final int TINY_TIMEOUT_IN_MS = 100;

    final String DEFAULT_OFF_VALUE = "off";

    const _MaterialCheckboxConstant();
}

/// creates MdlConfig for MaterialCheckbox
MdlConfig materialCheckboxConfig() => new MdlWidgetConfig<MaterialCheckbox>(
    _MaterialCheckboxCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialCheckbox.fromElement(element,injector));

/// registration-Helper
void registerMaterialCheckbox() => componentHandler().register(materialCheckboxConfig());

/**
 * Sample:
 *     <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="checkbox-1">
 *          <input type="checkbox" id="checkbox-1" class="mdl-checkbox__input" />
 *          <span class="mdl-checkbox__label">Check me out</span>
 *    </label>
 */
class MaterialCheckbox extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialCheckbox');

    static const _MaterialCheckboxConstant _constant = const _MaterialCheckboxConstant();
    static const _MaterialCheckboxCssClasses _cssClasses = const _MaterialCheckboxCssClasses();

    dom.CheckboxInputElement _inputElement = null;

    MaterialCheckbox.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialCheckbox widget(final dom.HtmlElement element) => mdlComponent(element,MaterialCheckbox) as MaterialCheckbox;

    /**
     * Makes it possible to get the "widget" from the components input-element instead of its mdl-class
     * Sample:
     *      <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="checkbox-2">
     *          <input type="checkbox" id="checkbox-2" class="mdl-checkbox__input" />
     *          <span class="mdl-checkbox__label">I'm just a Material girl in a Material world</span>
     *      </label>
     *
     *      MaterialCheckbox.widget(dom.querySelector("#checkbox-2")).disable();
     */
    dom.Element get hub => inputElement;

    dom.CheckboxInputElement get inputElement {
        if(_inputElement == null) {
            _inputElement = element.querySelector(".${_cssClasses.INPUT}");
        }
        return _inputElement;
    }

    /// Disable checkbox.
    void disable() {

        inputElement.disabled = true;
        _updateClasses();
    }

    /// Enable checkbox.
    void enable() {

        inputElement.disabled = false;
        _updateClasses();
    }

    /// Check checkbox.
    void check() {

        inputElement.checked = true;
        _updateClasses();
    }

    /// Uncheck checkbox.
    void uncheck() {

        inputElement.checked = false;
        _updateClasses();
    }

    void set checked(final bool _checked) => _checked ? check() : uncheck();
    bool get checked => inputElement.checked;

    void set disabled(final bool _disabled) => _disabled ? disable() : enable();
    bool get disabled => inputElement.disabled;

    String get value => inputElement.value.trim();

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialCheckbox - init");

        final dom.SpanElement boxOutline = new dom.SpanElement();
        boxOutline.classes.add(_cssClasses.BOX_OUTLINE);

        final dom.SpanElement tickContainer = new dom.SpanElement();
        tickContainer.classes.add(_cssClasses.FOCUS_HELPER);

        final dom.SpanElement tickOutline = new dom.SpanElement();
        tickOutline.classes.add(_cssClasses.TICK_OUTLINE);

        boxOutline.append(tickOutline);

        element.append(tickContainer);
        element.append(boxOutline);

        dom.SpanElement rippleContainerElement;
        if (element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
            element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

            rippleContainerElement = new dom.SpanElement();
            rippleContainerElement.classes.add(_cssClasses.RIPPLE_CONTAINER);
            rippleContainerElement.classes.add(_cssClasses.RIPPLE_EFFECT);
            rippleContainerElement.classes.add(_cssClasses.RIPPLE_CENTER);

            eventStreams.add(rippleContainerElement.onMouseUp.listen(_onMouseUp));

            final dom.SpanElement ripple = new dom.SpanElement();
            ripple.classes.add(_cssClasses.RIPPLE);

            rippleContainerElement.append(ripple);
            element.append(rippleContainerElement);
        }

        eventStreams.add(inputElement.onChange.listen(_onChange));

        eventStreams.add(inputElement.onFocus.listen(_onFocus));

        eventStreams.add(inputElement.onBlur.listen(_onBlur));

        eventStreams.add(element.onMouseUp.listen(_onMouseUp));

        // Solves slow Touch on iOS...
        // element.onTouchEnd.listen((_) {
        //     checked = !checked;
        // });

        _updateClasses();
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// Handle change of state.
    void _onChange(final dom.Event event) {
        _updateClasses();
    }

    /// Handle focus of element.
    void _onFocus(final dom.Event event) {
        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus of element.
    void _onBlur(final dom.Event  event) {
        element.classes.remove(_cssClasses.IS_FOCUSED);
    }

    /// Handle mouseup.
    void _onMouseUp(final dom.Event event) {
        _blur();
    }

    /**
     * Handle class updates.
     */
    void _updateClasses() {
        _checkDisabled();
        _checkToggleState();
    }

    /// Check the inputs toggle state and update display.
    void _checkToggleState() {
        if (_inputElement.checked) {
            element.classes.add(_cssClasses.IS_CHECKED);

        } else {
            element.classes.remove(_cssClasses.IS_CHECKED);
        }
    }

    /// Check the inputs disabled state and update display.
    void _checkDisabled() {
        if (_inputElement.disabled) {
            element.classes.add(_cssClasses.IS_DISABLED);

        } else {
            element.classes.remove(_cssClasses.IS_DISABLED);
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

