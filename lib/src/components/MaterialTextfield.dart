part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialTextfieldCssClasses {

    final String WSK_TEXT_EXP_ICO_RIP_CONTAINER = 'wsk-textfield-expandable-icon__ripple__container';

    final String WSK_JS_RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String WSK_RIPPLE_CENTER = 'wsk-ripple--center';

    final String WSK_RIPPLE = 'wsk-ripple';

    final String IS_DIRTY = 'is-dirty';

    const _MaterialTextfieldCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialTextfieldConstant {

    final int NO_MAX_ROWS = -1;
    final String MAX_ROWS_ATTRIBUTE = 'maxrows';

    const _MaterialTextfieldConstant();
}

/// creates WskConfig for MaterialButton
WskConfig materialTextfieldConfig() => new WskWidgetConfig<MaterialTextfield>(
    "wsk-js-textfield", (final html.HtmlElement element) => new MaterialTextfield.fromElement(element));

/// registration-Helper
void registerMaterialTextfield() => componenthandler.register(materialTextfieldConfig());

class MaterialTextfield extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialTextfield');

    static const _MaterialTextfieldConstant _constant = const _MaterialTextfieldConstant();
    static const _MaterialTextfieldCssClasses _cssClasses = const _MaterialTextfieldCssClasses();

    int _maxRows = _constant.NO_MAX_ROWS;

    MaterialTextfield.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialTextfield widget(final html.HtmlElement element) => wskComponent(element) as MaterialTextfield;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialTextfield - init");

        if (element != null) {

            final List<html.Element> expandableIcons = html.querySelectorAll('.wsk-textfield-expandable-icon');

            for (int i = 0; i < expandableIcons.length; ++i) {
                _expandableIcon(expandableIcons[i]);
            }

            if (element.attributes.containsKey(_constant.MAX_ROWS_ATTRIBUTE) &&
                element.attributes[_constant.MAX_ROWS_ATTRIBUTE] != null &&
                element.attributes[_constant.MAX_ROWS_ATTRIBUTE].isNotEmpty ) {

                _maxRows = int.parse(element.getAttribute(_constant.MAX_ROWS_ATTRIBUTE),
                    onError: (final String value) {
                        _logger.severe('maxrows attribute provided, but wasn\'t a number: $value');
                        _maxRows = _constant.NO_MAX_ROWS;
                    });
            }

            element.onInput.listen( _onInputChange );

            if (_maxRows != _constant.NO_MAX_ROWS) {

                // TODO: This should handle pasting multi line text.
                // Currently doesn't.
                element.onKeyDown.listen( _onKeyDown );
            }
        }
    }

    /// Handle upgrade of icon element.
    /// iconElement HTML element to contain icon.
    void _expandableIcon(final html.HtmlElement iconElement) {

        if (! iconElement.attributes.containsKey('data-upgraded')) {

            final html.SpanElement container = new html.SpanElement();
            container.classes.add(_cssClasses.WSK_TEXT_EXP_ICO_RIP_CONTAINER);
            container.classes.add(_cssClasses.WSK_JS_RIPPLE_EFFECT);
            container.classes.add(_cssClasses.WSK_RIPPLE_CENTER);

            final html.SpanElement ripple = new html.SpanElement();
            ripple.classes.add(_cssClasses.WSK_RIPPLE);
            container.append(ripple);

            iconElement.append(container);
            iconElement.setAttribute('data-upgraded', '');


        }
    }

    /// Handle input being entered.
    void _onInputChange(final html.MouseEvent event) {
        final input = element;

        if (input.value != null && (input.value as String).isNotEmpty) {
            input.classes.add(_cssClasses.IS_DIRTY);

        } else if(element is html.TextAreaElement && (element as html.TextAreaElement).value != null &&
            (element as html.TextAreaElement).value.isNotEmpty ) {

            input.classes.add(_cssClasses.IS_DIRTY);

        } else {
            input.classes.remove(_cssClasses.IS_DIRTY);
            // _logger.warning("Element $element width class ${element.classes} is not a Texfield...");
        }
    }

    /// Handle input being entered.
    void _onKeyDown(final html.KeyboardEvent event) {
        final input = element;

        final currentRowCount = input.value.split('\n').length;
        if (event.keyCode == 13) {
            if (currentRowCount >= _maxRows) {
                event.preventDefault();
            }
        }
    }
}

