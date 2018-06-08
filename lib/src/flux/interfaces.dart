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

/// Main-Class for sending [Action]s
@inject
abstract class ActionBus {

    void fire(final Action action);

    Stream<Action> on(final ActionName actionname);

    factory ActionBus() { return new ActionBusImpl(); }

}

/// Marker for all objects that can be deserialize from Json
abstract class FromJson {
    void fromJson(final data);
}

/// Marker for all objects that can be serialized to Json
abstract class ToJson {
    Map<String, dynamic> toJson();
}

/// Marker for all objects that can be serialized and deserialize from Json
abstract class JsonObject implements FromJson,ToJson { }


