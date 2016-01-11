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

part of mdlapplication;

class Invoke {
    final Logger _logger = new Logger('mdlapplication.Invoke');

    final Scope _scope;

    Invoke(this._scope) {
        Validate.notNull(_scope);
    }

    dynamic function(final StringToFunction stringToFunction, { final Map<String,dynamic> varsToReplace: const {} }) {
        Validate.notNull(stringToFunction);

        final InstanceMirror myClassInstanceMirror = mdltemplate.reflect(_scope.context);
        final String myFunction = stringToFunction.function;

        final List params = new List();
        stringToFunction.params.forEach((final String paramName) {
            //_logger.info("Param: $paramName");

            if(varsToReplace.containsKey(paramName)) {

                //_logger.info("$paramName -> ${varsToReplace[paramName]}");
                params.add(varsToReplace[paramName]);

            } else if(varsToReplace.containsKey("\$$paramName")) {

                params.add(varsToReplace["\$$paramName"]);

            } else {

                params.add(paramName);

            }
        });

        _logger.fine("Function: ${stringToFunction.function}(${params})");

        final InstanceMirror im = myClassInstanceMirror.invoke(myFunction,params);
        return im.reflectee;
    }

    /// Returns the object for the given [fieldname]. If [fieldname] is separated with dots
    /// it iterates through all the fields and returns the object for the last part of [fieldname]
    ///
    /// Example:
    ///     final val = (new Invoke(_scope)).field("proxy.name");
    ///
    ///     val becomes the "name"-Object
    ///
    dynamic field(final String fieldname) {
        Validate.notBlank(fieldname);

        Object context = _scope.context;
        final List<String> names = fieldname.split(".");

        names.forEach((final String name) {
            final InstanceMirror myClassInstanceMirror = mdltemplate.reflect(context);

            if(!name.contains(new RegExp(r"\[[^\]]*\]$"))) {

                //final InstanceMirror getField = myClassInstanceMirror.invokeGetter(name);
                context = myClassInstanceMirror.invokeGetter(name);

            } else {
                final List<String> parts = name.trim().split(new RegExp(r"(\[|\])"));
                //_logger.info("FFFFFx $name >${parts[1]}<, ${parts.length}");

                final InstanceMirror instanceMirror = myClassInstanceMirror.invokeGetter(parts[0]);
                final String function = "[]";

                //final InstanceMirror getField = instanceMirror.invoke(function,[ int.parse(parts[1]) ]);
                context = instanceMirror.invoke(function,[ int.parse(parts[1]) ]);
                // _logger.info("Value $context");
            }

        });


        final obj = context;

        _logger.fine("Field: ${obj}");
        return obj;
    }
}

