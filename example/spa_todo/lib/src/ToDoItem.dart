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

@MdlComponentModel
class ToDoItem {
    final Logger _logger = new Logger('todo.ToDoItem');

    static int counter = 0;
    int id;

    bool checked;
    final String name;

    ToDoItem(this.checked, this.name) : id = counter { counter++; }
}

class ModelChangedEvent {
    final ToDoItem item;
    ModelChangedEvent(this.item);
}

@MdlComponentModel
class ToDoItemComponent extends MdlTemplateComponent implements ScopeAware {
    final Logger _logger = new Logger('todo.ToDoItemComponent');

    static const _ToDoItemComponentCssClasses _cssClasses = const _ToDoItemComponentCssClasses();

    final ObservableList<ToDoItem> items = new ObservableList<ToDoItem>();

    ToDoItemComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

        _init();
    }

    static ToDoItemComponent widget(final dom.HtmlElement element) => mdlComponent(element,ToDoItemComponent) as ToDoItemComponent;


    void addItem(final ToDoItem value) {
        items.add(value);
    }

    void addItemOnTop(final ToDoItem item) {
        items.insert(0,item);
    }

    void remove(final String id) {
        _logger.info("Remove $id");
        final ToDoItem item = _getItem(id);
        items.remove(item);

    }

    void check(final String id) {
        _logger.info("Check $id");

        final MaterialCheckbox checkbox = MaterialCheckbox.widget(element.querySelector("#check${id.trim()}"));
        final ToDoItem item = _getItem(id);
        item.checked = checkbox.checked;
    }

    int get incrementalIndex => ToDoItem.counter;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("ToDoItem - init");

        // items.add(new ToDoItem(false,"Mike (Cnt 0)"));
        // items.add(new ToDoItem(true,"Gerda (Cnt 1)"));
        // items.add(new ToDoItem(false,"Sarah (Cnt 2)"));
        //
        // for(int counter = 3;counter < 1000;counter++) {
        //    items.add(new ToDoItem(false,"Cnt $counter"));
        // }

        _render();

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    ToDoItem _getItem(final String id) {
        for(int counter = 0;counter < items.length;counter++) {
            if(items[counter].id == int.parse(id)) {
                return items[counter];
            }
        }
        return null;
    }

    Future _render() async {
        Stopwatch stopwatch = new Stopwatch()..start();

        render().then((_) {
            stopwatch.stop();

            final String message = "Data rendered with TemplateRenderer (${items.length}), "
                "took ${stopwatch.elapsedMilliseconds}ms";

            _logger.info(message);
        });

    }

    //- Template -----------------------------------------------------------------------------------

    @override
    String template = """
        <div mdl-repeat="item in items">
            {{! ----- Turn off default mustache interpretation ---- }} {{= | | =}}
            <template>
                <div class="row">
                    <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="check{{item.id}}">
                        {{#item.checked}}
                            <input type="checkbox" id="check{{item.id}}" class="mdl-checkbox__input" checked data-mdl-click="check({{item.id}})"/>
                        {{/item.checked}}
                        {{^item.checked}}
                            <input type="checkbox" id="check{{item.id}}" class="mdl-checkbox__input" data-mdl-click="check({{item.id}})"/>
                        {{/item.checked}}
                        <span class="mdl-checkbox__label">{{item.name}}</span>
                    </label>
                    <button class="mdl-button mdl-js-button mdl-button--colored mdl-js-ripple-effect"
                        data-mdl-click="remove({{item.id}})">
                        Remove
                    </button>
                </div>
            </template>
            |= {{ }} =| {{! ----- Turn on mustache ---- }}
        </div>
        """.trim().replaceAll(new RegExp(r"\s+")," ");
}

/// registration-Helper
void registerToDoItemComponent() {
    final MdlConfig config = new MdlWidgetConfig<ToDoItemComponent>(
        _ToDoItemComponentCssClasses.MAIN_CLASS,
            (final dom.HtmlElement element, final di.Injector injector) => new ToDoItemComponent.fromElement(element, injector));

    config.selectorType = SelectorType.CLASS;

    componentHandler().register(config);
}
