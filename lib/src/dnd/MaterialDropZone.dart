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
part of mdldnd;
 
/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialDropZoneCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    final String DROPZONE       = 'mdl-dropzone';

    final String INVALID        = 'dnd-invalid';
    final String OVER           = 'dnd-over';


    const _MaterialDropZoneCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialDropZoneConstant {

    static const String WIDGET_SELECTOR = "mdl-dropzone";

    final String ZONE_NAME          = "name";

    final String ON_DROP_SUCCESS    = "on-drop-success";

    const _MaterialDropZoneConstant();
}    

class MaterialDropZone extends MdlComponent {
    final Logger _logger = new Logger('mdldnd.MaterialDropZone');

    static const _MaterialDropZoneConstant _constant = const _MaterialDropZoneConstant();
    static const _MaterialDropZoneCssClasses _cssClasses = const _MaterialDropZoneCssClasses();

    final DragInfo _dragInfo = new DragInfo();
    Dropzone _dropzone;

    Scope scope;

    MaterialDropZone.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
    }
    
    static MaterialDropZone widget(final dom.HtmlElement element) => mdlComponent(element,MaterialDropZone) as MaterialDropZone;

    @override
    void attached() {
        scope = new Scope(this,mdlParentScope(this));
        _init();
    }

    Function onDropSuccessCallback;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.finer("MaterialDropZone - init");

        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialDropZoneConstant.WIDGET_SELECTOR);

        element.classes.add(_cssClasses.DROPZONE);

        _dropzone = new Dropzone(element, overClass: _cssClasses.OVER ,acceptor: new _MdlAcceptor(_dragInfo,_getZoneNames));
        _dropzone.onDrop.listen(_onDrop);
        _dropzone.onDragOver.listen(_onDragOver);

        if(element.attributes.containsKey(_constant.ON_DROP_SUCCESS)) {
            final String functionToCall = element.attributes[_constant.ON_DROP_SUCCESS];
            scope.context = scope.parentContext;

            onDropSuccessCallback = (final data) {
                final Invoke invoke = new Invoke(scope);
                final StringToFunction stf = new StringToFunction(functionToCall);

                invoke.function(stf,varsToReplace: { "data" : data });
            };
        }

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    void _onDrop(final DropzoneEvent event) {
        _logger.fine("OnDrop!");
        element.classes.remove(_cssClasses.INVALID);

        if (onDropSuccessCallback != null) {
            _logger.fine("Call callback");
            onDropSuccessCallback(_dragInfo.data);
        }
    }

    void _onDragOver(_) {
        element.classes.add(_cssClasses.OVER);
    }

    List<String> _getZoneNames() {
        if(element.attributes.containsKey(_constant.ZONE_NAME)) {
            return element.attributes[_constant.ZONE_NAME].split(",");
        }
        return new List<String>();
    }
}

/**
 * WskAngularAcceptor that accepts [Draggable]s with a valid drop-zone set
 */
class _MdlAcceptor extends Acceptor {
    final _logger = new Logger('mdldnd._MdlAcceptor');

    final DragInfo _dragDropService;
    final _getZoneNamesCallback;

    _MdlAcceptor(this._dragDropService,void getZoneNames())
        : _getZoneNamesCallback = getZoneNames {

        Validate.notNull(_dragDropService);
        Validate.notNull(getZoneNames);
    }

    @override
    bool accepts(final dom.Element draggableElement,final int draggableId,final dom.Element dropzoneElement) {
        final bool isValid = _isDragZoneValid();

        return isValid;
    }

    // -- private ---------------------------------------------------------------------------------

    bool _isDragZoneValid() {
        final List<String> _dropZoneNames = _getZoneNamesCallback();

        if (_dropZoneNames.isEmpty && _dragDropService.allowedDropZones.isEmpty) {
            _logger.fine("DragZone is allowed because dropZoneNames and allowedDropZones are empty!");
            return true;
        }
        for (final String dropZone in _dragDropService.allowedDropZones) {
            if (_dropZoneNames.contains(dropZone)) {
                return true;
            }
        }
        _logger.fine("DropZone $_dropZoneNames not found in allowedDropZones (${_dragDropService.allowedDropZones})");
        return false;
    }
}

/// registration-Helper
void registerMaterialDropZone() {
    final MdlConfig config = new MdlConfig<MaterialDropZone>(
        _MaterialDropZoneConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialDropZone.fromElement(element,injector)
    );
    
    config.selectorType = SelectorType.TAG;
    componentHandler().register(config);
}

