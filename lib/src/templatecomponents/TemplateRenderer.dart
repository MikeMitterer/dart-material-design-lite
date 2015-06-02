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

part of mdltemplatecomponents;

@di.Injectable()
class TemplateRenderer {
    final Logger _logger = new Logger('mdltemplatecomponents.TemplateRenderer');

    /// Adds data to Dom
    DomRenderer _renderer;

    /// changes something like data-mdl-click="check({{id}})" into a callable Component function
    EventCompiler _eventCompiler;

    TemplateRenderer(this._renderer, this._eventCompiler);

    Renderer call(final dom.Element parent,final Object scope, String template() ) {
        Validate.notNull(parent);
        Validate.notNull(scope);

        String _template() {
            final String data = template();
            Validate.notNull(data,"Template for TemplateRenderer must not be null!!!!");

            return data.trim().replaceAll(new RegExp(r"\s+")," ");
        }

        Future _render() async {
            Validate.notNull(parent);
            Validate.notNull(scope);

            final Template mustacheTemplate = new Template(_template(),htmlEscapeValues: false);

            await _renderer.render(parent,mustacheTemplate.renderString(scope));
            _eventCompiler.compileElement(scope,parent);
        }

        return new Renderer(_render);
    }


    // - private ----------------------------------------------------------------------------------

}