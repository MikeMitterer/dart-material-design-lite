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

    static const String MAIN_CLASS  = "mdl-js-radio";
    static const String GROUP_CLASS = 'mdl-radio-group';

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

/// creates MdlConfig for MaterialRadio
MdlConfig materialRadioConfig() => new MdlWidgetConfig<MaterialRadio>(
    _MaterialRadioCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialRadio.fromElement(element,injector));

/// registration-Helper
void registerMaterialRadio() => componentHandler().register(materialRadioConfig());

/// creates MdlConfig for MaterialRadio
MdlConfig materialRadioGroupConfig() => new MdlWidgetConfig<MaterialRadioGroup>(
    _MaterialRadioCssClasses.GROUP_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialRadioGroup.fromElement(element,injector));

/// registration-Helper
void registerMaterialRadioGroup() => componentHandler().register(materialRadioGroupConfig());

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

    dom.RadioButtonInputElement _btnElement = null;

    //factory MaterialRadio(final dom.HtmlElement element) => mdlComponent(element,MaterialRadio) as MaterialRadio;

    MaterialRadio.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialRadio widget(final dom.HtmlElement element) => mdlComponent(element,MaterialRadio) as MaterialRadio;


    /**
     * Makes it possible to get the "widget" from the components input-element instead of its mdl-class
     * Sample:
     *      <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="wifi2">
     *          <input type="radio" id="wifi2" class="mdl-radio__button" name="wifi[]" value="2"/>
     *          <span class="mdl-radio__label">Only when plugged in</span>
     *      </label>
     *
     *      MaterialRadio.widget(dom.querySelector("#wifi2")).disable();
     */
    dom.Element get hub => btnElement;

    dom.RadioButtonInputElement get btnElement {
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

        _uncheckSiblings();

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

    bool get checked => btnElement.checked;

    void set checked(final bool value) => value ? check() : uncheck();

    String get value => btnElement.value;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialRadio - init");

        if (element != null) {

            final outerCircle = new dom.SpanElement();
            outerCircle.classes.add(_cssClasses.RADIO_OUTER_CIRCLE);

            final innerCircle = new dom.SpanElement();
            innerCircle.classes.add(_cssClasses.RADIO_INNER_CIRCLE);

            element.append(outerCircle);
            element.append(innerCircle);

            if (element.classes.contains(
                _cssClasses.RIPPLE_EFFECT)) {
                element.classes.add(
                    _cssClasses.RIPPLE_IGNORE_EVENTS);

                final dom.SpanElement rippleContainer = new dom.SpanElement();
                rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
                rippleContainer.classes.add(_cssClasses.RIPPLE_EFFECT);
                rippleContainer.classes.add(_cssClasses.RIPPLE_CENTER);

                rippleContainer.onMouseUp.listen( _onMouseUp );

                final dom.SpanElement ripple = new dom.SpanElement();
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
    void _onChange(final dom.Event event) {

        _updateClasses(_btnElement, element);

        // Since other radio buttons don't get change events, we need to look for
        // them to update their classes.
        final List<dom.Element> radios = dom.querySelectorAll('.' + _cssClasses.JS_RADIO);

        for (int i = 0; i < radios.length; i++) {

            final dom.RadioButtonInputElement button = radios[i].querySelector('.' + _cssClasses.RADIO_BTN);
            // Different name == different group, so no point updating those.
            if (button.getAttribute('name') == _btnElement.getAttribute('name')) {
                _updateClasses(button, radios[i]);
            }
        }

        _informParentAboutChange();
    }

    /// Handle focus.
    void _onFocus(final dom.Event event) {
        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus.
    void _onBlur(final dom.Event event) {
        element.classes.remove(_cssClasses.IS_FOCUSED);
    }

    /// Handle mouseup.
    void _onMouseUp(final dom.MouseEvent event) {
        _blur();
    }

    /// Update classes.
    void _updateClasses(final dom.RadioButtonInputElement  button, final dom.HtmlElement label) {

        _checkDisabled(button,label);
        _checkToggleState(button,label);
    }

    /// Check the components disabled state.
    /// public
    ///
    /// MaterialRadio.prototype.checkDisabled = /*function*/ () {
    void _checkDisabled(final dom.RadioButtonInputElement  button, final dom.HtmlElement label) {
        if (button.disabled) {

            label.classes.add(_cssClasses.IS_DISABLED);

        } else {
            label.classes.remove(_cssClasses.IS_DISABLED);
        }
    }

    /// Check the components toggled state.
    /// public
    ///
    /// MaterialRadio.prototype.checkToggleState = /*function*/ () {
    void _checkToggleState(final dom.RadioButtonInputElement  button, final dom.HtmlElement label) {
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

    /// Looks for the parent class .mdl-radio-group. If it finds the class
    /// it iterates over its children and unchecks each mdl-radio child.
    void _uncheckSiblings() {
        if(element.parent.classes.contains(_MaterialRadioCssClasses.GROUP_CLASS)) {
            final dom.HtmlElement group = element.parent;
            group.children.forEach((final dom.Element child) {
                final MaterialRadio widget = MaterialRadio.widget(child.querySelector(".${_cssClasses.RADIO_BTN}"));

                if(widget != null && widget != this) {
                    widget.uncheck();
                }

            });
        }
    }

    /// If this radio has a parent with .mdl-radio-group set it calls it's childChanged functions
    void _informParentAboutChange() {
        if(element.parent.classes.contains(_MaterialRadioCssClasses.GROUP_CLASS)) {
            final MaterialRadioGroup group = MaterialRadioGroup.widget(element.parent);
            if(group != null) {
                group.childChanged(this);
            }
        }
    }
}

/// Fired by [MaterialRadioGroup] on [childChanged]
class MaterialRadioGroupChangedEvent {
    final MaterialRadioGroup group;
    MaterialRadioGroupChangedEvent(this.group);
}

class MaterialRadioGroup extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialRadioGroup');

    static const _MaterialRadioCssClasses _cssClasses = const _MaterialRadioCssClasses();

    StreamController<MaterialRadioGroupChangedEvent> _onGroupChange;

    MaterialRadioGroup.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialRadioGroup widget(final dom.HtmlElement element) => mdlComponent(element,MaterialRadioGroup) as MaterialRadioGroup;

    bool get hasValue {
        bool _hasValue = false;
        element.children.forEach((final dom.HtmlElement child) {
            final MaterialRadio radio = MaterialRadio.widget(child.querySelector(".${_cssClasses.RADIO_BTN}"));
            if(radio != null && radio.checked) {
                _hasValue = true;
            }
        });
        return _hasValue;
    }

    String get value {
        String _value = "";
        element.children.forEach((final dom.HtmlElement child) {

            final MaterialRadio radio = MaterialRadio.widget(child.querySelector(".${_cssClasses.RADIO_BTN}"));
            if(radio != null && radio.checked) {
                _value = radio.value;
            }

        });
        return _value;
    }

    void set value(final String val) {
        element.children.forEach((final dom.HtmlElement child) {

            final MaterialRadio radio = MaterialRadio.widget(child.querySelector(".${_cssClasses.RADIO_BTN}"));
            if(radio != null) {

                if(radio.value == val) {
                    radio.check();
                } else {
                    radio.uncheck();
                }

            }
        });
    }

    /// Called in the children's _onChange function to inform its parent about changes
    void childChanged(final MaterialRadio child) {
        _fire(new MaterialRadioGroupChangedEvent(this));
    }

    Stream<MaterialRadioGroupChangedEvent> get onGroupChange {
        if(_onGroupChange == null) {
            _onGroupChange = new StreamController<MaterialRadioGroupChangedEvent>.broadcast(onCancel: () => _onGroupChange = null);
        }
        return _onGroupChange.stream;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialRadioGroup - init");

        if (element != null) {
            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    void _fire(final MaterialRadioGroupChangedEvent event) {
        if(_onGroupChange != null && _onGroupChange.hasListener) {
            _onGroupChange.add(event);
        }
    }
}

