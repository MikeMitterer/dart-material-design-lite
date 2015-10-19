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
part of mdldialog;
 
/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialDialogComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialDialogComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialDialogComponentConstant {

    static const String WIDGET_SELECTOR = "mdl-dialog";

    const _MaterialDialogComponentConstant();
}   
 
/// Basic DI configuration for this Component or Service
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new MaterialDialogComponentModule());
///         }     
///     }
class MaterialDialogComponentModule  extends di.Module {
    MaterialDialogComponentModule() {
        // bind(DeviceProxy);
    }
} 

class MaterialDialogComponent extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdldialog.MaterialDialogComponent');

    //static const _MaterialDialogComponentConstant _constant = const _MaterialDialogComponentConstant();
    static const _MaterialDialogComponentCssClasses _cssClasses = const _MaterialDialogComponentCssClasses();

    Scope _scope;

    MaterialDialogComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

        _scope = new Scope(this, mdlParentScope(this));
        _init();
        
    }
    
    static MaterialDialogComponent widget(final dom.HtmlElement element) => mdlComponent(MaterialDialogComponent,element) as MaterialDialogComponent;
    
    // Central Element - by default this is where mdl-dialog can be found (element)
    // html.Element get hub => inputElement;
    
    // - EventHandler -----------------------------------------------------------------------------

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }

    Scope get scope => _scope;

    void set scope(final MaterialDialog dialog) {
        Validate.notNull(dialog);
        Validate.isTrue(dialog is MaterialDialog);
        _scope = new Scope(dialog,null);
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialDialogComponent - init");
        
//        final dom.DivElement sample = new dom.DivElement();
//        sample.text = "Your MaterialDialogComponent-Component works!";
//        element.append(sample);
//
//        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

/// registration-Helper
void registerMaterialDialogComponent() {
    final MdlConfig config = new MdlWidgetConfig<MaterialDialogComponent>(
        _MaterialDialogComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialDialogComponent.fromElement(element,injector)
    );
    
    // If you want <mdl-dialog></mdl-dialog> set selectorType to SelectorType.TAG.
    // If you want <div mdl-dialog></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdl-dialog"></div>)
    config.selectorType = SelectorType.CLASS;
    
    componentHandler().register(config);
}

