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

typedef dynamic PipeCommand(dynamic val);

/**
 * Takes the return value of the first command as input for the next command - works like "unix pipes"
 * Basis is a HTML-Statement like this:
 *
 *      <span mdl-observe="pi | number(value,2) | decorate(value)"></span>
 *
 * pi returns a value this value is passed over to number. The return value of number is passed over to 'decorate'
 * 'decorate' is the last command in the chain so its output will be displayed.
 */
class FormatterPipeline {
    // final Logger _logger = new Logger('mdlformatter.FormatterPipeline');

    final _commands = new List<PipeCommand>();
    final Formatter _formatter;

    /// [_formatter] should be obtained from injector
    ///     new FormatterPipeline(injector.get(Formatter))
    FormatterPipeline(this._formatter) {
        Validate.notNull(_formatter);
    }

    /**
     * [_formatter] should be obtained from injector
     *     new FormatterPipeline(injector.get(Formatter))
     *
     * [parts] is a list of formatter-names
     *
     *      HTML: <span mdl-observe="pi | number(value,2) | decorate(value)"></span>
     *      DART: final List<String> parts = element.attributes[_MaterialObserveConstant.WIDGET_SELECTOR].trim().split("|");
    */
    FormatterPipeline.fromList(this._formatter,final Iterable<String> parts) {
        Validate.notNull(_formatter);
        Validate.notNull(parts);

        _addCommands(parts);
    }

    void add(final PipeCommand command) {
        Validate.notNull(command);
        _commands.add(command);
    }

    /// Iterates over all the commands. Every command takes the result of the previous command as input.
    /// The result of the last command will be returned
    dynamic format(dynamic value) {
        _commands.forEach((final PipeCommand command) {
            value = command(value);
        });
        return value;
    }

    //- private -----------------------------------------------------------------------------------

    /// Generates PipeCommands from [parts]
    void _addCommands(final Iterable<String> parts) {
        //_logger.info("P ${parts.length}");

        parts.forEach((final String part) {

            add( (dynamic val) {

                final String formatter = part.trim();
                final StringToFunction stf = new StringToFunction(formatter);

                // Parent-Scope null is OK here because we don't need it
                final Invoke formatterFunction = new Invoke(new Scope(new Formatter(),null));

                val = formatterFunction.function(stf,varsToReplace: { "value" : val });
                return val;

            });

        });
    }
}
