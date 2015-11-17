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

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialProgressCssClasses {

    static const String MAIN_CLASS  = "mdl-js-progress";

    final String INDETERMINATE_CLASS = 'mdl-progress__indeterminate';
    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialProgressCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialProgressConstant {
    const _MaterialProgressConstant();
}

/// creates MdlConfig for MaterialProgress
MdlConfig materialProgressConfig() => new MdlWidgetConfig<MaterialProgress>(
    _MaterialProgressCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialProgress.fromElement(element,injector));

/// registration-Helper
void registerMaterialProgress() => componentHandler().register(materialProgressConfig());

class MaterialProgress extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialProgress');

    static const _MaterialProgressConstant _constant = const _MaterialProgressConstant();
    static const _MaterialProgressCssClasses _cssClasses = const _MaterialProgressCssClasses();

    dom.DivElement _progressbar;
    dom.DivElement _bufferbar;
    dom.DivElement _auxbar;

    MaterialProgress.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialProgress widget(final dom.HtmlElement element) => mdlComponent(element,MaterialProgress) as MaterialProgress;

    /// Set the current progress of the progressbar.
    /// [widthInPercent] Percentage of the progress (0-100)
    void set progress(int widthInPercent) {
        widthInPercent = Math.max(0,Math.min(100,widthInPercent));

        if (element.classes.contains(_cssClasses.INDETERMINATE_CLASS)) {
            return;
        }

        _progressbar.style.width = "${widthInPercent}%";
    }

    int get progress {
        if (element.classes.contains(_cssClasses.INDETERMINATE_CLASS)) {
            return 0;
        }
        return int.parse(_progressbar.style.width.replaceFirst("%",""));
    }

    /// Set the current progress of the buffer in percent.
    /// [widthPercent] Percentage of the buffer (0-100)
    void set buffer(int widthPercent) {
        widthPercent = Math.max(0,Math.min(100,widthPercent));

        _bufferbar.style.width = "${widthPercent}%";
        _auxbar.style.width = "${100 - widthPercent}%";
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialProgress - init");

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

            _progressbar.style.width = '0%';
            _bufferbar.style.width = '100%';
            _auxbar.style.width = '0%';

            element.classes.add(_cssClasses.IS_UPGRADED);
        }
    }
}

