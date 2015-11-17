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

part of mdldemo;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _DemoAnimationCssClasses {

    static const String MAIN_CLASS  = "demo-js-animation";

    final String MOVABLE = 'demo-animation__movable';
    final String POSITION_PREFIX = 'demo-animation--position-';

    static const String FAST_OUT_SLOW_IN = 'mdl-animation--fast-out-slow-in';
    static const String LINEAR_OUT_SLOW_IN = 'mdl-animation--linear-out-slow-in';
    static const String FAST_OUT_LINEAR_IN = 'mdl-animation--fast-out-linear-in';

    const _DemoAnimationCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _DemoAnimationConstant {

    final int STARTING_POSITION = 0;
    final int END_POSITION = 5;

    final List<String> ANIMATIONS = const [
        _DemoAnimationCssClasses.FAST_OUT_LINEAR_IN,
        _DemoAnimationCssClasses.LINEAR_OUT_SLOW_IN,
        _DemoAnimationCssClasses.FAST_OUT_SLOW_IN,
        _DemoAnimationCssClasses.FAST_OUT_LINEAR_IN,
        _DemoAnimationCssClasses.LINEAR_OUT_SLOW_IN,
        _DemoAnimationCssClasses.FAST_OUT_SLOW_IN
    ];

    const _DemoAnimationConstant(); }

/// creates MdlConfig for DemoAnimation
MdlConfig demoAnimationConfig() => new MdlWidgetConfig<DemoAnimation>(
    _DemoAnimationCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
        => new DemoAnimation.fromElement(element,injector));

/// registration-Helper
void registerDemoAnimation() => componentHandler().register(demoAnimationConfig());

/**
 * Sample:
 *   <div class="demo-preview-block demo-animation demo-js-animation">
 *       <div class="demo-animation__container">
 *           <div class="demo-animation__container-background">Click me to animate</div>
 *           <div class="demo-animation__container-foreground"></div>
 *           <div class="demo-animation__movable demo-animation--position-1 mdl-shadow--z1"></div>
 *       </div>
 *   </div>
*/
class DemoAnimation extends MdlComponent {
    final Logger _logger = new Logger('mdl.DemoAnimation');

    static const _DemoAnimationConstant _constant = const _DemoAnimationConstant();
    static const _DemoAnimationCssClasses _cssClasses = const _DemoAnimationCssClasses();

    int _position = _constant.STARTING_POSITION;
    dom.HtmlElement _movable = null;

    DemoAnimation.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static DemoAnimation widget(final dom.HtmlElement element) => mdlComponent(element,DemoAnimation) as DemoAnimation;

    dom.HtmlElement get movable {
        if(_movable == null) {
            _movable = dom.querySelector(".${_cssClasses.MOVABLE}");

            if(_movable == null) {
                _logger.severe('Was expecting to find an element with class name ' +
                '${_cssClasses.MOVABLE} in side of: ${element}');
            }
        }
        return _movable;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("DemoAnimation - init");
        element.onClick.listen(_handleClick);
    }

    void _handleClick(final dom.MouseEvent event) {
        movable.classes.remove("${_cssClasses.POSITION_PREFIX}${_position}");
        movable.classes.remove(_constant.ANIMATIONS[_position]);

        _position++;
        if (_position > _constant.END_POSITION) {
            _position = _constant.STARTING_POSITION;
        }
        movable.classes.add(_constant.ANIMATIONS[_position]);
        movable.classes.add("${_cssClasses.POSITION_PREFIX}${_position}");
    }
}

