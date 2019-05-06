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

/// Helper to prettyPrint JSON, used in [JsonAction.toPrettyString]
const JsonEncoder _PRETTYJSON = const JsonEncoder.withIndent('   ');

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

    String toString() => name;

    bool operator==(final Object actionname) {
        if(actionname is! ActionName) {
            return false;
        }

        return name == (actionname as ActionName).name;
    }

    int get hashCode => name.hashCode;
}

/// Simples form of an Action
///
///     class DataLoadedAction extends Action {
///         static const ActionName NAME = const ActionName("sample.datastore.DataLoadedAction");
///         DataLoadedAction(): super(ActionType.Signal,NAME);
///     }
abstract class Action {
    final ActionType type;
    final ActionName actionname;

    const Action(this.type, this.actionname);

    ActionName get name => actionname;

    bool get hasData => false;
    bool get isJson => false;

    String toString() => actionname.name;
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

/// This [Action] carries a special data-package. The data-package can be serialized to JSON
///
///     class AlertAction extends JsonAction<AlertActionData> {
///         static const ActionName NAME = const ActionName("sample.components.AlertAction");
///         ActivateDevice(final AlertActionData data) : super(NAME,data);
///     }
///
///     class AlertActionData extends JsonTO {
///     ...
///     }
///
abstract class JsonAction<T extends ToJson> extends Action implements ToJson {
    final T data;
    const JsonAction(final ActionName name,this.data) : super(ActionType.Json,name);

    @override
    bool get hasData => data != null;

    @override
    bool get isJson => true && hasData;

    @override
    String toString() {
        return json.encode(toJson());
    }

    /// JSON-String wird eingerückt!
    String toPrettyString() {
        return _PRETTYJSON.convert(toJson());
    }
}