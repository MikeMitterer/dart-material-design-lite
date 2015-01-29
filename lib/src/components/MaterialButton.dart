part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialButtonCssClasses {
    final String WSK_JS_RIPPLE_EFFECT =          'wsk-js-ripple-effect';
    final String WSK_BUTTON_RIPPLE_CONTAINER =   'wsk-button__ripple-container';
    final String WSK_RIPPLE =                    'wsk-ripple';
    const _MaterialButtonCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialButtonConstant { const _MaterialButtonConstant(); }

@WskCssClass("wsk-js-button")
class MaterialButton extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialButton');

    static const _MaterialButtonConstant _constant = const _MaterialButtonConstant();
    static const _MaterialButtonCssClasses _cssClasses = const _MaterialButtonCssClasses();

    MaterialButton(final html.HtmlElement element) : super(element) {
        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialButton - init");

        if(element.classes.contains(_cssClasses.WSK_JS_RIPPLE_EFFECT)) {
            final html.SpanElement rippleContainer = new html.Element.span();
            rippleContainer.classes.add(_cssClasses.WSK_BUTTON_RIPPLE_CONTAINER);

            final html.SpanElement ripple = new html.Element.span();
            ripple.classes.add(_cssClasses.WSK_RIPPLE);
            rippleContainer.append(ripple);

            ripple.onMouseUp.listen(_blurHandleGenerator);
            element.append(rippleContainer);
        }
        element.onMouseUp.listen(_blurHandleGenerator);
    }

    void _blurHandleGenerator(final html.MouseEvent event) {
        element.blur();
    }
}

