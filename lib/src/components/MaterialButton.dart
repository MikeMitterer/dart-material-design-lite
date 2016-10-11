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
///     <button id="button" class="mdl-button">Flat</button>
///     <button class="mdl-button mdl-ripple-effect">Flat</button>
///     <button class="mdl-button mdl-button--fab">
///         <i class="material-icons">add</i>
///     </button>
///
///     final MaterialButton button = MaterialButton.widget(dom.querySelector("#button");
///     button.disable();
///
class MaterialButton extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialButton');

    static const _MaterialButtonConstant _constant = const _MaterialButtonConstant();
    static const _MaterialButtonCssClasses _cssClasses = const _MaterialButtonCssClasses();

    MaterialButton.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialButton widget(final dom.HtmlElement element) => mdlComponent(element,MaterialButton) as MaterialButton;

    /// Disable button.
    void disable() {
        (element as dom.ButtonElement).disabled = true;
    }

    /// Enable button.
    void enable() {
        (element as dom.ButtonElement).disabled = false;
    }

    void set enabled(final bool _enabled) => _enabled ? enable() : disable();
    bool get enabled => !(element as dom.ButtonElement).disabled;

    void set value(final String value) {
        if(value != null) {
            _valueElement.text = MaterialFormatter.widget(element).format(value);
        }
    }

    String get value => _valueElement.text;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialButton - init");

        if(element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
            final dom.SpanElement rippleContainer = new dom.SpanElement();
            rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);

            final dom.SpanElement rippleElement = new dom.SpanElement();
            rippleElement.classes.add(_cssClasses.RIPPLE);
            rippleContainer.append(rippleElement);

            eventStreams.add(rippleElement.onMouseUp.listen(_blurHandler));
            element.append(rippleContainer);
        }

        eventStreams.add(element.onMouseUp.listen(_blurHandler));
        eventStreams.add(element.onMouseLeave.listen(_blurHandler));

        /// Reformat according to [MaterialFormatter] definition
        void _kickInFormatter() {
            value = value;
        }
        _kickInFormatter();

        element.classes.add(_cssClasses.IS_UPGRADED);
        _logger.finer("MaterialButton - init done...");
    }

    void _blurHandler(final dom.MouseEvent event) {
        _logger.finer("blur...");
        element.blur();
    }

    /// If <button> has children like material-icons it returns the first child
    /// and assumes this is the element to set the value for
    dom.Node get _valueElement {
        dom.Node valueElement = element;

        if(valueElement.hasChildNodes()) {
            valueElement = valueElement.firstChild;
        }
        return valueElement;
    }
}

/// Registers the MaterialButton-Component
///
///     main() {
///         registerMaterialButton();
///         ...
///     }
///
void registerMaterialButton() {
    /// creates MdlConfig for MaterialButton
    final MdlConfig config = new MdlWidgetConfig<MaterialButton>(
        _MaterialButtonCssClasses.MAIN_CLASS,
            (final dom.HtmlElement element,final di.Injector injector)
                => new MaterialButton.fromElement(element,injector));

    componentHandler().register(config);
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialButtonCssClasses {

    static const String MAIN_CLASS  = "mdl-button";

    final String RIPPLE_EFFECT =      'mdl-ripple-effect';
    final String RIPPLE_CONTAINER =   'mdl-button__ripple-container';
    final String RIPPLE =             'mdl-ripple';

    final String IS_UPGRADED        = 'is-upgraded';

    const _MaterialButtonCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialButtonConstant { const _MaterialButtonConstant(); }

