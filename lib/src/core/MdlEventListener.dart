/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
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

part of mdlcore;

/// Mixin to cleanup StreamSubscriptions for [MdlComponent]s and
/// [MaterialDialog]s
///
///     abstract class MdlComponent extends Object with MdlEventListener {
///         ...
///     }
///
///     class MyComponent extends MdlComponent {
///         ...
///         void _init() {
///             ...
///             eventStreams.add(
///                 myButton.onClick.listen((_) {
///                     ...
///                 });
///         }
///     }
abstract class MdlEventListener {

    /// All the registered Events - helpful for automatically downgrading the element
    /// Sample:
    ///     eventStreams.add(input.onFocus.listen( _onFocus));
    final List<StreamSubscription> eventStreams = new List<StreamSubscription>();
    
    //- private -----------------------------------------------------------------------------------
}
