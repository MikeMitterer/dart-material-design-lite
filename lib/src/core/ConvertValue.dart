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

part of mdlcore;

/// Converts dynamic values to strong-typed values
class ConvertValue {
    //final Logger _logger = new Logger('mdlcore.ConvertValue');

    static bool toBool(final value) {
        if(value == null) {
            return false;
        }

        if(value is bool) {
            return value as bool;
        }

        if(value is num) {
            return (value as num).toInt() == 1;
        }
        final String stringvalue = "$value".toLowerCase();
        return stringvalue == "true" || stringvalue == "on" || stringvalue == "1" || stringvalue == "yes";
    }

    static int toInt(final value) {
        if(value is int) {
            return value;
        }
        if(value is num) {
            return (value as num).toInt();
        }
        final String stringvalue = "$value".toLowerCase();
        return int.parse(stringvalue);
    }

    static double toDouble(final value) {
        if(value is double) {
            return value;
        }
        if(value is num) {
            return (value as num).toDouble();
        }
        final String stringvalue = "$value".toLowerCase();
        return double.parse(stringvalue);
    }

    /// Removes ' and " around the give value
    /// and converts [value] to String
    static String toSanitizeString(final value) {
        return "$value".trim().replaceAll(new RegExp(r"(^'|'$)"),"").replaceAll(new RegExp(r'(^"|"$)'),"");
    }

    //- private -----------------------------------------------------------------------------------
}
