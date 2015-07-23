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
class _MaterialClassCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialClassCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialClassConstant {

    static const String WIDGET_SELECTOR = "mdl-class";

    const _MaterialClassConstant();
}    

@MdlComponentModel
class MaterialClass extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdltemplate.MaterialClass');

    //static const _MaterialClassConstant _constant = const _MaterialClassConstant();
    static const _MaterialClassCssClasses _cssClasses = const _MaterialClassCssClasses();

    bool _isElementAWidget = null;

    Scope scope;

    MaterialClass.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
    }
    
    static MaterialClass widget(final dom.HtmlElement element) => mdlComponent(element,MaterialClass) as MaterialClass;
    
    @override
    void attached() {
        scope = new Scope(this,mdlParentScope(this));
        _init();
    }

    // --------------------------------------------------------------------------------------------
    // EventHandler

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------


    void _init() {
        _logger.info("MaterialClass - init");
        
        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialClassConstant.WIDGET_SELECTOR);

        final Map<String,String> conditions = _splitConditions();
        conditions.forEach((final String varname,final String classname) {
            _logger.info("Var: $varname -> $classname");

            if(_isWidget ) {

                final MdlComponent component = mdlComponent(element,null);
                final Scope componentScope = new Scope(component,mdlParentScope(component));
                scope.context = componentScope.context;

            } else {
                scope.context = scope.parentContext;
            }

            final val = (new Invoke(scope)).field(varname);
            if (val != null && val is ObservableProperty) {
                final ObservableProperty prop = val;
                prop.onChange.listen((_) {
                    if(prop.toBool()) {
                        element.classes.add(classname);
                    } else {
                        element.classes.remove(classname);
                    }
                });
            }

        });

        final dom.DivElement div = new dom.DivElement();
        div.appendText("Your '${_MaterialClassConstant.WIDGET_SELECTOR}' component works!");
        element.append(div);
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// Splits the attributes value (condition) into varnames and classnames.
    /// Format: <condition> : '<classname>', <condition> : '<classname>' ...
    Map<String,String> _splitConditions() {
        final Map<String,String> result = new Map<String,String>();

        if(element.attributes[_MaterialClassConstant.WIDGET_SELECTOR].isNotEmpty) {
            final List<String> conditions = element.attributes[_MaterialClassConstant.WIDGET_SELECTOR].split(",");
            conditions.forEach((final String condition) {
                final List<String> details = condition.split(":");
                if(details.length == 2) {

                    final String varname = details.first.trim();
                    final String classname = details.last.replaceAll("'","").trim();
                    result[varname] = classname;
                    //_logger.info("Var: $varname -> $classname");

                } else {

                    _logger.shout("Wrong condition format! Format should be <condition> : '<classname>' but was ${condition}");

                }
            });
        }

        return result;
    }

    /// Returns true if current element is a MDLWidget (MdlConfig.isWidget...)
    bool get _isWidget {
        if(_isElementAWidget == null) {
            _isElementAWidget = isMdlWidget(element);
        }
        return _isElementAWidget;
    }
}

/// registration-Helper
void registerMaterialClass() {
    final MdlConfig config = new MdlConfig<MaterialClass>(
        _MaterialClassConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialClass.fromElement(element,injector)
    );
    
    // If you want <mdl-class></mdl-class> set selectorType to SelectorType.TAG.
    // If you want <div mdl-class></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdl-class"></div>)
    config.selectorType = SelectorType.ATTRIBUTE;
    
    componentFactory().register(config);
}

