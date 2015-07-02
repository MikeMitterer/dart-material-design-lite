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

part of mdlapplication;

class Invoke {
    final Logger _logger = new Logger('mdlapplication.Invoke');

    final Scope _scope;

    Invoke(this._scope) {
        Validate.notNull(_scope);
    }

    void function(final StringToFunction stringToFunction, { final Map<String,dynamic> varsToReplace: const {} }) {
        Validate.notNull(stringToFunction);

        final InstanceMirror myClassInstanceMirror = reflect(_scope.context);
        final Symbol myFunction = stringToFunction.function;

        final List params = new List();
        stringToFunction.params.forEach((final String paramName) {
            if(varsToReplace.containsKey(paramName)) {

                params.add(varsToReplace[paramName]);

            } else if(varsToReplace.containsKey("\$$paramName")) {

                params.add(varsToReplace["\$$paramName"]);

            } else {

                params.add(paramName);

            }
        });

        _logger.info("Invoke Function: ${stringToFunction.functionAsString}(${stringToFunction.params})");
        myClassInstanceMirror.invoke(myFunction,params);
    }
}