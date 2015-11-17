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
part of mdldirective;
 
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

/**
 * Checks the given condition and adds the given class-name to the components [element].
 * Format: [!]<variable> : '<classname>'
 *
 * If you put a exclamation mark in front of <variable> the returned value will be inverted
 * Variable-Context is "parent". parent is either the next "[ScopeAware]' parent or root-context (MaterialApplication)
 *
 * Sample:
 *
 *    <div class="testtext" mdl-class="checkBorder : 'withborder'">
 *       Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et
 *       dolore magna aliquyam erat, sed diam voluptua.
 *    </div>
 *
 *    <div class="switches">
 *        <label class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="switch-border">
 *            <input type="checkbox" id="switch-border" class="mdl-switch__input" mdl-model="checkBorder"/>
 *            <span class="mdl-switch__label">Switch 'border' on/off</span>
 *        </label>
 *    </div>
 *
 *    @MdlComponentModel @di.Injectable()
 *    class Application extends MaterialApplication {
 *          ...
 *          final ObservableProperty<bool> checkBorder = new ObservableProperty<bool>(false);
 *    }
 */
@MdlComponentModel
class MaterialClass extends MdlComponent {
    final Logger _logger = new Logger('mdldirective.MaterialClass');

    //static const _MaterialClassConstant _constant = const _MaterialClassConstant();
    static const _MaterialClassCssClasses _cssClasses = const _MaterialClassCssClasses();

    bool _isElementAWidget = null;

    MaterialClass.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
    }
    
    static MaterialClass widget(final dom.HtmlElement element) => mdlComponent(element,MaterialClass) as MaterialClass;
    
    @override
    void attached() {
        _init();
    }

    // --------------------------------------------------------------------------------------------
    // EventHandler

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------


    void _init() {
        _logger.fine("MaterialClass - init $element");
        
        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialClassConstant.WIDGET_SELECTOR);

        final Map<String,String> conditions = _splitConditions(_attribute);
        conditions.forEach((String varname,final String classname) {
            //_logger.info("Var: $varname -> $classname");

            final bool negateValue = varname.startsWith("!");
            if(negateValue) {
                varname = varname.replaceFirst("!","");
            }

            Scope scope;
            if(_isWidget ) {

                final MdlComponent component = mdlComponent(element,null);
                scope = new Scope(component,mdlParentScope(component));

            } else {
                scope = new Scope(this,mdlParentScope(this));
            }

            scope.context = scope.parentContext;

            final val = (new Invoke(scope)).field(varname);
            if (val != null && val is ObservableProperty) {

                final ObservableProperty prop = val;

                void _setValue(final bool value) {
                    if(value) {
                        element.classes.add(classname);
                    } else {
                        element.classes.remove(classname);
                    }

                    if(_isWidget) {
                        final MdlComponent component = mdlComponent(element,null);
                        component.update();
                    }
                }

                _setValue(negateValue == false ? prop.toBool() : !prop.toBool() );

                prop.onChange.listen((_) {
                    _setValue(negateValue == false ? prop.toBool() : !prop.toBool());
                });
            }

        });

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// Returns true if current element is a 'MaterialWidget' (MdlConfig.isWidget...)
    bool get _isWidget {
        if(_isElementAWidget == null) {
            _isElementAWidget = isMdlWidget(element);
        }
        return _isElementAWidget;
    }

    /// Returns the components attribute
    String get _attribute => element.attributes[_MaterialClassConstant.WIDGET_SELECTOR];
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

