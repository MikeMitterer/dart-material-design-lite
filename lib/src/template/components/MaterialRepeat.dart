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
class _MaterialRepeatCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialRepeatCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialRepeatConstant {

    static const String WIDGET_SELECTOR = "mdl-repeat";

    const _MaterialRepeatConstant();
}    

@MdlComponentModel
class MaterialRepeat extends MdlTemplateComponent {
    final Logger _logger = new Logger('mdltemplate.MaterialRepeat');

    //static const _MaterialRepeatConstant _constant = const _MaterialRepeatConstant();
    static const _MaterialRepeatCssClasses _cssClasses = const _MaterialRepeatCssClasses();

    /// Adds data to Dom
    final DomRenderer _repeatRenderer;

    Template _mustacheTemplate;

    /// will be set to innerHtml of this component
    String _template = "<div>not set</div>";

    final List _items = new List();

    MaterialRepeat.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector), _repeatRenderer = injector.get(DomRenderer) {

        _init();
    }
    
    static MaterialRepeat widget(final dom.HtmlElement element) => mdlComponent(element) as MaterialRepeat;
    
    String name = "Mike";

    Future add(final item) async {
        _items.add(item);
        await _repeatRenderer.render(element,_mustacheTemplate.renderString(item),replaceNode: false);
        _logger.info("Renderer $item");
    }

    Future remove(final item) async {
        final int index = _items.indexOf(item);
        _logger.info("Index: $index");

        final dom.HtmlElement child = element.querySelector(":nth-child(${index + 1})");
        child.style.border = "1px solid red";
        new Timer(new Duration(milliseconds: 500), () {
            child.remove();
            _items.remove(item);
        });
    }

    Future insert(final int index,final item) async {
        _items.insert(index,item);

        final dom.HtmlElement child = element.querySelector(":nth-child(${index + 1})");
        child.style.border = "1px solid blue";
        _repeatRenderer.insert(element,child,_mustacheTemplate.renderString(item));
    }

    //- private -----------------------------------------------------------------------------------

    @override
    Future render() async {
       await Future.forEach(_items, (final item) async {
           await _repeatRenderer.render(element,_mustacheTemplate.renderString(item),replaceNode: false);
       });
    }

    Future _init() async {
        _logger.info("MaterialRepeat - init");

        _template = element.innerHtml.trim().replaceAll(new RegExp(r"\s+")," ");
        element.innerHtml = "";

        _mustacheTemplate = new Template(template,htmlEscapeValues: false);

        // await render();

        _logger.info("Rendered!");

        element.classes.add(_cssClasses.IS_UPGRADED);
    }


    //- Template -----------------------------------------------------------------------------------
    
    @override
    String get template => _template;
}

/// registration-Helper
void registerMaterialRepeat() {
    final MdlConfig config = new MdlWidgetConfig<MaterialRepeat>(
        _MaterialRepeatConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialRepeat.fromElement(element,injector)
    );
    
    // if you want <mdl-repeat></mdl-repeat> set isSelectorAClassName to false.
    // By default it's used as a class name. (<div class="mdl-repeat"></div>)
    config.isSelectorAClassName = true;
    
    componentFactory().register(config);
}

