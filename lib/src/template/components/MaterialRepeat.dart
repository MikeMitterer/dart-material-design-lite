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
part of mdltemplate;
 
/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialRepeatCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    final String KEEP_THIS_ELEMENT = "mdl-repeat__keep_this_element";

    const _MaterialRepeatCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialRepeatConstant {

    static const String WIDGET_SELECTOR = "mdl-repeat";

    /**
     * Used if child is a 'MdlDataConsumer' - e.g. MaterialDraggable
     *
     *      <div mdl-repeat="language in programming" class="mdl-dnd__drag-container">
     *          {{! ----- Turn off default mustache interpretation (sitegen) ---- }} {{= | | =}}
     *          <mdl-draggable template class="language" consumes="language" drop-zone="trash">
     *              {{language.name}}
     *          </mdl-draggable>
     *          |= {{ }} =| {{! ----- Turn on mustache ---- }}
     *      </div>
     *
     *      class MaterialDraggable extends MdlComponent implements MdlDataConsumer {
     *          ...
     *      }
     */
    final String CONSUMES   = "consumes";

    final String TEMPLATE   = "template";

    const _MaterialRepeatConstant();
}

/**
 * Iterates through a [ObservableList]
 * Sample:
 *      HTML:
 *          <div mdl-repeat="job in jobs">
 *              {{! ----- Turn off default mustache interpretation (sitegen) ---- }} {{= | | =}}
 *              <template>
 *                  <div class="mdl-accordion mdl-js-accordion">
 *                    <label class="mdl-accordion__label">{{job.ID}}
 *                        <jobtoolbar job-id="{{job.ID}}" class="jobtoolbar--right"></jobtoolbar>
 *
 *                        <i class="material-icons indicator">chevron_right</i></label>
 *
 *                        <div class="mdl-accordion--content">
 *                           <p class="mdl-accordion--body">
 *                             <jobedit job-id="{{job.ID}}"></jobedit>
 *                           </p>
 *                        </div>
 *                </div>
 *             </template>
 *             |= {{ }} =| {{! ----- Turn on mustache ---- }}
 *        </div>
 */
@MdlComponentModel
class MaterialRepeat extends MdlTemplateComponent {
    final Logger _logger = new Logger('mdltemplate.MaterialRepeat');

    static const _MaterialRepeatConstant _constant = const _MaterialRepeatConstant();
    static const _MaterialRepeatCssClasses _cssClasses = const _MaterialRepeatCssClasses();

    /// Adds data to Dom
    final DomRenderer _repeatRenderer;

    /// changes something like data-mdl-click="check({{id}})" into a callable Component function
    final EventCompiler _eventCompiler;

    /// Uses for rendering this component
    Template _mustacheTemplate;

    /// Will be set to outerHtml of this component.
    /// This component stamps out the html-tag marked with attribute "template"
    String _template = "<div>not set</div>";

    /// {_items} holds all the items to render
    final List _items = new List();

    MaterialRepeat.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : _repeatRenderer = injector.get(DomRenderer), _eventCompiler = injector.get(EventCompiler),
            super(element,injector) {

        _init();
    }
    
    static MaterialRepeat widget(final dom.HtmlElement element) => mdlComponent(element,MaterialRepeat) as MaterialRepeat;

    /// Adds {item} to DOM, inside of {element}
    Future add(final item,{ var scope: null }) async {
        Validate.notNull(item);
        Validate.notNull(_mustacheTemplate);

        _items.add(item);
        //_logger.shout("Item added to internal list... (Type: ${item}) ID: ${item["device"]}");

        final dom.HtmlElement renderedChild = await _repeatRenderer.render(element,
            _mustacheTemplate.renderString(item),replaceNode: false);

        _logger.fine("Adding data to consumer");
        _addDataToDataConsumer(renderedChild,item);
        _logger.fine("Data added to consumer");

        scope = scope != null ? scope : item;
        _eventCompiler.compileElement(scope,renderedChild);

        _logger.fine("Renderer $item Nr.of items: ${_items.length} ID: ${element.id}");
    }

    /// Removes item from DOM
    Future remove(final item) {
        Validate.notNull(item);

        final Completer completer = new Completer();

        final int index = _items.indexOf(item);

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

            componentHandler().downgradeElement(child);

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
        _addDataToDataConsumer(renderedChild,item);

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

    /// Removes all Children except those marked with mdl-repeat_keep_this_element
    Future removeAll() {
        final Completer completer = new Completer();

        if(_items.isNotEmpty) {
            _items.clear();
            //element.children.clear();
            element.children.removeWhere( (final dom.Element element) =>
                !element.classes.contains(_cssClasses.KEEP_THIS_ELEMENT));
        }
        new Future(() {
            completer.complete();
        });

        return completer.future;
    }

    @override
    /// dummy - no main-Template for this component.
    /// items are rendered in add and insert!
    Future render() => new Future(() {} );


    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialRepeat - init");

        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialRepeatConstant.WIDGET_SELECTOR);

        final dom.Element templateTag = _templateTag;
        _template = templateTag.innerHtml.trim().replaceAll(new RegExp(r"\s+")," ").replaceAll(new RegExp(r""),"");

        _logger.fine("Template: |${_template}|");
        templateTag.remove();

        _mustacheTemplate = new Template(template,htmlEscapeValues: false);

        /// Sample: <div mdl-repeat="language in languages">...</div>
        if(element.attributes[_MaterialRepeatConstant.WIDGET_SELECTOR].isNotEmpty) {
            new Future.delayed(new Duration(milliseconds: 50), _postInit);
        }

