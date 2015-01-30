part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialItemCssClasses {

    final String WSK_ITEM_RIPPLE_CONTAINER = 'wsk-item--ripple-container';
    final String WSK_RIPPLE = 'wsk-ripple';

    const _MaterialItemCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialItemConstant {
    const _MaterialItemConstant();
}

/// registration-Helper
void registerMaterialItem() => _componenthandler.register(new WskConfig<MaterialItem>(
    "wsk-js-ripple-effect", (final html.HtmlElement element) => new MaterialItem(element)));

class MaterialItem extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialItem');

    static const _MaterialItemConstant _constant = const _MaterialItemConstant();
    static const _MaterialItemCssClasses _cssClasses = const _MaterialItemCssClasses();

    MaterialItem(final html.HtmlElement element) : super(element) {
        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialItem - init");

        if (element != null) {

            final html.SpanElement rippleContainer = new html.SpanElement();
            rippleContainer.classes.add(_cssClasses.WSK_ITEM_RIPPLE_CONTAINER);

            final html.SpanElement ripple = new html.SpanElement();
            ripple.classes.add(_cssClasses.WSK_RIPPLE);
            rippleContainer.append(ripple);

            element.append(rippleContainer);
        }

    }
}

