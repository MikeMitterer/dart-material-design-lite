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

    const _MaterialDropZoneConstant();
}    

class MaterialDropZone extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdldnd.MaterialDropZone');

    //static const _MaterialDropZoneConstant _constant = const _MaterialDropZoneConstant();
    static const _MaterialDropZoneCssClasses _cssClasses = const _MaterialDropZoneCssClasses();

    final DragInfo _dragInfo = new DragInfo();
    Dropzone _dropzone;

    Scope scope;

    MaterialDropZone.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

        scope = new Scope(this, mdlParentScope(this));

        _init();
        
    }
    
    static MaterialDropZone widget(final dom.HtmlElement element) => mdlComponent(element,MaterialDropZone) as MaterialDropZone;
    
    // Central Element - by default this is where mdl-dropzone can be found (element)
    // html.Element get hub => inputElement;

    Function onDropSuccessCallback;

    // --------------------------------------------------------------------------------------------
    // EventHandler

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialDropZone - init");

        element.classes.add(_cssClasses.DROPZONE);

        _dropzone = new Dropzone(element, overClass: _cssClasses.OVER ,acceptor: new _MdlAcceptor(_dragInfo,_getZoneNames));
        _dropzone.onDrop.listen(_onDrop);

        if(element.attributes.containsKey("on-drop-success")) {
            final String functionToCall = element.attributes["on-drop-success"];
            scope.context = scope.parentContext;

            onDropSuccessCallback = (final data) {
                final Invoke invoke = new Invoke(scope);
                final StringToFunction stf = new StringToFunction(functionToCall);

                _logger.info("Function: ${stf.functionAsString}");
                _logger.info("Params: ${stf.params}");

                invoke.function(stf,varsToReplace: { "data" : data });
            };
        }

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    void _onDrop(final DropzoneEvent event) {
        _logger.info("OnDrop!");
        element.classes.remove(_cssClasses.INVALID);

        if (onDropSuccessCallback != null) {
            _logger.info("Call callback");
            onDropSuccessCallback(_dragInfo.data);
        }
    }

    List<String> _getZoneNames() {
        if(element.attributes.containsKey("name")) {
            return element.attributes["name"].split(",");
        }
        return new List<String>();
    }
}

/**
 * WskAngularAcceptor that accepts [Draggable]s with a valid drop-zone set
 */
class _MdlAcceptor extends Acceptor {
    final _logger = new Logger('wsk_angular.wsk_dragdrop.WskAngularAcceptor');

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

        //if(!isValid) {
        //    dropzoneElement.classes.add("dnd-invalid");
        //} else {
        //    dropzoneElement.classes.remove("dnd-invalid");
        //}

        return isValid;
    }

    // -- private ---------------------------------------------------------------------------------

    bool _isDragZoneValid() {
        final List<String> _dropZoneNames = _getZoneNamesCallback();

        if (_dropZoneNames.isEmpty && _dragDropService.allowedDropZones.isEmpty) {
            _logger.info("DragZone is allowed because dropZoneNames and allowedDropZones are empty!");
            return true;
        }
        for (final String dropZone in _dragDropService.allowedDropZones) {
            if (_dropZoneNames.contains(dropZone)) {
                return true;
            }
        }
        _logger.info("DragZone is NOT allowed. $_dropZoneNames not found in allowedDropZones (${_dragDropService.allowedDropZones})");
        return false;
    }
}

/// registration-Helper
void registerMaterialDropZone() {
    final MdlConfig config = new MdlWidgetConfig<MaterialDropZone>(
        _MaterialDropZoneConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialDropZone.fromElement(element,injector)
    );
    
    // if you want <mdl-dropzone></mdl-dropzone> set isSelectorAClassName to false.
    // By default it's used as a class name. (<div class="mdl-dropzone"></div>)
    config.isSelectorAClassName = false;
    
    componentHandler().register(config);
}