        element.classes.add(_cssClasses.IS_UPGRADED);
        _logger.fine("MaterialRepeat - initialized!");
    }

    /// Searches for attribute template or template-tag, result can be null
    dom.Element get _templateTag {
        dom.Element temp = element.querySelector("[${_constant.TEMPLATE}]");
        return temp != null ? temp : element.querySelector(_constant.TEMPLATE);
    }

    /// Wait until component is initialized - otherwise we have not a valid DOM structure.
    /// Means - parent is not ready and if we have not parent Scope fails...
    void _postInit() {
        _initListFromParentContext();
    }

    void _addBorderIfInDebugMode(final dom.HtmlElement child,final String color) {
        if(visualDebugging) {
            child.style.border = "1px solid $color";
        }
    }

    void _initListFromParentContext() {
        Validate.isTrue(element.attributes[_MaterialRepeatConstant.WIDGET_SELECTOR].isNotEmpty);
        Validate.isTrue(element.attributes[_MaterialRepeatConstant.WIDGET_SELECTOR].contains(new RegExp(r" in ")));

        final String dataset = element.attributes[_MaterialRepeatConstant.WIDGET_SELECTOR].trim();
        final List<String> parts = dataset.split(" ");

        if(parts.length != 3) {
            throw new ArgumentError("${_MaterialRepeatConstant.WIDGET_SELECTOR} must have the following format: '<item> in <listname>'"
                "but was: $dataset!");
        }

        /// Splits up mdl-repeat="job in jobs" into listName and itemName
        final String listName = dataset.split(" ").last;
        final String itemName = dataset.split(" ").first;

        scope.context = scope.parentContext;

        final List list = new Invoke(scope).field(listName);
        list.forEach( (final item) => add({ itemName : item },scope: scope.context));

        Map _getItemFromInternalList(final item) {
            //_logger.info("I--- ${item.runtimeType} N: ${itemName} #element: ${_items.length} ID: ${element.id}");

            final Map map = _items.firstWhere((final Map<String,dynamic> map) {
                return map.containsKey(itemName) && map[itemName] == item;
            });

            return map;
        }

        if(list is ObservableList) {
            //_logger.info("List ist Observable!");
            list.onChange.listen((final ListChangedEvent event) {
                _logger.fine("Changetype: ${event.changetype} ");

                switch(event.changetype) {
                    case ListChangeType.ADD:
                        add( { itemName : event.item },scope: scope.context);
                        break;

                    case ListChangeType.INSERT:
                        int index = 0;
                        if(event.prevItem != null) {
                            final Map prevItem = _getItemFromInternalList(event.prevItem);
                            index = _items.indexOf(prevItem);
                        }
                        insert(index, { itemName : event.item },scope: scope.context);

                        break;

                    case ListChangeType.CLEAR:
                        removeAll();
                        break;

                    case ListChangeType.UPDATE:

                        try {
                            final Map itemToRemove = _getItemFromInternalList(event.prevItem);
                            int index = _items.indexOf(itemToRemove);

                            remove(itemToRemove).then((_) {

                                if(index < _items.length) {
                                    insert(index, { itemName : event.item },scope: scope.context);
                                } else {
                                    add( { itemName : event.item },scope: scope.context);
                                }
                            });

                        } on StateError catch (e,stacktrace) {
                            _logger.shout("_getItemFromInternalList(${event.prevItem}) produced '$e'",stacktrace);
                        }

                        break;

                    case ListChangeType.REMOVE:
                            final Map itemToRemove = _getItemFromInternalList(event.item);
                            remove(itemToRemove);
                        break;
                }
            });
        } else {
            throw new ArgumentError("You are using mdl-repeat with ${list.runtimeType}. Please change your List to ObservableList<T>...!");
        }
    }

    /**
     * Used if child is a 'MdlDataConsumer' - e.g. MaterialDraggable
     *
     *      <div mdl-repeat="language in programming" class="mdl-dnd__drag-container">
     *          {{! ----- Turn off default mustache interpretation (sitegen) ---- }} {{= | | =}}
     *          <mdl-draggable template class="language" consumes="language" drop-zone="trash">
     *              {{language.name}}
     *          </mdl-draggable>
     *          |= {{ }} =| {{! ----- Turn on mustache ---- }}
     *      </div>
     *
     *      class MaterialDraggable extends MdlComponent implements MdlDataConsumer {
     *          ...
     *      }
     */
    void _addDataToDataConsumer(final dom.HtmlElement element,final item) {
        Validate.notNull(element);

        if(!element.attributes.containsKey(_constant.CONSUMES)) {
            return;
        }

        Validate.isTrue(item is Map,"Datatype for $item must be 'Map' but was '${item.runtimeType}'");

        final MdlComponent component = mdlComponent(element,null);
        if(component == null) {
            _logger.warning("Could not add data to data-consumer because it is not a MdlComponent. ($element)");
            return;
        }

        if(component is MdlDataConsumer) {
            final MdlDataConsumer consumer = component as MdlDataConsumer;
            final String consume = element.attributes[_constant.CONSUMES];

            if((item as Map).containsKey(consume)) {
                final data = (item as Map)[consume];
                consumer.consume(data);

            } else {
                _logger.warning("Could not find '$consume' in $item - so no data was added to $element");
            }
        } else {
            _logger.warning("$component is not a 'MdlDataConsumer' - so adding data was not possible.");
        }
    }

    //- Template -----------------------------------------------------------------------------------
    
    @override
    String get template => _template;
}

/// registration-Helper
void registerMaterialRepeat() {
    final MdlConfig config = new MdlConfig<MaterialRepeat>(
        _MaterialRepeatConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialRepeat.fromElement(element,injector)
    );
    
    // If you want <mdl-repeat></mdl-repeat> set selectorType to SelectorType.TAG.
    // If you want <div mdl-repeat></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdl-repeat"></div>)
    config.selectorType = SelectorType.ATTRIBUTE;

    componentFactory().register(config);
}

