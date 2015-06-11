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

part of todo;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _ToDoItemComponentCssClasses {

    static const String MAIN_CLASS  = "todo-items";

    final String IS_UPGRADED = 'is-upgraded';

    const _ToDoItemComponentCssClasses();
}

/// registration-Helper
void registerToDoItemComponent() => componentFactory().register(new MdlWidgetConfig<ToDoItemComponent>(
    _ToDoItemComponentCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
        => new ToDoItemComponent.fromElement(element,injector)));

@MdlComponentModel
class ToDoItem {
    final Logger _logger = new Logger('todo.ToDoItem');

    static int counter = 0;
    int id;

    bool checked;
    final String item;

    ToDoItem(this.checked, this.item) : id = counter { counter++; }
}

class ModelChangedEvent {
    final ToDoItem item;
    ModelChangedEvent(this.item);
}

@MdlComponentModel
class ToDoItemComponent extends MdlTemplateComponent {
    final Logger _logger = new Logger('todo.ToDoItemComponent');

    //static const _ToDoItemConstant _constant = const _ToDoItemConstant();
    static const _ToDoItemComponentCssClasses _cssClasses = const _ToDoItemComponentCssClasses();

    final List<ToDoItem> _items = new List<ToDoItem>();

    final StreamController _controller = new StreamController<ModelChangedEvent>.broadcast();
    Stream<ModelChangedEvent> onModelChange;

    final TemplateRenderer _templateRenderer;
    final ListRenderer _listRenderer;

    ToDoItemComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector),
            _templateRenderer = injector.get(TemplateRenderer), _listRenderer = injector.get(ListRenderer) {

        onModelChange = _controller.stream;

        _listRenderer.listTag = "<div>";
        _listRenderer.itemTag = "";

        _init();
    }

    static ToDoItemComponent widget(final dom.HtmlElement element) => mdlComponent(element) as ToDoItemComponent;

    bool useRenderListFunction = true;

    @override
    String get template {
        if(useRenderListFunction) {
            return _template_for_render_list;
        }
        return _template_for_mustache_list;
    }

    String _template_for_mustache_list = """
        <div>
            <ul>
                {{#items}}
                    <li>
                        <div class="row">
                            <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="check{{id}}">
                                {{#checked}}
                                    <input type="checkbox" id="check{{id}}" class="mdl-checkbox__input" checked data-mdl-click="check({{id}})"/>
                                {{/checked}}
                                {{^checked}}
                                    <input type="checkbox" id="check{{id}}" class="mdl-checkbox__input" data-mdl-click="check({{id}})"/>
                                {{/checked}}
                                <span class="mdl-checkbox__label">{{item}}</span>
                            </label>
                            <button class="mdl-button mdl-js-button mdl-button--colored mdl-js-ripple-effect"
                                data-mdl-click="remove({{id}})">
                                Remove
                            </button>
                        </div>
                    </li>
                {{/items}}
            </ul>
        </div>
        """.trim().replaceAll(new RegExp(r"\s+")," ");

    String _template_for_render_list = """
            <div class="row">
                <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="check{{id}}">
                    {{#checked}}
                        <input type="checkbox" id="check{{id}}" class="mdl-checkbox__input" checked data-mdl-click="check({{id}})"/>
                    {{/checked}}
                    {{^checked}}
                        <input type="checkbox" id="check{{id}}" class="mdl-checkbox__input" data-mdl-click="check({{id}})"/>
                    {{/checked}}
                    <span class="mdl-checkbox__label">{{item}}</span>
                </label>
                <button class="mdl-button mdl-js-button mdl-button--colored mdl-js-ripple-effect"
                    data-mdl-click="remove({{id}})">
                    Remove
                </button>
            </div>
        """.trim().replaceAll(new RegExp(r"\s+")," ");

    List<ToDoItem> get items => _items;

    void addItem(final ToDoItem value) {
        _items.add(value);
        _render();
        _controller.add(new ModelChangedEvent(value));
    }

    void remove(final String id) {
        _logger.info("Click $id");
        final ToDoItem item = _getItem(id);
        _items.remove(item);
        _render();
        _controller.add(new ModelChangedEvent(item));

    }

    void check(final String id) {
        _logger.info("Check $id");

        final MaterialCheckbox checkbox = MaterialCheckbox.widget(element.querySelector("#check${id.trim()}"));
        final ToDoItem item = _getItem(id);
        item.checked = checkbox.checked;
        _controller.add(new ModelChangedEvent(item));
    }

    int get incrementalIndex => items.isNotEmpty ? ToDoItem.counter : -1;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("ToDoItem - init");
        element.classes.add(_cssClasses.IS_UPGRADED);

        _items.add(new ToDoItem(false,"Mike (Cnt 0)"));
        _items.add(new ToDoItem(true,"Gerda (Cnt 1)"));
        _items.add(new ToDoItem(false,"Sarah (Cnt 2)"));

        for(int counter = 3;counter < 1000;counter++) {
           _items.add(new ToDoItem(false,"Cnt $counter"));
        }

        if(useRenderListFunction) {
            renderer = _listRenderer(element,this,_items,() => template);
        } else {
            renderer = _templateRenderer(element,this,() => template);
        }

        _render();
        _logger.info("ToDoItem - init done!");

    }

    ToDoItem _getItem(final String id) {
        for(int counter = 0;counter < _items.length;counter++) {
            if(_items[counter].id == int.parse(id)) {
                return _items[counter];
            }
        }
        return null;
    }

    Future _render() async {
        Stopwatch stopwatch = new Stopwatch()..start();

        render().then((_) {
            stopwatch.stop();

            String message;
            if(useRenderListFunction) {
                message = "Data rendered with ListRenderer (${_items.length}), took ${stopwatch.elapsedMilliseconds}ms";
            } else {
                message = "Data rendered with TemplateRenderer (${_items.length}), took ${stopwatch.elapsedMilliseconds}ms";
            }

            _logger.info(message);
        });

    }
}

