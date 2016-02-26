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
     
 part of mdlanimation;

/**
 * Predefined animations.
 *
 * If you want to define your own keyframes this site could be helpful:
 * https://coveloping.com/tools/css-animation-generator
 *
 * Usage:
 *      final MdlAnimation bounceInRight = new MdlAnimation.fromStock(StockAnimation.BounceInRight);
 *      ...
 *      bounceInRight(element).then((_) => _logger.info("Animation completed!"));
 */
class StockAnimation {
    /// Specifies the length of the animation
    Duration duration;

    /// The keyframes for the animation
    final Map<int, Map<String, Object>> keyframes;

    AnimationTiming timing;

    /// Specify your set of [keyframes]
    StockAnimation(this.duration, this.keyframes,this.timing);

    static final StockAnimation BounceInTop =
        new StockAnimation(const Duration(milliseconds: 500), _BounceInTop,AnimationTiming.EASE_IN_OUT);

    static final StockAnimation BounceInBottom =
        new StockAnimation(const Duration(milliseconds: 500), _BounceInBottom,AnimationTiming.EASE_IN_OUT);

    static final StockAnimation BounceInRight =
        new StockAnimation(const Duration(milliseconds: 500), _BounceInRight,AnimationTiming.EASE_IN_OUT);

    static final StockAnimation FadeIn =
        new StockAnimation(const Duration(milliseconds: 500), _FadeIn,AnimationTiming.EASE_IN_OUT);

    static final StockAnimation FadeOut =
        new StockAnimation(const Duration(milliseconds: 500), _FadeOut,AnimationTiming.EASE_IN_OUT);

    static final StockAnimation FlushRight =
        new StockAnimation(const Duration(milliseconds: 500), _FlushRight,AnimationTiming.EASE_IN_OUT);

    static final StockAnimation MoveUpAndDisappear =
        new StockAnimation(const Duration(milliseconds: 400), _MoveUpAndDisappear,AnimationTiming.EASE_IN_OUT);

    /// Modify the [StockAnimation] to your needs
    ///
    ///     final MdlAnimation bounceIn = new MdlAnimation.fromStock(
    ///         StockAnimation.BounceInTop.change(duration: new Duration(milliseconds: 800)));
    ///
    StockAnimation change({ final Duration duration }) {
        final StockAnimation newVersion = new StockAnimation(this.duration,this.keyframes,this.timing);
        if(duration != null) {
            newVersion.duration = duration;
        }
        return newVersion;
    }

}