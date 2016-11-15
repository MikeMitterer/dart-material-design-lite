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

part of mdlcomponents;

class MaterialTabsChangedEvent {
    final String targetID;
    MaterialTabsChangedEvent(this.targetID);
}

/// Controller-View for mdl-tabs
///
///     <div class="mdl-tabs mdl-tabs mdl-ripple-effect">
///       <div class="mdl-tabs__tab-bar">
///           <a href="#panel1" class="mdl-tabs__tab is-active">Tab I</a>
///           <a href="#panel2" class="mdl-tabs__tab">Tab II</a>
///       </div>
///
///       <div class="mdl-tabs__panel is-active" id="panel1">
///         <ul>
///           <li>Arya</li>
///           <li>Rickon</li>
///         </ul>
///       </div>
///       <div class="mdl-tabs__panel" id="panel2">
///         <ul>
///           <li>Jamie</li>
///           <li>Tyrion</li>
///         </ul>
///       </div>
///     </div>
///
class MaterialTabs extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialTabs');

    static const _MaterialTabsConstant _constant = const _MaterialTabsConstant();
    static const _MaterialTabsCssClasses _cssClasses = const _MaterialTabsCssClasses();

    final List<dom.Element> _tabs = new List<dom.Element>();
    final List<dom.Element> _panels = new List<dom.Element>();

    StreamController<MaterialTabsChangedEvent> _onChange;

    MaterialTabs.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        _init();
    }

    static MaterialTabs widget(final dom.HtmlElement element) => mdlComponent(element,MaterialTabs) as MaterialTabs;

    /// [onChanged] informs the application about the the change of the active tab
    Stream<MaterialTabsChangedEvent> get onChange {
        _onChange ??= new StreamController<MaterialTabsChangedEvent>.broadcast(onCancel: () => _onChange = null);
        return _onChange.stream;
    }

    /// Returns the active tabs "href" (without #)
    ///
    /// If there is no active tab it returns an empty string
    String get activePanel {
        for(int index = 0;index < _tabs.length;index++) {
            if(_tabs[index].classes.contains(_cssClasses.ACTIVE_CLASS)) {
                final String attribHref = _tabs[index].attributes["href"];
                final String href = attribHref.split('#')[1];
                return href;
            }
        }
        return "";
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialTabs - init");

        if (element != null) {
            _initTabs();
        }
    }

    /// Handle clicks to a tabs component
    void _initTabs() {

        if (element.classes.contains(_cssClasses.MDL_JS_RIPPLE_EFFECT)) {
            element.classes.add(_cssClasses.MDL_JS_RIPPLE_EFFECT_IGNORE_EVENTS);
        }

        // Select element tabs, document panels
        _tabs.addAll(element.querySelectorAll('.' + _cssClasses.TAB_CLASS));
        _panels.addAll(element.querySelectorAll('.' + _cssClasses.PANEL_CLASS));

        // Create new tabs for each tab element
        for (int i = 0; i < _tabs.length; i++) {
            new _MaterialTab(_tabs[i], this);
        }

        element.classes.add(_cssClasses.UPGRADED_CLASS);
    }

    /// Reset tab state, dropping active classes
    void _resetTabState() {

        for (int k = 0; k < _tabs.length; k++) {
            _tabs[k].classes.remove(_cssClasses.ACTIVE_CLASS);
        }
    }

    /// Reset panel state, dropping active classes
    void _resetPanelState() {

        for (int j = 0; j < _panels.length; j++) {
            _panels[j].classes.remove(_cssClasses.ACTIVE_CLASS);
        }
    }

    void _fire(final MaterialTabsChangedEvent event) {
        if(_onChange != null && _onChange.hasListener) {
            _onChange.add(event);
        }
    }
}

class _MaterialTab {
    final dom.Element tab;
    final MaterialTabs ctx;

    static const _MaterialTabsCssClasses _cssClasses = const _MaterialTabsCssClasses();

    _MaterialTab(this.tab,this.ctx) {

        if (tab != null) {
            if (ctx.element.classes.contains(_cssClasses.MDL_JS_RIPPLE_EFFECT)) {

                final dom.SpanElement rippleContainer = new dom.SpanElement();
                rippleContainer.classes.add(_cssClasses.MDL_RIPPLE_CONTAINER);
                rippleContainer.classes.add(_cssClasses.MDL_JS_RIPPLE_EFFECT);

                final dom.SpanElement ripple = new dom.SpanElement();
                ripple.classes.add(_cssClasses.MDL_RIPPLE);
                rippleContainer.append(ripple);
                tab.append(rippleContainer);
            }

            ctx.eventStreams.add( tab.onClick.listen( (final dom.Event event) {
                final String attribHref = tab.attributes["href"];
                if(attribHref.startsWith("#")) {
                    event.preventDefault();
                    event.stopPropagation();

                    final String href = attribHref.split('#')[1];
                    final dom.HtmlElement panel = ctx.element.querySelector('#' + href);

                    ctx._resetTabState();
                    ctx._resetPanelState();
                    tab.classes.add(_cssClasses.ACTIVE_CLASS);
                    panel.classes.add(_cssClasses.ACTIVE_CLASS);

                    ctx._fire(new MaterialTabsChangedEvent(href));
                }
            }));
        }
    }
}

/// creates MdlConfig for MaterialTabs
MdlConfig materialTabsConfig() => new MdlWidgetConfig<MaterialTabs>(
    _MaterialTabsCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
=> new MaterialTabs.fromElement(element,injector));

/// registration-Helper
void registerMaterialTabs() => componentHandler().register(materialTabsConfig());

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialTabsCssClasses {

    static const String MAIN_CLASS  = "mdl-tabs";

    final String TAB_CLASS = 'mdl-tabs__tab';
    final String PANEL_CLASS = 'mdl-tabs__panel';
    final String ACTIVE_CLASS = 'is-active';
    final String UPGRADED_CLASS = 'is-upgraded';

    final String MDL_JS_RIPPLE_EFFECT = 'mdl-ripple-effect';
    final String MDL_RIPPLE_CONTAINER = 'mdl-tabs__ripple-container';
    final String MDL_RIPPLE = 'mdl-ripple';
    final String MDL_JS_RIPPLE_EFFECT_IGNORE_EVENTS = 'mdl-ripple-effect--ignore-events';
    const _MaterialTabsCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialTabsConstant {
    const _MaterialTabsConstant();
}