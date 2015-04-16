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
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialButtonCssClasses {

    final String RIPPLE_EFFECT =      'mdl-js-ripple-effect';
    final String RIPPLE_CONTAINER =   'mdl-button__ripple-container';
    final String RIPPLE =             'mdl-ripple';

    const _MaterialButtonCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialButtonConstant { const _MaterialButtonConstant(); }

/// creates MdlConfig for MaterialButton
MdlConfig materialButtonConfig() => new MdlWidgetConfig<MaterialButton>(
    "mdl-js-button",(final html.HtmlElement element) => new MaterialButton.fromElement(element));

/// registration-Helper
void registerMaterialButton() => componenthandler.register(materialButtonConfig());

class MaterialButton extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialButton');

    static const _MaterialButtonConstant _constant = const _MaterialButtonConstant();
    static const _MaterialButtonCssClasses _cssClasses = const _MaterialButtonCssClasses();

    MaterialButton.fromElement(final html.HtmlElement element) : super(element) {
        _logger.fine("MaterialButton - CTOR");
        _init();
    }

    static MaterialButton widget(final html.HtmlElement element) => mdlComponent(element) as MaterialButton;

    /// Disable button.
    void disable() {
        element.disabled = true;
    }

    /// Enable button.
    void enable() {
        element.disabled = false;
    }

    void set disabled(final bool _disabled) => _disabled ? disable() : enable();
    bool get disabled => element.disabled;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialButton - init");

        if(element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
            final html.SpanElement rippleContainer = new html.Element.span();
            rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);

            final html.SpanElement ripple = new html.Element.span();
            ripple.classes.add(_cssClasses.RIPPLE);
            rippleContainer.append(ripple);

            ripple.onMouseUp.listen(_blurHandler);
            element.append(rippleContainer);

            _logger.fine("MaterialButton - init done...");
        }

        element.onMouseUp.listen(_blurHandler);

        element.onMouseLeave.listen(_blurHandler);
    }

    void _blurHandler(final html.MouseEvent event) {
        _logger.fine("blur...");
        element.blur();
    }
}

