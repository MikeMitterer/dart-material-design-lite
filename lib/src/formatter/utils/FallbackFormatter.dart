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

part of mdlformatter;

/// Helper-Class to get the right [MaterialFormatter] if a [MdlComponent] could have
/// registered more than one [MaterialFormatter]
///
///     class MaterialLabelfield extends MdlComponent with FallbackFormatter {
///         ...
///
///         void set value(final String v) {
///             final dom.HtmlElement _text = element.querySelector(".${_cssClasses.TEXT}");
///             _text?.text = formatterFor(_text).format(v);
///         }
///
abstract class FallbackFormatter {

    dom.Element get element;

    /// Checks if [inquirer] has a [MaterialFormatter] and returns the Formatter.
    /// If it has no formatter it returns the [element]-Formatter
    MaterialFormatter formatterFor(final dom.Element inquirer) {
        Validate.notNull(inquirer);

        MaterialFormatter formatter = MaterialFormatter.widget(inquirer);
        if(formatter is MaterialDummyFormatter) {
            formatter = MaterialFormatter.widget(element);
        }
        return formatter;
    }

}
