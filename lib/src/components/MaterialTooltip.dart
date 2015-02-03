part of wskcomponents;

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

/// creates WskConfig for MaterialButton
WskConfig materialTooltipConfig() => new WskConfig<MaterialTooltip>(
    "wsk-tooltip", (final html.HtmlElement element) => new MaterialTooltip(element));

/// registration-Helper
void registerMaterialTooltip() => componenthandler.register(materialTooltipConfig());

class MaterialTooltip extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialTooltip');

    static const _MaterialTooltipConstant _constant = const _MaterialTooltipConstant();
    static const _MaterialTooltipCssClasses _cssClasses = const _MaterialTooltipCssClasses();

    html.HtmlElement _forEl = null;

    MaterialTooltip(final html.HtmlElement element) : super(element) {
        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialTooltip - init");

        if (element != null) {

            final String forElId = element.getAttribute('for');
            _forEl = html.querySelector("#${forElId}");

            _forEl.onMouseEnter.listen( _handleMouseEnter );

            _forEl.onMouseLeave.listen( _handleMouseLeave);
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

