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

part of mdldirective;

/// Splits [conditionToSplit] into varnames and classnames.
/// Format: <condition> : '<classname>', <condition> : '<classname>' ...
Map<String,String> _splitConditions(final String conditionToSplit) {
    final Logger _logger = new Logger('mdltemplate._splitConditions');

    Validate.notNull(conditionToSplit);

    final Map<String,String> result = new Map<String,String>();

    if(conditionToSplit.isNotEmpty) {
        final List<String> conditions = conditionToSplit.split(",");
        conditions.forEach((final String condition) {
            final List<String> details = condition.split(":");
            if(details.length == 2) {

                final String varname = details.first.trim();
                final String classname = details.last.replaceAll("'","").trim();
                result[varname] = classname;
                //_logger.info("Var: $varname -> $classname");

            } else {

                _logger.shout("Wrong condition format! Format should be <condition> : '<classname>' but was ${condition}");

            }
        });
    }

    return result;
}
