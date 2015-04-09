part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialContentCssClasses {

    final String DYN_CONTENT    = 'wsk-content__adding_content';

    final String LAODING        = 'wsk-content__loading';

    final String LAODED         = 'wsk-content__loaded';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialContentCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialContentConstant {
    const _MaterialContentConstant();
}

/// registration-Helper
void registerMaterialContent() => componenthandler.register(new WskWidgetConfig<MaterialContent>(
    "wsk-js-content", (final html.HtmlElement element) => new MaterialContent.fromElement(element)));

class MaterialContent extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialContent');

    static const _MaterialContentConstant _constant = const _MaterialContentConstant();
    static const _MaterialContentCssClasses _cssClasses = const _MaterialContentCssClasses();

    MaterialContent.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialContent widget(final html.HtmlElement element) => wskComponent(element) as MaterialContent;

    // Central Element - by default this is where wsk-js-content was found (element)
    // html.Element get hub => inputElement;

    Future setContent(final String content) {
        _logger.info("Content: $content");

        final Completer completer = new Completer();

        new Future(() {
            element.classes.remove(_cssClasses.LAODED);
            element.classes.add(_cssClasses.LAODING);

            final html.Element child = new html.Element.html(content);
            element.childNodes.first.remove();

            child.classes.add(_cssClasses.DYN_CONTENT);
            element.append(child);

            /// check if child is in DOM
            new Timer.periodic(new Duration(milliseconds: 10),(final Timer timer) {

                _logger.info("Check for dyn-content...");
                final html.Element dynContent = element.querySelector(".${_cssClasses.DYN_CONTENT}");

                if( dynContent != null) {
                    timer.cancel();
                    dynContent.classes.remove(_cssClasses.DYN_CONTENT);

                    element.classes.remove(_cssClasses.LAODING);
                    element.classes.add(_cssClasses.LAODED);

                    upgradeAllRegistered().then((_) => completer.complete());
                }
            });
        });

        return completer.future;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialContent - init");
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

