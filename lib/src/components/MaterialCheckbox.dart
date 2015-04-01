part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialCheckboxCssClasses {
    final String INPUT = 'wsk-checkbox__input';

    final String BOX_OUTLINE = 'wsk-checkbox__box-outline';

    final String FOCUS_HELPER = 'wsk-checkbox__focus-helper';

    final String TICK_OUTLINE = 'wsk-checkbox__tick-outline';

    final String RIPPLE_EFFECT = 'wsk-js-ripple-effect';

    final String RIPPLE_IGNORE_EVENTS = 'wsk-js-ripple-effect--ignore-events';

    final String RIPPLE_CONTAINER = 'wsk-checkbox__ripple-container';

    final String RIPPLE_CENTER = 'wsk-ripple--center';

    final String RIPPLE = 'wsk-ripple';

    final String IS_FOCUSED = 'is-focused';

    final String IS_DISABLED = 'is-disabled';

    final String IS_CHECKED = 'is-checked';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialCheckboxCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialCheckboxConstant {
    
    final int TINY_TIMEOUT_IN_MS = 100;

    const _MaterialCheckboxConstant();
}

/// creates WskConfig for MaterialCheckbox
WskConfig materialCheckboxConfig() => new WskConfig<MaterialCheckbox>(
    "wsk-js-checkbox", (final html.HtmlElement element) => new MaterialCheckbox(element));

/// registration-Helper
void registerMaterialCheckbox() => componenthandler.register(materialCheckboxConfig());

// ToDo: OrigJS-Version defines public functions like disable, enable, check, uncheck
class MaterialCheckbox extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialCheckbox');

    static const _MaterialCheckboxConstant _constant = const _MaterialCheckboxConstant();
    static const _MaterialCheckboxCssClasses _cssClasses = const _MaterialCheckboxCssClasses();

    html.CheckboxInputElement _btnElement = null;

    MaterialCheckbox(final html.HtmlElement element) : super(element) {
        _init();
    }

    html.CheckboxInputElement get btnElement {
        if(_btnElement == null) {
            _btnElement = element.querySelector(".${_cssClasses.INPUT}");
        }
        return _btnElement;
    }
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialCheckbox - init");

        final html.SpanElement boxOutline = new html.SpanElement();
        boxOutline.classes.add(_cssClasses.BOX_OUTLINE);

        final html.SpanElement tickContainer = new html.SpanElement();
        tickContainer.classes.add(_cssClasses.FOCUS_HELPER);

        final html.SpanElement tickOutline = new html.SpanElement();
        tickOutline.classes.add(_cssClasses.TICK_OUTLINE);

        boxOutline.append(tickOutline);

        element.append(tickContainer);
        element.append(boxOutline);

        html.SpanElement rippleContainer;
        if (element.classes.contains(_cssClasses.RIPPLE_EFFECT)) {
            element.classes.add(_cssClasses.RIPPLE_IGNORE_EVENTS);

            rippleContainer = new html.SpanElement();
            rippleContainer.classes.add(_cssClasses.RIPPLE_CONTAINER);
            rippleContainer.classes.add(_cssClasses.RIPPLE_EFFECT);
            rippleContainer.classes.add(_cssClasses.RIPPLE_CENTER);

            rippleContainer.onMouseUp.listen(_onMouseUp);

            final html.SpanElement ripple = new html.SpanElement();
            ripple.classes.add(_cssClasses.RIPPLE);

            rippleContainer.append(ripple);
            element.append(rippleContainer);
        }

        btnElement.onChange.listen(_onChange);

        btnElement.onFocus.listen(_onFocus);

        btnElement.onBlur.listen(_onBlur);

        element.onMouseUp.listen(_onMouseUp);

        _updateClasses(btnElement, element);
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// Handle change of state.
    void _onChange(final html.Event event) {
        _updateClasses(btnElement, element);
    }

    /// Handle focus of element.
    void _onFocus(final html.Event event) {
        element.classes.add(_cssClasses.IS_FOCUSED);
    }

    /// Handle lost focus of element.
    void _onBlur(final html.Event  event) {
        element.classes.remove(_cssClasses.IS_FOCUSED);
    }

    /// Handle mouseup.
    void _onMouseUp(final html.Event event) {
        _blur();
    }

    /**
     * Handle class updates.
     * The [button] whose classes we should update.
     * The [label] whose classes we should update.
     */
    void _updateClasses(final html.CheckboxInputElement button, final html.HtmlElement label) {
        if (button.disabled) {
            label.classes.add(_cssClasses.IS_DISABLED);
        }
        else {
            label.classes.remove(_cssClasses.IS_DISABLED);
        }

        if (button.checked) {
            label.classes.add(_cssClasses.IS_CHECKED);
        }
        else {
            label.classes.remove(_cssClasses.IS_CHECKED);
        }
    }

    void _blur() {
        // TODO: figure out why there's a focus event being fired after our blur,
        // so that we can avoid this hack.
        new Timer(new Duration(milliseconds : _constant.TINY_TIMEOUT_IN_MS ), () {
            btnElement.blur();
        });
    }
}

