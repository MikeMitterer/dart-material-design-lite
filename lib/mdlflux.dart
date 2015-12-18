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

/// MdlFlux implements unidirectional flow in contrast to popular frameworks such as Angular or Ember.
/// Even though two-directional bindings can be convenient, they come with a cost.
/// It can be hard to deduce what's going on and why.
///
/// When we trigger the action, the dispatcher will get notified.
/// The dispatcher will be able to deal with possible store dependencies.
/// It is possible that certain action needs to happen before another. Dispatcher allows us to achieve this.
///
/// At the simplest level, actions can just pass the message to dispatcher as is.
/// They can also trigger asynchronous queries and hit dispatcher based on the result eventually.
/// This allows us to deal with received data and possible errors.
///
/// Once the dispatcher has dealt with the action, stores that are listening to it get triggered.
/// As a result, it will be able to update its internal state.
/// After doing this it will notify possible listeners of the new state.
///
/// This completes the basic unidirectional, yet linear, process flow of MdlFlux.
/// Usually, though, the unidirectional process has a cyclical flow and it doesn't necessarily end.
/// The following diagram illustrates a more common flow.
///
/// It is the same idea again, but with the addition of a returning cycle.
/// Eventually the components depending our our store data become refreshed through this looping process.
/// 
/// **More infos about flux:**
///
/// * [Flux: An Application Architecture for React](https://facebook.github.io/react/blog/2014/05/06/flux.html)
///
/// * [React and Flux](http://survivejs.com/webpack_react/react_and_flux/)

library mdlflux;

import 'dart:async';

import 'package:di/di.dart' as di;
import 'package:validate/validate.dart';
import 'dart:convert';

part "src/flux/interfaces.dart";

part "src/flux/action.dart";
part "src/flux/ActionBusImpl.dart";
part "src/flux/DataStore.dart";
part "src/flux/Dispatcher.dart";
part "src/flux/Emitter.dart";
part "src/flux/mixin.dart";

/// Stock-Action that is emitted by the [Dispatcher.emitChange]-Function
class UpdateView extends Action {
    const UpdateView() : super(ActionType.Signal,const ActionName("mdl.mdlflux.datastore.update"));
}
const UpdateView UpdateViewAction = const UpdateView();

