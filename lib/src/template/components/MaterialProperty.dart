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

    const _MaterialPropertyConstant();
}    

class MaterialProperty extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdltemplate.MaterialProperty');

    static const _MaterialPropertyCssClasses _cssClasses = const _MaterialPropertyCssClasses();

    Scope scope;

    MaterialProperty.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

        scope = new Scope(this, mdlParentScope(this));
        _init();
    }
    
    static MaterialProperty widget(final dom.HtmlElement element) => mdlComponent(element) as MaterialProperty;
    
    // Central Element - by default this is where mdl-property can be found (element)
    // html.Element get hub => inputElement;
    
    // --------------------------------------------------------------------------------------------
    // EventHandler

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialProperty - init");

        if(element.dataset.containsKey("mdl-property")) {
            final String fieldname = element.dataset["mdl-property"].trim();

            scope.context = scope.parentContext;

            final InstanceMirror myClassInstanceMirror = reflect(scope.context);
            final InstanceMirror getField = myClassInstanceMirror.getField(new Symbol(fieldname));
            final val = getField.reflectee;

            if(val != null && val is ObservableProperty) {

                final ObservableProperty prop = val;
                if(prop.value != null) {
                    element.text = prop.value.toString();;
                } else {
                    element.text = "";
                }
                prop.onChange.listen((final PropertyChangeEvent event) {
                    if(event.value != null) {
                        element.text = event.value.toString();
                    } else {
                        element.text = "";
                    }
                });
            }
            //_logger.info(getField);

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
    config.isSelectorAClassName = true;
    
    componentHandler().register(config);
}

