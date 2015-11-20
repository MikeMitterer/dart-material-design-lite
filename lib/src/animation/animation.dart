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

/**
 * CSS3-Keyframe-Animations for MDL/Dart
 */
part of mdlanimation;

/// Callback function type
typedef void MdlAnimationComplete();

/// Timing constants
class AnimationTiming {
    final String function;

    const AnimationTiming(this.function);

    static const AnimationTiming LINEAR = const AnimationTiming("linear");
    static const AnimationTiming EASE = const AnimationTiming("ease");
    static const AnimationTiming EASE_IN = const AnimationTiming("ease-in");
    static const AnimationTiming EASE_OUT = const AnimationTiming("ease-out");
    static const AnimationTiming EASE_IN_OUT = const AnimationTiming("ease-in-out");
}


/**
 * MdlAnimation simplifies the use of CSS3 animations.
 *
 * This builds and injects a rule into the stylesheets that
 * defines the keyframes of the animation. This rule can then
 * be applied to an element.
 *
 * ATTENTION: Be aware that the rules are not
 * deleted when an instance is destroyed, therefore generating
 * instances continuously is probably a bad idea.
 *
 * Usage:
 *      // Good place for this is outside of main
 *      final MdlAnimation bounceInRight = new MdlAnimation.fromStock(StockAnimation.BounceInRight);
 *
 *      class Application {
 *          ...
 *          _bindSignals() {
 *              ...
 *             final MaterialButton properties = MaterialButton.widget(dom.querySelector("#showprops"));
 *             properties.onClick.listen( (final dom.Event event) async {
 *                event.preventDefault();
 *
 *                final dom.Element body = dom.querySelector("body");
 *                body.classes.toggle("show-properties");
 *
 *                if(body.classes.contains("show-properties")) {
 *                   bounceInRight(dom.querySelector(".properties"), onComplete: () => _logger.info("Animation completed!"));
 *                }
 *              });
 *            }
 *         }
 */
class MdlAnimation {
    final Logger _logger = new Logger('mdlanimation.MdlAnimation');

    /// Basis for animation [_animationID]
    static int _reference = 0;

    static dom.StyleElement _style = new dom.StyleElement();
    final dom.Text _rule = new dom.Text('');
    final Map<int, Map<String, Object>> _keyframes = new Map<int, Map<String, Object>>();

    /// Unique ID for the generated animation
    final int _animationID = _reference++;

    /// Will be something like css-animation-0
    String _animationName;

    /// Predefined-[StockAnimation] set in [fromStock]
    StockAnimation _stockanimation;

    /**
     * Simple constructor defining the animation of a single CSS property.
     *
     * This will automatically generate the start and end keyframes
     * required to animate the CSS [property] [from] one value [to]
     * the next. e.g.,
     *
     * Usage:
     *    final MdlAnimation anim = new MdlAnimation('opacity', 0, 1);
     *    anim.apply(element,duration: new Duration(milliseconds: 5000));
     */
    MdlAnimation(final String property, final Object from, final Object to) {
        Validate.notBlank(property);
        Validate.notNull(from);
        Validate.notNull(to);

        final Map<int, Map<String, Object>> keyframes = new Map<int, Map<String, Object>>();

        keyframes[0] = new Map<String, Object>()
            ..[property] = from;

        keyframes[100] = new Map<String, Object>()
            ..[property] = to;

        _buildRule(keyframes);
    }

    /**
     * Returns an instance that defines the animation of
     * some predefined [StockAnimation]s
     *
     * Usage:
     *      final MdlAnimation bounceInRight = new MdlAnimation.fromStock(StockAnimation.BounceInRight);
     *      ...
     *      bounceInRight(dom.querySelector(".properties")).then((_) => _logger.info("Animation completed!"));
     */
    MdlAnimation.fromStock(this._stockanimation) {
        Validate.notNull(_stockanimation);
        Validate.isTrue(_stockanimation.keyframes.isNotEmpty);

        _buildRule(_stockanimation.keyframes);
    }

    /**
     * Returns an instance that defines the animation of multiple CSS properties.
     *
     * Start and end keyframes will be generated using the [from] and [to]
     * maps of CSS properties. e.g.,
     *
     *     var anim = new MdlAnimation.properties(
     *         { 'visibility' : 'hidden', 'opacity' : 0 },
     *         { 'visibility' : 'visible', 'opacity' : 1 }
     *     );
     */
    MdlAnimation.properties(final Map<String, Object> from, final Map<String, Object> to,
        { dom.ShadowRoot shadow: null }) {
        Validate.notNull(from);
        Validate.notNull(to);

        final Map<int, Map<String, Object>> keyframes = new Map<int, Map<String, Object>>();

        keyframes[0] = from;
        keyframes[100] = to;

        _buildRule(keyframes);
    }


