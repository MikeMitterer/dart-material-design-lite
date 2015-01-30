part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialColumnLayoutCssClasses {
    final String INVISIBLE_WRAPPING_ELEMENT = 'wsk-column-layout__wrap-hack';

    const _MaterialColumnLayoutCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialColumnLayoutConstant {
    final int INVISIBLE_WRAPPING_ELEMENT_COUNT = 3;

    const _MaterialColumnLayoutConstant();
}

/// registration-Helper
void registerMaterialColumnLayout() => _componenthandler.register(new WskConfig<MaterialColumnLayout>(
    "wsk-column-layout", (final html.HtmlElement element) => new MaterialColumnLayout(element)));

class MaterialColumnLayout extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialColumnLayout');

    static const _MaterialColumnLayoutConstant _constant = const _MaterialColumnLayoutConstant();
    static const _MaterialColumnLayoutCssClasses _cssClasses = const _MaterialColumnLayoutCssClasses();

    MaterialColumnLayout(final html.HtmlElement element) : super(element) {
        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialColumnLayout - init");

        if (element != null) {
            // Add some hidden elements to make sure everything aligns correctly. See
            // CSS file for details.

            for (int j = 0; j < _constant.INVISIBLE_WRAPPING_ELEMENT_COUNT ; j++) {

                final html.DivElement hiddenHackDiv = new html.DivElement();
                hiddenHackDiv.classes.add(_cssClasses.INVISIBLE_WRAPPING_ELEMENT);
                element.append(hiddenHackDiv);
            }
        }

    }
}

