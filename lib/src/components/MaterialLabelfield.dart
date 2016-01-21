/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
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
     
part of mdlcomponents;
 
/// Basic DI configuration for [MaterialLabelfield]
///
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new MaterialLabelfieldModule());
///         }     
///     }
class MaterialLabelfieldModule  extends di.Module {
    MaterialLabelfieldModule() {
        // bind(DeviceProxy);
        
        // -- services
        // bind(SignalService, toImplementation: SignalServiceImpl);
    }
} 

/// Controller for <div class="mdl-labelfield"></div>
///
/// HTML:
///     <div id="search_engine" class="mdl-labelfield mdl-labelfield--with-border">
///         <label class="mdl-labelfield__label ">Search engine</label>
///         <div class="mdl-labelfield__text">Google</div>
///     </div>
///
/// Dart:
///      final MaterialLabelfield label = MaterialLabelfield.widget(dom.querySelector("#search_engine"));
///      label.label = "Another search engine";
///      label.value = "Yahoo";
///
class MaterialLabelfield extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialLabelfield');

    //static const _MaterialLabelfieldConstant _constant = const _MaterialLabelfieldConstant();
    static const _MaterialLabelfieldCssClasses _cssClasses = const _MaterialLabelfieldCssClasses();

    MaterialLabelfield.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        
        _init();
    }
    
    static MaterialLabelfield widget(final dom.HtmlElement element) => mdlComponent(element,MaterialLabelfield) as MaterialLabelfield;

    String get label {
        final dom.HtmlElement _label = element.querySelector(".${_cssClasses.LABEL}");
        return _label != null ? _label.text.trim() : "";
    }

    void set label(final String v) {
        Validate.notNull(v);

        final dom.HtmlElement _label = element.querySelector(".${_cssClasses.LABEL}");
        if(_label != null) {
            // final HtmlEscape escaper = new HtmlEscape();
            // _label.text = (escaper.convert(v.trim()));
            _label.text = v.trim();
        }
    }

    String get value {
        final dom.HtmlElement _text = element.querySelector(".${_cssClasses.TEXT}");
        return _text != null ? _text.text.trim() : "";
    }

    void set value(final String v) {
        Validate.notNull(v);

        final dom.HtmlElement _text = element.querySelector(".${_cssClasses.TEXT}");
        if(_text != null) {
            // final HtmlEscape escaper = new HtmlEscape();
            // _text.text = (escaper.convert(v.trim()));
            _text.text = v.trim();
        }
    }

    // - EventHandler -----------------------------------------------------------------------------

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialLabelfield - init");
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

/// Registers the MaterialLabelfield-Component
///
///     main() {
///         registerMaterialLabelfield();
///         ...
///     }
///
void registerMaterialLabelfield() {
    final MdlConfig config = new MdlWidgetConfig<MaterialLabelfield>(
        _MaterialLabelfieldConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialLabelfield.fromElement(element,injector)
    );
    
    // If you want <MaterialLabelfield></MaterialLabelfield> set selectorType to SelectorType.TAG.
    // If you want <div MaterialLabelfield></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="MaterialLabelfield"></div>)
    config.selectorType = SelectorType.CLASS;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialLabelfieldCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    final String LABEL = 'mdl-labelfield__label';
    final String TEXT = 'mdl-labelfield__text';

    const _MaterialLabelfieldCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialLabelfieldConstant {

    static const String WIDGET_SELECTOR = "mdl-labelfield";

    const _MaterialLabelfieldConstant();
}  