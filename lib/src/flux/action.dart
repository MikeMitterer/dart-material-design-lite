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
     
part of mdlflux;

/// Gives you more infos about the action you receive
///
/// Signal is the simplest form of an action. It contains no data
/// Sample:
///     const BasicAction UpdateView = const BasicAction(
///         ActionType.Signal, const ActionName("mdl.mdlflux.updateview"));
///
/// Data: Action has some data
/// Json: Action has some JSON-Data
///
enum ActionType { Signal, Data, Json }

/// Strong-Typed [ActionName]
///
///     class ActivateDevice extends DataAction<String> {
///         static const ActionName NAME = const ActionName("sample.components.ActivateDevice");
///         ActivateDevice(final String id) : super(NAME,id);
///     }
///
class ActionName {
    final String name;
    const ActionName(this.name);
}

/// Simples form of an Action
///
///     class DataLoadedAction extends Signal {
///         static const ActionName NAME = const ActionName("sample.datastore.DataLoadedAction");
///         DataLoadedAction(): super(ActionType.Signal,NAME);
///     }
class Action {
    final ActionType type;
    final ActionName actionname;

    const Action(this.type, this.actionname);

    String get name => actionname.name;

    bool get hasData => false;
    bool get isJson => false;
}

/// This [Action] carries a data-package
///
///     class ActivateDevice extends DataAction<String> {
///         static const ActionName NAME = const ActionName("sample.components.ActivateDevice");
///         ActivateDevice(final String id) : super(NAME,id);
///     }
abstract class DataAction<T> extends Action {
    final T data;
    const DataAction(final ActionName name,this.data) : super(ActionType.Data,name);

    @override
    bool get hasData => data != null;
}