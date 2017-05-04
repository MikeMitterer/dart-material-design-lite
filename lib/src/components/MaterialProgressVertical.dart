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

/// Controller-View for
///     <div id="p1" class="mdl-progress mdl-progress"></div>
///
class MaterialProgressVertical extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialProgressVertical');

    static const _MaterialProgressVerticalConstant _constant = const _MaterialProgressVerticalConstant();
    static const _MaterialProgressVerticalCssClasses _cssClasses = const _MaterialProgressVerticalCssClasses();

    dom.DivElement _progressbar;
    dom.DivElement _bufferbar;
    dom.DivElement _auxbar;
    dom.DivElement _indicatorbar;

    MaterialProgressVertical.fromElement(final dom.HtmlElement element, final di.Injector injector)
        : super(element, injector) {
        _init();
    }

    static MaterialProgressVertical widget(final dom.HtmlElement element) =>
        mdlComponent(element, MaterialProgressVertical) as MaterialProgressVertical;

    /// Set the current progress of the progressbar.
    /// [heightInPercent] Percentage of the progress (0-100)
    void set progress(int heightInPercent) {
        heightInPercent = Math.max(0, Math.min(100, heightInPercent));

        if (element.classes.contains(_cssClasses.INDETERMINATE_CLASS)) {
            return;
        }
        _setProgressStyle(heightInPercent);
        _progressbar.style.height = "${heightInPercent}%";
    }

    int get progress {
        if (element.classes.contains(_cssClasses.INDETERMINATE_CLASS)) {
            return 0;
        }
        return int.parse(_progressbar.style.height.replaceFirst("%", ""));
    }

    /// Set the current progress of the buffer in percent.
    /// [heightPercent] Percentage of the buffer (0-100)
    void set buffer(int heightPercent) {
        heightPercent = Math.max(0, Math.min(100, heightPercent));

        _bufferbar.style.height = "${heightPercent}%";
        _auxbar.style.height = "${100 - heightPercent}%";
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialProgressVertical - init");

        if (element != null) {
            _progressbar = new dom.DivElement();
            _progressbar.classes.addAll([ 'progressbar', 'bar', 'bar1']);
            element.append(_progressbar);

            _bufferbar = new dom.DivElement();
            _bufferbar.classes.addAll([ 'bufferbar', 'bar', 'bar2']);
            element.append(_bufferbar);

            _auxbar = new dom.DivElement();
            _auxbar.classes.addAll([ 'auxbar', 'bar', 'bar3']);
            element.append(_auxbar);

            _indicatorbar = new dom.DivElement();
            _indicatorbar.classes.addAll([ 'indicatorbar', 'bar', 'bar4']);
            element.append(_indicatorbar);

            if (element.dataset.containsKey(_MaterialProgressDataSet.SECTIONS)) {
                final int sections = int.parse(
                    element.dataset[_MaterialProgressDataSet.SECTIONS], onError: (_) => 0);

                for (int hrIndex = 0; hrIndex < sections; hrIndex++) {
                    final dom.SpanElement hr = new dom.SpanElement();
                    hr.classes.add(_cssClasses.SECTION);
                    _indicatorbar.append(hr);
                }
            }

            _progressbar.style.height = '0%';
            _bufferbar.style.height = '100%';
            _auxbar.style.height = '0%';

            _setProgressStyle(0);
            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }

    /// Sets the current progress-value as style
    void _setProgressStyle(final int heightInPercent) {
        element.classes.removeWhere((final String name) => name.startsWith(_cssClasses.PROGRESS));
        element.classes.add("${_cssClasses.PROGRESS}${heightInPercent}");
    }

}

/// creates MdlConfig for MaterialProgressVertical
MdlConfig materialProgressVerticalConfig() =>
    new MdlWidgetConfig<MaterialProgressVertical>(
        _MaterialProgressVerticalCssClasses.MAIN_CLASS, (final dom.HtmlElement element,
        final di.Injector injector) => new MaterialProgressVertical.fromElement(element, injector));

/// registration-Helper
void registerMaterialProgressVertical() => componentHandler().register(materialProgressVerticalConfig());

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialProgressVerticalCssClasses {

    static const String MAIN_CLASS = "mdl-vprogress";

    final String INDETERMINATE_CLASS = 'mdl-vprogress__indeterminate';
    final String SECTION = 'mdl-vprogress__section';

    final String PROGRESS = 'mdl-vprogress--progress-';

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialProgressVerticalCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialProgressVerticalConstant {
    const _MaterialProgressVerticalConstant();
}

class _MaterialProgressDataSet {
    static const String SECTIONS = "sections";
}
