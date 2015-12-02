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

/// Creates a JSON-Map
///
/// This class should / could be a mixin for [JsonAction]-Actions
///
///     class AlertAction extends JsonAction<AlertActionData> with ToJsonEvent {
///         ...
///         Map<String,dynamic> toJson() => convert(NAME.toString(),data);
///     }
class ToJsonEvent<T extends ToJson> {

    String get eventKey => "event";
    String get dataKey => "data";

    Map<String,dynamic> convert(final String eventname,final T data) {
        Validate.notBlank(eventname,"Eventname must not be blank!");
        Validate.notNull(data,"Event-Data must not be null!");

        final Map map = new Map<String, dynamic>();

        map[eventKey] = eventname;
        map[dataKey] = data.toJson();

        return map;
    }

    Map<String,dynamic> call(final String eventname,final T data) => convert(eventname,data);
}