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

/**
 * Private Component!
 * Necessary to change the parent-scope in [MaterialDialog#show]
 * Marked as MdlComponentModel to keep the name in Dart2JS
 *
 * The name is checked in [MaterialModel] (
 */
@MdlComponentModel
class MaterialDialogComponent extends MdlComponent implements ScopeAware, HasDynamicParentScope {
    final Logger _logger = new Logger('mdldialog._MaterialNotificationComponent');

    //static const _MaterialDialogComponentConstant _constant = const _MaterialDialogComponentConstant();
    static const _MaterialDialogComponentCssClasses _cssClasses = const _MaterialDialogComponentCssClasses();

    Scope _scope;

    MaterialDialogComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

        _scope = new Scope(this, mdlParentScope(this));
        _init();
        
    }
    
    static MaterialDialogComponent widget(final dom.HtmlElement element) => mdlComponent(element,MaterialDialogComponent) as MaterialDialogComponent;

    // - EventHandler -----------------------------------------------------------------------------


    Scope get scope => _scope;

    /// The only reason for this class - makes it possible to update the parent-scope
    /// when the Dialog pops up
    /// Usage:
    ///    MaterialDialog#show() {
    ///         ...
    ///         _renderer.render().then( (_) {
    ///             ...
    ///            final dom.HtmlElement dialog = _dialogContainer.children.last;
    ///            dialog.id = _elementID;
    ///
    ///            final MaterialDialogComponent dialogComponent = MaterialDialogComponent.widget(dialog);
    ///            Validate.notNull(dialogComponent,"${dialog} must be a 'MaterialDialogComponent' (mdl-dialog class)");
    ///
    ///            dialogComponent.parentScope = this;
    ///            ...
    ///            }
    ///    }
    @override
    void set parentScope(final Object dialog) {
        Validate.notNull(dialog);
        Validate.isTrue(dialog is MaterialDialog);
        _scope = new Scope(dialog,null);

        refreshComponentsInSubtree(element);
    }

    //- private -----------------------------------------------------------------------------------

    /// Nothing to do here - all the logic is in MaterialDialog and its children
    void _init() {
        _logger.fine("_MaterialDialogComponent - init");
    }
}

/// registration-Helper
/// Also private - _MaterialDialogComponent is only used internally by [MaterialDialog]
void _registerMaterialDialogComponent() {
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

