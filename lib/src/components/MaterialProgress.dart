part of wskcomponents;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialProgressCssClasses {

    final String INDETERMINATE_CLASS = 'wsk-progress__indeterminate';
    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialProgressCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialProgressConstant {
    const _MaterialProgressConstant();
}

/// registration-Helper
void registerMaterialProgress() => componenthandler.register(new WskConfig<MaterialProgress>(
    "wsk-js-progress", (final html.HtmlElement element) => new MaterialProgress.fromElement(element)));

class MaterialProgress extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialProgress');

    static const _MaterialProgressConstant _constant = const _MaterialProgressConstant();
    static const _MaterialProgressCssClasses _cssClasses = const _MaterialProgressCssClasses();

    html.DivElement _progressbar;
    html.DivElement _bufferbar;
    html.DivElement _auxbar;

    factory MaterialProgress(final html.HtmlElement element) =>  wskComponent(element) as MaterialProgress;

//    factory MaterialProgress() =>  new html.Element.tag('wsk-progress');
//
//    MaterialProgress.created() : super.created() {
//        _logger.info("created");
//        classes.add("wsk-js-progress");
//        element = this;
//        _init();
//    }

    MaterialProgress.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

//    init(final html.HtmlElement element) {
//        this.element = element;
//        _init();
//    }

    static MaterialProgress widget(final html.HtmlElement element) => wskComponent(element) as MaterialProgress;

    /// MaterialProgress.prototype.setProgress = function(p) {
    void set progress(final int width) {

        if (element.classes.contains(_cssClasses.INDETERMINATE_CLASS)) {
            return;
        }

        _progressbar.style.width = "${width}%";
    }

    int get progress {
        if (element.classes.contains(_cssClasses.INDETERMINATE_CLASS)) {
            return 0;
        }
        return int.parse(_progressbar.style.width.replaceFirst("%",""));
    }

    /// MaterialProgress.prototype.setBuffer = function(p) {
    void set buffer(final int width) {
        _bufferbar.style.width = "${width}%";
        _auxbar.style.width = "${100 - width}%";
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialProgress - init");

        if (element != null) {

            _progressbar = new html.DivElement();
            _progressbar.classes.addAll([ 'progressbar', 'bar', 'bar1']);
            element.append(_progressbar);

            _bufferbar = new html.DivElement();
            _bufferbar.classes.addAll([ 'bufferbar', 'bar', 'bar2']);
            element.append(_bufferbar);

            _auxbar = new html.DivElement();
            _auxbar.classes.addAll([ 'auxbar', 'bar', 'bar3']);
            element.append(_auxbar);

            _progressbar.style.width = '0%';
            _bufferbar.style.width = '100%';
            _auxbar.style.width = '0%';

            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

}

