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

part of mdlformatter;

/// Choose between two Text options.
/// ChooseFormatter must be registered in mdlformatter.Formatter
/// Sample:
///     <span mdl-observe="isNameNull | choose(value, '(Name-Object is null!)','')"></span>
@MdlComponentModel
class ChooseFormatter {
    // final Logger _logger = new Logger('mdlformatter.ChooseFormatter');

    String choose(final bool value,[ final String option1 = "Yes",final String option2 = "No" ]) {
        return (value ? option1 : option2);
    }

    /// Called by the framework - sanitizes input. (In reality params are not strong typed!)
    String call(final value,[ final String option1 = "Yes",final String option2 =  "No" ])
        => choose(ConvertValue.toBool(value),
            ConvertValue.toSanitizeString(option1),ConvertValue.toSanitizeString(option2));

    //- private -----------------------------------------------------------------------------------

}