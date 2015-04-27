/**
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

    final String MOVABLE   = 'demo-animation__movable';
    final String POSITION_PREFIX   = 'demo-animation--position-';

    const _DemoAnimationCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _DemoAnimationConstant {

    final int STARTING_POSITION = 1;

    const _DemoAnimationConstant(); }

/// creates MdlConfig for DemoAnimation
MdlConfig demoAnimationConfig() => new MdlWidgetConfig<DemoAnimation>(
    "demo-js-animation", (final dom.HtmlElement element) => new DemoAnimation.fromElement(element));

/// registration-Helper
void registerDemoAnimation() => componenthandler.register(demoAnimationConfig());

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

    DemoAnimation.fromElement(final dom.HtmlElement element) : super(element) {
        _init();
    }

    static DemoAnimation widget(final dom.HtmlElement element) => mdlComponent(element) as DemoAnimation;

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
        _position++;

        if (_position > 6) {
            _position = 1;
        }
        movable.classes.add("${_cssClasses.POSITION_PREFIX}${_position}");
    }
}

