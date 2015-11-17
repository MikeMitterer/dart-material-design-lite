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
class _MaterialSliderCssClasses {

    static const String MAIN_CLASS  = "mdl-js-slider";

    final String IE_CONTAINER = 'mdl-slider__ie-container';

    final String SLIDER_CONTAINER = 'mdl-slider__container';

    final String BACKGROUND_FLEX = 'mdl-slider__background-flex';

    final String BACKGROUND_LOWER = 'mdl-slider__background-lower';

    final String BACKGROUND_UPPER = 'mdl-slider__background-upper';

    final String IS_LOWEST_VALUE = 'is-lowest-value';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialSliderCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialSliderConstant {
    const _MaterialSliderConstant();
}

/// creates MdlConfig for MaterialSlider
MdlConfig materialSliderConfig() => new MdlWidgetConfig<MaterialSlider>(
    _MaterialSliderCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialSlider.fromElement(element,injector));

/// registration-Helper
void registerMaterialSlider() => componentHandler().register(materialSliderConfig());

class MaterialSlider extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialSlider');

    static const _MaterialSliderConstant _constant = const _MaterialSliderConstant();
    static const _MaterialSliderCssClasses _cssClasses = const _MaterialSliderCssClasses();

    // Browser feature detection.
    final bool _isIE = browser.isIe;

    dom.DivElement _backgroundLower = null;
    dom.DivElement _backgroundUpper = null;

    MaterialSlider.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialSlider widget(final dom.HtmlElement element) => mdlComponent(element,MaterialSlider) as MaterialSlider;

    dom.RangeInputElement get slider => super.element as dom.RangeInputElement;

    /// Disable slider.
    void disable() {

        slider.disabled = true;
    }

    /// Enable slider.
    void enable() {

        slider.disabled = false;
    }

    /// Update slider value.
    void set value(final int value) {
        slider.value = value.toString();
        _updateValueStyles();
    }

    int get value => int.parse(slider.value);

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialSlider - init");

        if (element != null) {
            if (_isIE) {

                // Since we need to specify a very large height in IE due to
                // implementation limitations, we add a parent here that trims it down to
                // a reasonable size.
                final dom.DivElement containerIE = new dom.DivElement();
                containerIE.classes.add(_cssClasses.IE_CONTAINER);
                element.parent.insertBefore(containerIE, element);
                element.remove();
                containerIE.append(element);

            } else {
                // For non-IE browsers, we need a div structure that sits behind the
                // slider and allows us to style the left and right sides of it with
                // different colors.

                final dom.DivElement container = new dom.DivElement();
                container.classes.add(_cssClasses.SLIDER_CONTAINER);
                element.parent.insertBefore(container, element);
                element.remove();
                container.append(element);

                final dom.DivElement backgroundFlex = new dom.DivElement();
                backgroundFlex.classes.add(_cssClasses.BACKGROUND_FLEX);
                container.append(backgroundFlex);

                _backgroundLower = new dom.DivElement();
                _backgroundLower.classes.add(_cssClasses.BACKGROUND_LOWER);
                backgroundFlex.append(_backgroundLower);

                _backgroundUpper = new dom.DivElement();
                _backgroundUpper.classes.add(_cssClasses.BACKGROUND_UPPER);
                backgroundFlex.append(_backgroundUpper);
            }

            eventStreams.add(element.onInput.listen( _onInput ));

            eventStreams.add(element.onChange.listen( _onChange ));

            eventStreams.add(element.onMouseUp.listen( _onMouseUp ));

            eventStreams.add(element.parent.onMouseDown.listen(_onContainerMouseDown));

            _updateValueStyles();
            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Handle input on element.
    void _onInput(final dom.Event event) {
        _updateValueStyles();
    }

    /// Handle change on element.
    void _onChange(final dom.Event event) {
        _updateValueStyles();
    }

    /// Handle mouseup on element.
    void _onMouseUp(final dom.MouseEvent event) {
        element.blur();
    }

    /// Handle mousedown on container element.
    /// This handler is purpose is to not require the use to click
    /// exactly on the 2px slider element, as FireFox seems to be very
    /// strict about
    /// param {Event} event The event that fired.
    void _onContainerMouseDown(final dom.MouseEvent event) {

        // If this click is not on the parent element (but rather some child)
        // ignore. It may still bubble up.
        if(event.target != element.parent) {
            return;
        }

        // Discard the original event and create a new event that
        // is on the slider element.
        event.preventDefault();

        final newEvent = new dom.MouseEvent('mousedown',
            relatedTarget: event.target,
            button: 0,
            clientX: event.client.x.toInt(),
            clientY: (element.getBoundingClientRect().topLeft.y as double).toInt());

        element.dispatchEvent(newEvent);
    }

    /// Handle updating of values.
    void _updateValueStyles() {

        // Calculate and apply percentages to div structure behind slider.
        final num fraction = (int.parse(slider.value) - int.parse(slider.min)) /
        (int.parse(slider.max) - int.parse(slider.min));

        if (fraction == 0) {
            element.classes.add(_cssClasses.IS_LOWEST_VALUE);

        } else {
            element.classes.remove(_cssClasses.IS_LOWEST_VALUE);
        }

        if (! _isIE ) {
            _backgroundLower.style.flex = fraction.toString();
            _backgroundUpper.style.flex = (1 - fraction).toString();
        }
    }
}

