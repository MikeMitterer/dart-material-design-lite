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
part of mdldirective;
 
/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialModelCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialModelCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialModelConstant {

    static const String WIDGET_SELECTOR = "mdl-model";

    const _MaterialModelConstant();
}    

class MaterialModel extends MdlComponent {
    final Logger _logger = new Logger('mdldirective.MaterialModel');

    //static const _MaterialModelConstant _constant = const _MaterialModelConstant();
    static const _MaterialModelCssClasses _cssClasses = const _MaterialModelCssClasses();

    Scope _scope;
    final ModelObserverFactory _observerFactory;

    MaterialModel.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector), _observerFactory = injector.get(ModelObserverFactory) {
    }

    @override
    void attached() {
        _scope = new Scope(this, mdlParentScope(this));
        _init();
    }
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialModel - init");

        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialModelConstant.WIDGET_SELECTOR);

        final String fieldname = element.attributes[_MaterialModelConstant.WIDGET_SELECTOR].trim();

        _scope.context = _scope.parentContext;

        final ModelObserver observer = _observerFactory.createFor(element);
        observer.observe(_scope,fieldname);

        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

/// registration-Helper
void registerMaterialModel() {
    final MdlConfig config = new MdlConfig<MaterialModel>(
        _MaterialModelConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialModel.fromElement(element,injector)
    );
    
    // If you want <mdl-model></mdl-model> set selectorType to SelectorType.TAG.
    // If you want <div mdl-model></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdl-model"></div>)
    config.selectorType = SelectorType.ATTRIBUTE;

    componentHandler().register(config);
}

