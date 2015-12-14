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
class _MaterialTooltipCssClasses {

    static const String MAIN_CLASS  = "mdl-tooltip";

    final String IS_ACTIVE = 'is-active';
    final String BOTTOM = 'mdl-tooltip--bottom';
    final String LEFT = 'mdl-tooltip--left';
    final String RIGHT = 'mdl-tooltip--right';
    final String TOP = 'mdl-tooltip--top';

    const _MaterialTooltipCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialTooltipConstant {
    const _MaterialTooltipConstant();
}

/// creates MdlConfig for MaterialTooltip
MdlConfig materialTooltipConfig() => new MdlWidgetConfig<MaterialTooltip>(
    _MaterialTooltipCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialTooltip.fromElement(element,injector));

/// registration-Helper
void registerMaterialTooltip() => componentHandler().register(materialTooltipConfig());

class MaterialTooltip extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialTooltip');

    static const _MaterialTooltipConstant _constant = const _MaterialTooltipConstant();
    static const _MaterialTooltipCssClasses _cssClasses = const _MaterialTooltipCssClasses();

    dom.HtmlElement _forElement = null;

    MaterialTooltip.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialTooltip widget(final dom.HtmlElement element) => mdlComponent(element,MaterialTooltip) as MaterialTooltip;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialTooltip - init");

        if (element != null) {

            final String forElId = element.getAttribute('for');

            if(forElId != null ) {
                _logger.info("ELEMENT: ${forElId}");

                _forElement = element.parent.querySelector("#${forElId}");

                if(_forElement != null) {
                    _logger.info("Found: ${forElId}");

                    // It's left here because it prevents accidental text selection on Android
                    if (!_forElement.attributes.containsKey('tabindex')) {
                        _forElement.attributes['tabindex'] = '0';
                    }

                    eventStreams.add(_forElement.onMouseEnter.listen( _handleMouseEnter ));
                    eventStreams.add(_forElement.onTouchEnd.listen( _handleMouseEnter));

                    eventStreams.add(_forElement.onMouseLeave.listen( _handleMouseLeave));
                    eventStreams.add(dom.window.onTouchStart.listen( (final dom.Event event) {
                        event.stopPropagation();
                        _handleMouseLeave(event);
                    }));

                }
            }
        }
    }

    /// Handle mouseenter for tooltip.
    void _handleMouseEnter(final dom.Event event) {
        if(element.classes.contains(_cssClasses.IS_ACTIVE)) {
            element.classes.remove(_cssClasses.IS_ACTIVE);
            return;
        }

        final Math.Rectangle props = _forElement.getBoundingClientRect();

        int left = props.left + (props.width / 2);

        final int top = props.top + (props.height / 2);

        final double marginLeft = -1 * (element.offsetWidth / 2);

        final double marginTop = -1 * (element.offsetHeight / 2);

        if (element.classes.contains(_cssClasses.LEFT) || element.classes.contains(_cssClasses.RIGHT)) {

            left = (props.width / 2);
            if (top + marginTop < 0) {
                element.style.top = "0";
                element.style.marginTop = "0";

            } else {
                element.style.top = "${top}px";
                element.style.marginTop = "${marginTop}px";
            }

        } else {
            if (left + marginLeft < 0) {
                element.style.left = "0";
                element.style.marginLeft = "0";

            } else {
                element.style.left = "${left}px";
                element.style.marginLeft = "${marginLeft}px";
            }
        }

        if (element.classes.contains(_cssClasses.TOP)) {
            element.style.top = "${props.top - element.offsetHeight - 10}px";
        } else if (element.classes.contains(_cssClasses.RIGHT)) {
            element.style.left = "${props.left + props.width + 10}px";
        } else if (element.classes.contains(_cssClasses.LEFT)) {
            element.style.left = "${props.left - element.offsetWidth - 10}px";

        } else {
            element.style.top = "${props.top + props.height + 10}px";
        }

        element.classes.add(_cssClasses.IS_ACTIVE);
    }

    /// Handle mouseleave for tooltip.
    /// @param {Event} event The event that fired.
    /// MaterialTooltip.prototype.handleMouseLeave_ = function(event) {
    void _handleMouseLeave(final dom.Event event) {
        element.classes.remove(_cssClasses.IS_ACTIVE);
    }
}

