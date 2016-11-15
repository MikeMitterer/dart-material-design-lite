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
     
part of mdlformatter;

/// [MaterialDummyFormatter]-Singleton is used for
/// MaterialComponents asking for a MaterialFormatter but haven't defined one
///
///     <div class="mdl-labelfield">
///         ...
///     </div>
MaterialDummyFormatter _dummyFormatter = null;

/// Controller for <element mdl-formatter="formattername()"></element>
///
/// <div class="mdl-textfield mdl-textfield--floating-label" mdl-formatter="lowercase(value)">
///     <input class="mdl-textfield__input" type="text" id="textfield">
///     <label class="mdl-textfield__label" for="textfield">X-Men (lowercase)</label>
/// </div>
///
@MdlComponentModel
class MaterialFormatter extends MdlComponent {
    final Logger _logger = new Logger('mdlformatter.MaterialFormatter');

    //static const _MaterialFormatterConstant _constant = const _MaterialFormatterConstant();
    static const _MaterialFormatterCssClasses _cssClasses = const _MaterialFormatterCssClasses();

    /// Like Unix Pipe for formatters
    FormatterPipeline _lazyPipe;

    MaterialFormatter.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        
        _init();
    }

    /// [widget] returns the registered mdl-formatter component for this [element] if it finds one but
    /// if there is no [MaterialFormatter] registered for [element]
    /// it returns a [MaterialDummyFormatter] to avoid null-pointer checks / null-pointer problems
    static MaterialFormatter widget(final dom.HtmlElement element) {
        MaterialFormatter formatter;
        try {
            formatter = mdlComponent(element,MaterialFormatter,showWarning: false) as MaterialFormatter;
        } on String {

            formatter = (_dummyFormatter ??= new MaterialDummyFormatter(element,componentFactory().injector));
        }
        return formatter;
    }
    
    String format(final value) => _pipeline.format(value);
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialFormatter - init");
        
        // Recommended - add SELECTOR as class if this component is a TAG or an ATTRIBUTE!
        element.classes.add(_MaterialFormatterConstant.WIDGET_SELECTOR);
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    UnmodifiableListView<String> get _parts {
        return new UnmodifiableListView<String>(
            element.attributes[_MaterialFormatterConstant.WIDGET_SELECTOR].trim().split("|"));
    }

    FormatterPipeline get _pipeline {
        if(_lazyPipe == null) {
            final UnmodifiableListView<String> parts = _parts;
            _lazyPipe = new FormatterPipeline.fromList(injector.get(Formatter),parts.getRange(0,parts.length));
        }
        return _lazyPipe;
    }
}

/// Created if a MaterialComponent has no [MaterialFormatter] registered but asks for one
///
/// Main purpose is to pass on the [format]-Function
class MaterialDummyFormatter extends MaterialFormatter {

    static const _MaterialFormatterCssClasses _cssClasses = const _MaterialFormatterCssClasses();

    MaterialDummyFormatter(final dom.HtmlElement element,final di.Injector injector)
        : super.fromElement(element,injector);

    @override
    String format(final value) => value.toString();

    @override
    void _init() {
        _logger.fine("MaterialDummyFormatter - init");

        // Recommended - add SELECTOR as class if this component is a TAG or an ATTRIBUTE!
        element.classes.add(_MaterialFormatterConstant.WIDGET_SELECTOR);

        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

/// Registers the MaterialFormatter-Component
///
///     main() {
///         registerMaterialFormatter();
///         ...
///     }
///
void registerMaterialFormatter() {
    final MdlConfig config = new MdlConfig<MaterialFormatter>(
        _MaterialFormatterConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialFormatter.fromElement(element,injector)
    );

    // Register this component before MaterialWidget so that we can kick in this
    // Formatter when we initialize a Widget (e.g. MaterialCheckbox or MaterialButton)
    config.priority = RegistrationPriority.PRE_WIDGET;

    // If you want <mdl-formatter></mdl-formatter> set selectorType to SelectorType.TAG.
    // If you want <div mdl-formatter></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdl-formatter"></div>)
    config.selectorType = SelectorType.ATTRIBUTE;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialFormatterCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialFormatterCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialFormatterConstant {

    static const String WIDGET_SELECTOR = "mdl-formatter";

    const _MaterialFormatterConstant();
}  