    /**
     * Returns an instance that defines each keyframe of the animation.
     *
     * The [keyframes] map has an integer key that must lie between 0 and 100
     * representing the percentage progress through the animation. At each of
     * these keyframes it defines a set of CSS properties and their
     * corresponding values. e.g.,
     *
     * Usage:
     *     final MdlAnimation animation = new MdlAnimation.keyframes(<int, Map<String, Object>>{
     *         0 : const <String, Object>{
     *          "opacity" : 0,
     *          "transform" : "translateX(2000px)"},
     *         60 : const <String, Object>{
     *          "opacity" : 1,
     *           "transform" : "translateX(-30px)"},
     *         80 : const <String, Object>{
     *          "transform" : "translateX(10px)"},
     *         100 : const <String, Object>{
     *           "transform" : "translateX(0)"}
     *         });
     *
     * The above example will create an animation that bounces in from the right side.
    */
    MdlAnimation.keyframes(final Map<int, Map<String, Object>> keyframes, { final dom.ShadowRoot shadow: null }) {
        Validate.notEmpty(keyframes);
        Validate.isTrue(keyframes.containsKey(0) && keyframes.containsKey(100),
            "Animation should have a start (0) and finish (100)");

        if (keyframes.keys.every((k) => k >= 0 && k <= 100)) {
            _buildRule(keyframes);
        }
        else throw new ArgumentError('Animation keyframes must lie in the range 0 to 100');
    }

    /**
     *  Apply this animation to an element.
     *
     *  This animation instance has built and injected a CSS rule into the
     *  stylesheets, therefore it can be applied to as many elements as required.
     *  A number of optional parameters are available which simply pass the
     *  appropriate values through to their CSS counter-parts.
     *  The [duration] of the animation is specified in milliseconds, and the
     *  start of the animation can be [delay]ed by a given number of milliseconds.
     *  If the number of [iterations] is set to zero or a negative value then
     *  the animation will run indefinitely (callback is automatically ignored).
     *  The [alternate] flag will determine whether the animation starts back
     *  at the beginning for each iteration, or if enabled will cause the animation
     *  to bounce back and forth between the start and end keyframes.
     *
     *  Setting the [persist] flag will ensure that when the animation has completed
     *  the styles defined at that point will be applied to the element (since
     *  otherwise these would be lost when the animation property is reset).
     *
     *  The animation [timing] function can be specified from a set of possibilities
     *  defined as constants above. For more information please refer to the relevant
     *  CSS documentation.
     *
     *  A callback function, [onComplete], if supplied will be invoked when the
     *  animation for this element has completed. However, this parameter will
     *  be ignored if an infinite number of iterations has been specified.
     *
     *  If using this instance from a web component (such as a polymer element)
     *  please set the [shadow] argument to the shadow root of the component
     *  so that the animation style can be inserted at the correct place.
     *  MdlAnimation instances can not be shared across components.
     *
     *  Note: If you have set a callback and you apply any animation to
     *  this element again before this one has completed then the callback
     *  may not fire and the internal listener may not be removed.
     *
     *  Usage:
     *      final MdlAnimation fadeIn = new MdlAnimation("opacity",0,1);
     *      ...
     *      fadeIn.apply(dom.querySelector(".properties"),
     *          duration: new Duration(milliseconds: 15000)).then((_) => _logger.info("Animation completed!"));
     */
    Future apply(final dom.Element element, {
        final Duration duration: const Duration(seconds: 1),
        final Duration delay: const Duration(),
        final int iterations: 1,
        final bool alternate: false,
        final bool persist: true,
        final AnimationTiming timing: AnimationTiming.EASE,
        final dom.ShadowRoot shadow: null }) {

        final Completer completer = new Completer();
        new Future(() {

            // Check if style is already in the DOM, either in header or in Shadow-DOM
            if (_style.parent == null) {
                if (shadow != null) shadow.children.add(_style);
                else dom.document.head.children.add(_style);
            }

            // Animation is already running!
            if (element.style.animationName == _animationName) {
                _logger.shout("Animation ${_animationName} is alredy running...");
                return;
            }

            final Duration _duration = _stockanimation != null ? _stockanimation.duration : duration;
            final AnimationTiming _timing = _stockanimation != null ? _stockanimation.timing : timing;

            element.style
                ..animationName = _animationName
                ..animationDuration = '${_duration.inMilliseconds}ms'
                ..animationTimingFunction = _timing.function
                ..animationIterationCount = iterations > 0 ? iterations.toString() : 'infinite'
                ..animationDirection = alternate ? 'alternate' : 'normal'
                ..animationFillMode = 'forwards'
                ..animationDelay = '${delay.inMilliseconds}ms';

            if (iterations > 0) {

                StreamSubscription<dom.EventListener> subscription;
                void _onAnimationEnd(_) {
                    if (persist) {
                        final Map<String, Object> map = (alternate && (iterations % 2) == 0)
                            ? _keyframes[0]
                            : _keyframes[100];

                        map.forEach((final String k, final Object v) => element.style.setProperty(k, v.toString()));
                    }

                    element.style.animation = 'none';
                    subscription.cancel();

                    completer.complete();
                };
                subscription = element.on["animationend"].listen(_onAnimationEnd);
            }
        });

        return completer.future;
    }

