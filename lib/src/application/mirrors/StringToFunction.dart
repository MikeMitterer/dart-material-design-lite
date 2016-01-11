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

/**
 * Splits a String int function name and params
 *
 * Sample:
 *      <tag ... data-mdl-click="check({{id}})"></tag>
 *
 *      new StringToFunction("check(42)")
 *
 *      functionAsString: check
 *      params: 42
 *
 * Sample II:
 *      <span mdl-observe="isNameNull | choose(value, '(Name-Object is null!)','')"></span>
 *
 *      Group 0:                      choose(value, '(Name-Object is null!)','')
 *      functionAsString (Group 1):   StringToFunction: (13:19:27.342) Group 1: choose
 *      params (Group 2):             value, '(Name-Object is null!)',''
 *
 */
class StringToFunction {
    //final Logger _logger = new Logger('mdlapplication.StringToFunction');

    final String _functionAsString;

    // finds function name and params
    Match _match;

    StringToFunction(this._functionAsString) {
        Validate.notBlank(_functionAsString);

        // first group is the function name, second group are params (everything within braces))
        //_match = new RegExp(r"([^(]*)\(([^)]*)\)").firstMatch(_functionAsString);
        _match = new RegExp(r"([^(]*)\((.*)\)").firstMatch(_functionAsString);

        //for(int i = 0;i <= _match.groupCount;i++) { _logger.info("Group $i: ${_match.group(i)}"); }
        Validate.isTrue(_match.groupCount > 0 && _match.groupCount <= 2,"${_functionAsString} is not a valid function");
    }

    // from the above sample this would be: check
    String get function => _match.group(1);

    // from the above sample this would be: check
    @deprecated
    String get functionAsString => _match.group(1);

    List get params {
        final List _params = new List();

        // first group is function name, second - params
        if(_match.groupCount == 2) {
            final List<String> matches = _match.group(2).split(",");
            if(matches.isNotEmpty && matches[0].isNotEmpty) {
                _params.addAll(matches);
            }
        }
        return _params;
    }
}
