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

part of mdltemplate;


/// Basis for all MdlComponents with Templates
abstract class MdlTemplateComponent extends MdlComponent implements TemplateComponent, ScopeAware {
    final Logger _logger = new Logger('mdltemplate.MdlTemplateComponent');

    /// {_renderer} takes the template, renders the current object to a resulting String
    /// and adds this String as DOM-Tree to the DOM
    Renderer _renderer;

    /**
     *  Makes it easy to add functionality to templates
     *  Sample:
     *      Template: "{{lambdas.classes}}, {{lambdas.attributes}}
     *
     *  class MyClass extends Object with TemplateComponent {
     *      MyClass() {
     *          lambdas["classes"] = (_) => "is-enabled";
     *          lambdas["attributes"] = attributes;
     *      }
     *
     *      String get attributes => "disabled";
     *  }
     */
    final Map<String,LambdaFunction> lambdas = new Map<String,LambdaFunction>();

    Scope _scope;

    MdlTemplateComponent(final dom.Element element,final di.Injector injector)
      : super(element,injector) {

        Validate.notNull(element);
        Validate.notNull(injector);

        final TemplateRenderer templateRenderer = injector.get(TemplateRenderer);
        _renderer = templateRenderer.call(element,this,() => template);
    }

    Future render() {
        return _renderer.render();
    }

    void set renderer(final Renderer renderer) {
        Validate.notNull(renderer);
        _renderer = renderer;
    }

    Scope get scope {
        if(_scope == null) {
            _scope = new Scope(this, mdlParentScope(this));
        }
        return _scope;
    }
}