    /**
     * Make the function-call even shorter! Mainly this is a shortcut to [apply]
     *
     * Usage:
     *      final MdlAnimation bounceInRight = new MdlAnimation.fromStock(StockAnimation.BounceInRight);
     *      ...
     *      .onClick.listen((_) {
     *          event.preventDefault();
     *          bounceInRight(dom.querySelector(".properties")).then((_) => _logger.info("Animation completed!"));
     *      }
     */
    Future call(final dom.Element element) => apply(element);

    /**
     * Modifies a single property for a specific keyframe.
     * 
     * For a particular [keyframe] the given [property] will
     * be updated to [value]. If the property does not exist
     * then it will be created.
     * The keyframe must exist. If this instance was created
     * using either of the simpler constructors then the "from"
     * and "to" keyframes will be 0 and 100 respectively.
     * This will not affect any elements that are currently
     * animating with this rule until they have finished.
     * 
     * Returns false if the keyframe is invalid.
     */
    bool modify(final int keyframe, final String property, final Object value) {
        Validate.isTrue(keyframe >= 0 && keyframe <= 100, 'Animation keyframes must lie in the range 0 to 100');
        Validate.notBlank(property);
        Validate.notNull(value);

        if (this._keyframes.containsKey(keyframe)) {
            this._keyframes[keyframe][property] = value;
            this._buildRule(_keyframes);

            return true;
        }

        return false;
    }


    /**
     * Replaces a set of properties for a specific keyframe.
     * 
     * For a particular [keyframe] the property map will be
     * replaced with [properties].
     * The keyframe must exist. If this instance was created
     * using either of the simpler constructors then the "from"
     * and "to" keyframes will be 0 and 100 respectively.
     * This will not affect any elements that are currently
     * animating with this rule until they have finished.
     * 
     * Returns false if the keyframe is invalid.
     */
    bool replace(final int keyframe, final Map<String, Object> properties) {
        Validate.isTrue(keyframe >= 0 && keyframe <= 100, 'Animation keyframes must lie in the range 0 to 100');
        Validate.notEmpty(properties);

        if (_keyframes.containsKey(keyframe)) {
            _keyframes[keyframe] = properties;
            _buildRule(_keyframes);

            return true;
        }

        return false;
    }


    /**
     * Removes the rule from the stylesheets.
     * 
     * To tidy up this removes the rule from the stylesheets, thereby rendering
     * any future calls to apply() ineffective. Any elements that are currently
     * animating with this rule will continue to do so.
     */
    void destroy() {
        _rule.remove();
    }


    //- private -----------------------------------------------------------------------------------

    /// Builds the rule that is injected into the stylesheets
    void _buildRule(final Map<int, Map<String, Object>> keyframes) {
        if (_animationName == null) {
            _animationName = 'css-animation-${_animationID}';
            _style.nodes.add(_rule);
        }

        _keyframes.clear();
        _keyframes.addAll(keyframes);

        final StringBuffer rule = new StringBuffer('@${Device.cssPrefix}keyframes $_animationName {');

        keyframes.forEach((final int percent, final Map<String, Object> properties) {
            rule.write(' $percent%{');
            properties.forEach((final String name, final Object value) => rule.write('$name:${value.toString()};'));
            rule.write('}');
        });

        rule.write('}');

        _rule.text = rule.toString();
    }
}
