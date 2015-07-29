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
class _MaterialObserveCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialObserveCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialObserveConstant {

    static const String WIDGET_SELECTOR = "mdl-observe";

    const _MaterialObserveConstant();
}    


class MaterialObserve extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdldirective.MaterialObserve');

    static const _MaterialObserveCssClasses _cssClasses = const _MaterialObserveCssClasses();
    static const _MaterialObserveConstant _constant = const _MaterialObserveConstant();

    Scope scope;

    MaterialObserve.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

//        _logger.info("Vor SCOPE1----------");
//
//        scope = new Scope(this, mdlParentScope(this));
//
//        _logger.info("Nach SCOPE1______ ${scope.parentContext} ___________");
//
//        _init();
    }
    
    static MaterialObserve widget(final dom.HtmlElement element) => mdlComponent(element,MaterialObserve) as MaterialObserve;

    @public
    void set value(final val) => element.text = (val != null ? val.toString() : "");

    @public
    String get value => element.text.trim();

    @override
    void attached() {
        scope = new Scope(this,mdlParentScope(this));
        _init();
    }

    // --------------------------------------------------------------------------------------------
    // EventHandler

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialObserve - init");

        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialObserveConstant.WIDGET_SELECTOR);

        if(element.attributes[_MaterialObserveConstant.WIDGET_SELECTOR].isNotEmpty) {
            final List<String> parts = element.attributes[_MaterialObserveConstant.WIDGET_SELECTOR].trim().split("|");
            final String fieldname = parts.first.trim();

            //_logger.info("$fieldname - ${parts.length}");
            FormatterPipeline pipe = new FormatterPipeline.fromList(injector.get(Formatter),parts.getRange(1,parts.length));

            scope.context = scope.parentContext;
            final val = (new Invoke(scope)).field(fieldname);

            void _setValue(dynamic val) {
                val = pipe.format(val);
                element.text = (val != null ? val.toString() : "");
            }

            if(val != null && val is ObservableProperty) {
                final ObservableProperty prop = val;

                _setValue(prop.value);
                prop.onChange.listen( (final PropertyChangeEvent event) => _setValue(event.value));

            } else {

                _setValue(val);
            }

            //_logger.info("Property done!");
        }
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

/// registration-Helper
void registerMaterialObserve() {
    final MdlConfig config = new MdlConfig<MaterialObserve>(
        _MaterialObserveConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialObserve.fromElement(element,injector)
    );
    
    // if you want <mdl-property></mdl-property> set isSelectorAClassName to false.
    // By default it's used as a class name. (<div class="mdl-property"></div>)
    config.selectorType = SelectorType.ATTRIBUTE;

    componentHandler().register(config);
}

