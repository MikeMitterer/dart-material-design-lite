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

library mdlutils;

/**
 * Helper for requesting a proper value
 * from the components HTML-Element
 *
 * Sample:
 *      Dart:
 *          class YourComponent extends MdlTemplateComponent {
 *
 *              bool get savable => DataAttribute.forValue(element.dataset["savable"]).asBool();
 *
 *              ...
 *              }
 *
 *      HTML:
 *          <apikey data-savable="true" data-deletable="true"></apikey>
 */
class DataAttribute {

    static _DataValue forValue(final dynamic value) {
        return new _DataValue(value);
    }
}

class _DataValue {
    final dynamic _value;

    _DataValue(this._value);

    /// turns value into a boolean
    /// {handleEmptyString} defines how an empty String should be treated
    bool asBool({ final bool handleEmptyStringAs: false }) {
        if(_value == null) {
            return false;

        } else  if(_value is num) {
            return (_value as num).toInt() == 1;

        } else  if(_value is bool) {
            return _value;

        // IntelliJ needs the "as String" to support autocompletion...
        } else if((_value.toString() as String).toLowerCase() == "true" ||
        _value.toString() == "1" || _value.toString() == "yes" ) {

            return true;

        } else if((_value.toString() as String).isEmpty) {
            return handleEmptyStringAs;
        }

        return false;
    }
}

