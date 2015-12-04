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
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialButtonCssClasses {

    static const String MAIN_CLASS  = "mdl-js-button";

    final String RIPPLE_EFFECT =      'mdl-js-ripple-effect';
    final String RIPPLE_CONTAINER =   'mdl-button__ripple-container';
    final String RIPPLE =             'mdl-ripple';

    const _MaterialButtonCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialButtonConstant { const _MaterialButtonConstant(); }

/// creates MdlConfig for MaterialButton
MdlConfig materialButtonConfig() => new MdlWidgetConfig<MaterialButton>(
    _MaterialButtonCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialButton.fromElement(element,injector));

/// registration-Helper
void registerMaterialButton() => componentHandler().register(materialButtonConfig());

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

            _logger.finer("MaterialButton - init done...");
        }

        eventStreams.add(element.onMouseUp.listen(_blurHandler));
        eventStreams.add(element.onMouseLeave.listen(_blurHandler));
    }

    void _blurHandler(final dom.MouseEvent event) {
        _logger.finer("blur...");
        element.blur();
    }
}

