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
class _MaterialIconToggleCssClasses {

    static const String MAIN_CLASS  = "mdl-js-icon-toggle";

    final String INPUT = 'mdl-icon-toggle__input';
    final String JS_RIPPLE_EFFECT = 'mdl-js-ripple-effect';
    final String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
    final String RIPPLE_CONTAINER = 'mdl-icon-toggle__ripple-container';
    final String RIPPLE_CENTER = 'mdl-ripple--center';
    final String RIPPLE = 'mdl-ripple';
    final String IS_FOCUSED = 'is-focused';
    final String IS_DISABLED = 'is-disabled';
    final String IS_CHECKED = 'is-checked';
    final String IS_UPGRADED = 'is-upgraded';


    const _MaterialIconToggleCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialIconToggleConstant {

    final int TINY_TIMEOUT_IN_MS = 100;

    const _MaterialIconToggleConstant();
}

/// creates MdlConfig for MaterialIconToggle
MdlConfig materialIconToggleConfig() => new MdlWidgetConfig<MaterialIconToggle>(
    _MaterialIconToggleCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialIconToggle.fromElement(element,injector));

/// registration-Helper
void registerMaterialIconToggle() => componentHandler().register(materialIconToggleConfig());

/**
 * Sample:
 *       <label class="mdl-icon-toggle mdl-js-icon-toggle mdl-js-ripple-effect" for="checkbox-1">
 *           <input type="checkbox" id="checkbox-1" class="mdl-icon-toggle__input" />
 *           <span class="mdl-icon-toggle__label mdl-icon mdl-icon--format-bold"></span>
 *       </label>
 */
class MaterialIconToggle extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialIconToggle');

    static const _MaterialIconToggleConstant    _constant = const _MaterialIconToggleConstant();
    static const _MaterialIconToggleCssClasses  _cssClasses = const _MaterialIconToggleCssClasses();

    dom.InputElement _inputElement = null;

    MaterialIconToggle.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialIconToggle widget(final dom.HtmlElement element) => mdlComponent(element,MaterialIconToggle) as MaterialIconToggle;

    // Central Element - by default this is where mdl-icon-toggle was found (element)
    dom.Element get hub => inputElement;

    dom.InputElement get inputElement {
        if(_inputElement == null) {
            _inputElement = element.querySelector('.${_cssClasses.INPUT}');
        }
        return _inputElement;
    }


    /// Disable icon toggle
    void disable() {

        inputElement.disabled = true;
        _updateClasses();
    }

    /// Enable icon toggle.
    void enable() {

        inputElement.disabled = false;
        _updateClasses();
    }

    /// Check icon toggle.
    void check() {

        inputElement.checked = true;
        _updateClasses();
    }

    /// Uncheck icon toggle.
    void uncheck() {

        inputElement.checked = false;
        _updateClasses();
    }

    void set checked(final bool _checked) => _checked ? check() : uncheck();
    bool get checked => inputElement.checked;

    void set disabled(final bool _disabled) => _disabled ? disable() : enable();
    bool get disabled => inputElement.disabled;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialIconToggle - init");

        if (element != null) {

            if (element.classes.contains(_cssClasses.JS_RIPPLE_EFFECT)) {
                element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

                final dom.SpanElement rippleContainerElement = new dom.SpanElement();
                rippleContainerElement.classes.add(_cssClasses.RIPPLE_CONTAINER);
                rippleContainerElement.classes.add(_cssClasses.JS_RIPPLE_EFFECT);
                rippleContainerElement.classes.add(_cssClasses.RIPPLE_CENTER);

                eventStreams.add(rippleContainerElement.onMouseUp.listen(_onMouseUp));

                final ripple = new dom.SpanElement();
                ripple.classes.add(_cssClasses.RIPPLE);

                rippleContainerElement.append(ripple);
                element.append(rippleContainerElement);
            }

            eventStreams.add(inputElement.onChange.listen(_onChange));

            eventStreams.add(inputElement.onFocus.listen( _onFocus));

            eventStreams.add(inputElement.onBlur.listen( _onBlur));

            eventStreams.add(element.onMouseUp.listen(_onMouseUp));

            _updateClasses();
            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Handle change of state.
    void _onChange(_) {
        _updateClasses();
    }

    /// Handle focus of element.
    void _onFocus(final dom.Event event) {

        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus of element.
    void _onBlur(final dom.Event event) {

        element.classes.remove(_cssClasses.IS_FOCUSED);
    }

    /// Handle mouseup.
    void _onMouseUp(final dom.MouseEvent event) {
        _blur();
    }

    /// Handle class updates.
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

    /// Add blur.
    void _blur() {

        // TODO: figure out why there's a focus event being fired after our blur,
        // so that we can avoid this hack.
        new Timer(new Duration(milliseconds : _constant.TINY_TIMEOUT_IN_MS ), () {
            inputElement.blur();
        });
    }
}

