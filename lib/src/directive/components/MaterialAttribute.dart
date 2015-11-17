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
class _MaterialAttributeCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialAttributeCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialAttributeConstant {

    static const String WIDGET_SELECTOR = "mdl-attribute";

    const _MaterialAttributeConstant();
}

/**
 * Checks the given condition and adds the given attribute to the components [element].
 * Format: [!]<variable> : '<attribute>'
 *
 * If you put a exclamation mark in front of <variable> the returned value will be inverted
 * Variable-Context is "parent". parent is either the next "[ScopeAware]' parent or root-context (MaterialApplication)
 *
 *    <div class="controls">
 *        <div class="mdl-textfield mdl-js-textfield">
 *            <input class="mdl-textfield__input" type="text" id="sample-text-attribute" mdl-attribute="!checkAttribute : 'disabled' "/>
 *            <label class="mdl-textfield__label" for="sample-text-attribute" mdl-class="checkAttribute : 'enabled'">
 *            <span class="enabled">Type something</span>
 *            <span class="disabled">I'm Disabled</span>
 *        </label>
 *        </div>
 *        <button class="mdl-button mdl-js-button mdl-js-ripple-effect" mdl-attribute="!checkAttribute : 'disabled' ">Submit</button>
 *    </div>
 *
 *    @MdlComponentModel @di.Injectable()
 *    class Application extends MaterialApplication {
 *          ...
 *          final ObservableProperty<bool> checkBorder = new ObservableProperty<bool>(false);
 *    }
 *
 */
@MdlComponentModel
class MaterialAttribute extends MdlComponent {
    final Logger _logger = new Logger('mdldirective.MaterialAttribute');

    //static const _MaterialAttributeConstant _constant = const _MaterialAttributeConstant();
    static const _MaterialAttributeCssClasses _cssClasses = const _MaterialAttributeCssClasses();

    bool _isElementAWidget = null;

    MaterialAttribute.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
    }
    
    static MaterialAttribute widget(final dom.HtmlElement element) => mdlComponent(element,MaterialAttribute) as MaterialAttribute;

    @override
    void attached() {
        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialAttribute - init");
        
        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialAttributeConstant.WIDGET_SELECTOR);

        final Map<String,String> conditions = _splitConditions(_attribute);
        conditions.forEach((String varname,String attributeToSet) {
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

            String valueToSet = "";
            if(attributeToSet.contains("=")) {
                valueToSet = attributeToSet.split("=").last.replaceAll(new RegExp("(\"|\')"),"").trim();
                attributeToSet = attributeToSet.split("=").first;
            }

            final val = (new Invoke(scope)).field(varname);
            if (val != null && val is ObservableProperty) {

                final ObservableProperty prop = val;

                void _setValue(final bool value) {
                    if(value) {
                        element.setAttribute(attributeToSet,valueToSet);
                    } else {
                        element.attributes.remove(attributeToSet);
                    }

                    if(_isWidget) {
                        final MdlComponent component = mdlComponent(element,null);
                        component.update();
                    }
                }

                _setValue(negateValue == false ? prop.toBool() : !prop.toBool());
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
    String get _attribute => element.attributes[_MaterialAttributeConstant.WIDGET_SELECTOR];
 
}

/// registration-Helper
void registerMaterialAttribute() {
    final MdlConfig config = new MdlConfig<MaterialAttribute>(
        _MaterialAttributeConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialAttribute.fromElement(element,injector)
    );
    
    // If you want <mdl-attribute></mdl-attribute> set selectorType to SelectorType.TAG.
    // If you want <div mdl-attribute></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdl-attribute"></div>)
    config.selectorType = SelectorType.ATTRIBUTE;
    
    componentFactory().register(config);
}

