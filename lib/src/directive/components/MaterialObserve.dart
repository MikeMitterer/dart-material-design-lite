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
class _MaterialObserveCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialObserveCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialObserveConstant {

    static const String WIDGET_SELECTOR = "mdl-observe";

    final String TEMPLATE = "template";

    const _MaterialObserveConstant();
}

@MdlComponentModel
class MaterialObserve extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdldirective.MaterialObserve');

    static const _MaterialObserveCssClasses _cssClasses = const _MaterialObserveCssClasses();
    static const _MaterialObserveConstant _constant = const _MaterialObserveConstant();

    /// Like Unix Pipe for formatters
    FormatterPipeline _lazyPipe;

    /// Uses for rendering this component
    /// A template is optional! for MaterialObserver
    Template _mustacheTemplate;

    /// Adds data to Dom
    final DomRenderer _renderer;

    /// changes something like data-mdl-click="check({{id}})" into a callable Component function
    final EventCompiler _eventCompiler;

    Scope scope;

    MaterialObserve.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : _renderer = injector.get(DomRenderer), _eventCompiler = injector.get(EventCompiler),
            super(element,injector) {
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
            final UnmodifiableListView<String> parts = _parts;
            final String fieldname = parts.first.trim();

            final dom.Element templateTag = _templateTag;
            if(templateTag != null) {
                final String template = templateTag.innerHtml.trim().replaceAll(new RegExp(r"\s+")," "); // .replaceAll(new RegExp(r""),"");
                templateTag.remove();

                _mustacheTemplate = new Template(template,htmlEscapeValues: false);
             }

            scope.context = scope.parentContext;
            _logger.info(scope.context);
            final val = (new Invoke(scope)).field(fieldname);

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

    /// Searches for attribute template or template-tag, result can be null
    dom.Element get _templateTag {
        dom.Element temp = element.querySelector("[${_constant.TEMPLATE}]");
        return temp != null ? temp : element.querySelector(_constant.TEMPLATE);
    }


    /// mdl-observe attribute supports formatters (parts)
    /// These formatters are separated by | (pipe)
    /// Sample:
    ///     <span mdl-observe="name | lowercase(value)"></span> (LowerCaseFormatter)<br>
    UnmodifiableListView<String> get _parts {
        return new UnmodifiableListView<String>(
            element.attributes[_MaterialObserveConstant.WIDGET_SELECTOR].trim().split("|"));
    }

    FormatterPipeline get _pipe {
        if(_lazyPipe == null) {
            final UnmodifiableListView<String> parts = _parts;
            _lazyPipe = new FormatterPipeline.fromList(injector.get(Formatter),parts.getRange(1,parts.length));
        }
        return _lazyPipe;
    }

    ///
    void _setValue(dynamic val) {
        val = _pipe.format(val);

        if(_hasNoTemplate) {
            element.text = (val != null ? val.toString() : "");
        } else {
            _renderValue(val);
        }
    }

    void _renderValue(dynamic val) {
        if(val != null) {
            _renderer.render(element,_mustacheTemplate.renderString(val)).then((final dom.HtmlElement child) {
                _eventCompiler.compileElement(scope,child);
            });
        } else {
            void _cleanup() {
                UnmodifiableListView<dom.Node> nodes = new UnmodifiableListView(element.childNodes);
                nodes.forEach((final dom.Element child) {
                    if(child is dom.Element) {
                        componentHandler().downgradeElement(child).then((_) {
                            child.remove();
                        });
                    }
                });
                element.text = "";
            }
            _cleanup();
        }
    }

    bool get _hasTemplate => _mustacheTemplate != null;
    bool get _hasNoTemplate => !_hasTemplate;

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

