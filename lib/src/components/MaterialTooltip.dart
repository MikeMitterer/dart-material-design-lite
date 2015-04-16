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
class _MaterialTooltipCssClasses {
    final String IS_ACTIVE = 'is-active';

    const _MaterialTooltipCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialTooltipConstant {
    const _MaterialTooltipConstant();
}

/// creates MdlConfig for MaterialButton
MdlConfig materialTooltipConfig() => new MdlWidgetConfig<MaterialTooltip>(
    "mdl-tooltip", (final html.HtmlElement element) => new MaterialTooltip.fromElement(element));

/// registration-Helper
void registerMaterialTooltip() => componenthandler.register(materialTooltipConfig());

class MaterialTooltip extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialTooltip');

    static const _MaterialTooltipConstant _constant = const _MaterialTooltipConstant();
    static const _MaterialTooltipCssClasses _cssClasses = const _MaterialTooltipCssClasses();

    html.HtmlElement _forEl = null;

    MaterialTooltip.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialTooltip widget(final html.HtmlElement element) => mdlComponent(element) as MaterialTooltip;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialTooltip - init");

        if (element != null) {

            final String forElId = element.getAttribute('for');

            if(forElId != null ) {
                _forEl = html.querySelector("#${forElId}");

                if(_forEl != null) {
                    _forEl.onMouseEnter.listen( _handleMouseEnter );

                    _forEl.onMouseLeave.listen( _handleMouseLeave);
                }
            }
        }
    }

    /// Handle mouseenter for tooltip.
    void _handleMouseEnter(final html.MouseEvent event) {
        event.stopPropagation();

        final Math.Rectangle props = _forEl.getBoundingClientRect();
        element.style.left = "${props.left + (props.width / 2)}px";
        element.style.marginLeft = "${-1 * (element.offsetWidth / 2)}px";
        element.style.top = "${props.top + props.height + 10}px";
        element.classes.add(_cssClasses.IS_ACTIVE);
    }

    /// Handle mouseleave for tooltip.
    /// @param {Event} event The event that fired.
    /// MaterialTooltip.prototype.handleMouseLeave_ = function(event) {
    void _handleMouseLeave(final html.MouseEvent event) {

        event.stopPropagation();
        element.classes.remove(_cssClasses.IS_ACTIVE);
    }
}

