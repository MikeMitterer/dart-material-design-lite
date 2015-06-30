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

    final String DATA_LIST = "mdl-list";

    const _MaterialRepeatConstant();
}    

@MdlComponentModel
class MaterialRepeat extends MdlTemplateComponent {
    final Logger _logger = new Logger('mdltemplate.MaterialRepeat');

    static const _MaterialRepeatConstant _constant = const _MaterialRepeatConstant();
    static const _MaterialRepeatCssClasses _cssClasses = const _MaterialRepeatCssClasses();

    /// Adds data to Dom
    final DomRenderer _repeatRenderer;

    /// changes something like data-mdl-click="check({{id}})" into a callable Component function
    final EventCompiler _eventCompiler;

    Template _mustacheTemplate;

    /// will be set to innerHtml of this component
    String _template = "<div>not set</div>";

    /// {_items} holds all the items to render
    final List _items = new List();

    MaterialRepeat.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector),
            _repeatRenderer = injector.get(DomRenderer), _eventCompiler = injector.get(EventCompiler) {

        _init();
    }
    
    static MaterialRepeat widget(final dom.HtmlElement element) => mdlComponent(element,MaterialRepeat) as MaterialRepeat;

    /// Adds {item} to DOM, inside of {element}
    Future add(final item,{ var scope: null }) async {
        Validate.notNull(item);

        _items.add(item);
        final dom.HtmlElement renderedChild = await _repeatRenderer.render(element,_mustacheTemplate.renderString(item),replaceNode: false);

        scope = scope != null ? scope : item;
        _eventCompiler.compileElement(scope,renderedChild);

        _logger.fine("Renderer $item");
    }

    /// Removes item from DOM
    Future remove(final item) {
        Validate.notNull(item);

        final Completer completer = new Completer();

        final int index = _items.indexOf(item);
        _logger.fine("Index to remove: $index");

        if(index != -1) {
            final dom.HtmlElement child = element.children[index]; //querySelector("> *:nth-child(${index + 1})");

            if(child == null) {
                _logger.warning(
                    "Could not find $item in DOM-Tree (${_MaterialRepeatConstant.WIDGET_SELECTOR})"
                    ", so nothing to remove here...");
                completer.completeError("Could not find $item in DOM-Tree!");
            }

            _addBorderIfInDebugMode(child,"red");
            _logger.fine("Child to remove: $child Element ID: ${element.id}");

            new Timer(new Duration(milliseconds: 30), () {
                _items.remove(item);
                child.remove();
                completer.complete();
            });

        } else {
            _logger.warning("Could not find $item in ${_MaterialRepeatConstant.WIDGET_SELECTOR}, so nothing to remove here...");
            _logger.warning("Number of items in list: ${_items.length}, First: ${_items.first.name}");
            completer.completeError("Could not find $item in internal item list!");
        }

        return completer.future;
    }

    /// Inserts [item] at position [index]
    Future insert(final int index,final item,{ var scope: null }) async {
        //Validate.isTrue(index < 0 || index > _items.length,"Index must be > 0 and < ${_items.length}");
        Validate.notNull(item);

        _items.insert(index,item);
        final dom.HtmlElement child = element.children[index]; //element.querySelector(":nth-child(${index + 1})");
        _addBorderIfInDebugMode(child,"blue");

        final dom.HtmlElement renderedChild = await _repeatRenderer.renderBefore(element,child,_mustacheTemplate.renderString(item));
        _addBorderIfInDebugMode(renderedChild,"green");

        scope = scope != null ? scope : item;
        _eventCompiler.compileElement(scope,renderedChild);
    }

    /// Swaps [item1] and [item2]
    void swap(final item1,final item2) {
        Validate.notNull(item1);
        Validate.notNull(item2);

        final int index1 = _items.indexOf(item1);
        final int index2 = _items.indexOf(item2);

        _logger.fine("Swap: ${item1.name} ($index1) -> ${item2.name} ($index2)");

        _items[index1] = item2;
        _items[index2] = item1;

        dom.HtmlElement child1 = element.children[index1];
        dom.HtmlElement child2 = element.children[index2];

        // create marker element and insert it where child1 is
        var temp = new dom.DivElement();
        child1.parentNode.insertBefore(temp, child1);

        // move child1 to right before child2
        child2.parentNode.insertBefore(child1, child2);

        // move child2 to right before where child1 used to be
        temp.parentNode.insertBefore(child2, temp);

        // remove temporary marker node
        temp.remove();
    }

    /// Removes all Children
    Future removeAll() {
        final Completer completer = new Completer();

        new Future(() {
            _items.clear();
            element.children.clear();
            completer.complete();
        });

        return completer.future;
    }

    //- private -----------------------------------------------------------------------------------

    Future _init() async {
        _logger.fine("MaterialRepeat - init");

        final dom.Element templateBlock = element.querySelector("[template]");
        templateBlock.attributes.remove("template");

        _template = templateBlock.parent.innerHtml.trim()
            .replaceAll(new RegExp(r"\s+")," ")
            .replaceAll(new RegExp(r""),"");

        templateBlock.remove();

        _mustacheTemplate = new Template(template,htmlEscapeValues: false);

        if(element.dataset.containsKey(_constant.DATA_LIST)) {
            _initListFromRootContext();
        }

        element.classes.add(_cssClasses.IS_UPGRADED);
        _logger.fine("MaterialRepeat - initialized!");
    }

    @override
    /// dummy - not main-Template
    Future render() => new Future(() {} );

    void _addBorderIfInDebugMode(final dom.HtmlElement child,final String color) {
        if(visualDebugging) {
            child.style.border = "1px solid $color";
        }
    }

    void _initListFromRootContext() {
        Validate.isTrue(element.dataset.containsKey(_constant.DATA_LIST));

        final String dataset = element.dataset[_constant.DATA_LIST].trim();
        final List<String> parts = dataset.split(" ");

        if(parts.length != 3) {
            throw new ArgumentError("data-${_constant.DATA_LIST} must have the following format: <item> in <listname> "
                "but was: $dataset!");
        }

        final String listName = dataset.split(" ").last;
        final String itemName = dataset.split(" ").first;

/*
        Object rootContext;
        try {
            rootContext = injector.getByKey(MDLROOTCONTEXT);

        } on Error {

            throw new ArgumentError("Could not find rootContext. "
                "Please define something like this: "
                "componentFactory().rootContext(AppController).run().then((_) { ... }");
        }
*/
        scope.context = scope.parentContext;

        _logger.info("Itemname: $itemName, Listname: $listName in ${scope.context}");

        final InstanceMirror myClassInstanceMirror = reflect(scope.context);
        final InstanceMirror getField = myClassInstanceMirror.getField(new Symbol(listName));
        _logger.info(getField);

        final List list = getField.reflectee;
        list.forEach( (final item) => add({ itemName : item },scope: scope.context));

        Map _getItemFromInternalList(final item) {
            return _items.firstWhere((final Map<String,dynamic> map) {
                return map.containsKey(itemName) && map[itemName] == item;
            });
        }

        if(list is ObservableList) {
            _logger.info("List ist Observable!");
            (list as ObservableList).onChange.listen((final ListChangedEvent event) {
                switch(event.changetype) {
                    case ListChangeType.ADD:
                        add( { itemName : event.item },scope: scope.context);
                        break;

                    case ListChangeType.CLEAR:
                        removeAll();
                        break;

                    case ListChangeType.UPDATE:
                        final Map itemToRemove = _getItemFromInternalList(event.prevItem);
                        final int index = _items.indexOf(itemToRemove);

                        remove(itemToRemove).then((_) {
                            if(index < _items.length) {
                                insert(index, { itemName : event.item },scope: scope.context);
                            } else {
                                add( { itemName : event.item },scope: scope.context);
                            }
                        });
                        break;

                    case ListChangeType.REMOVE:
                            final Map itemToRemove = _getItemFromInternalList(event.item);
                            remove(itemToRemove);
                        break;
                }
            });
        }
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

