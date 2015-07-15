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
part of mdltemplate;
 
/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialPropertyCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialPropertyCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialPropertyConstant {

    static const String WIDGET_SELECTOR = "mdl-property";

    final String OBSERVE = "observe";

    const _MaterialPropertyConstant();
}    

class MaterialProperty extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdltemplate.MaterialProperty');

    static const _MaterialPropertyCssClasses _cssClasses = const _MaterialPropertyCssClasses();
    static const _MaterialPropertyConstant _constant = const _MaterialPropertyConstant();

    Scope scope;

    MaterialProperty.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

        scope = new Scope(this, mdlParentScope(this));
        _init();
    }
    
    static MaterialProperty widget(final dom.HtmlElement element) => mdlComponent(element,MaterialProperty) as MaterialProperty;

    @public
    void set value(final val) => element.text = (val != null ? val.toString() : "");

    @public
    String get value => element.text.trim();

    // --------------------------------------------------------------------------------------------
    // EventHandler

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialProperty - init");

        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialPropertyConstant.WIDGET_SELECTOR);

        if(element.attributes.containsKey(_constant.OBSERVE)) {
            final String fieldname = element.attributes[_constant.OBSERVE].trim();

            scope.context = scope.parentContext;
            final val = (new Invoke(scope)).field(fieldname);

            void _setValue(final val) {
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
void registerMaterialProperty() {
    final MdlConfig config = new MdlWidgetConfig<MaterialProperty>(
        _MaterialPropertyConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialProperty.fromElement(element,injector)
    );
    
    // if you want <mdl-property></mdl-property> set isSelectorAClassName to false.
    // By default it's used as a class name. (<div class="mdl-property"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

