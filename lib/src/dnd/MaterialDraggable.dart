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

/// Singleton - used by MaterialDraggable and MaterialDroppable
class DragInfo {
    static DragInfo _draginfo;

    var data;
    List<String> allowedDropZones = [];

    factory DragInfo () {
        if(_draginfo == null) {
            _draginfo = new DragInfo._internal();
        }
        return _draginfo;
    }

    DragInfo._internal();
}
 
/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialDraggableCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    final String DRAGGABLE      = 'mdl-draggable';

    final String DND_DRAGGABLE  = 'dnd-draggable';

    const _MaterialDraggableCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialDraggableConstant {

    static const String WIDGET_SELECTOR = "mdl-draggable";

    const _MaterialDraggableConstant();
}    

class MaterialDraggable extends MdlComponent implements MdlDataConsumer {
    final Logger _logger = new Logger('mdldnd.MaterialDraggable');

    static const _MaterialDraggableCssClasses _cssClasses = const _MaterialDraggableCssClasses();

    final DragInfo _dragInfo = new DragInfo();

    Draggable _draggable;

    var _consumedData;

    MaterialDraggable.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        
        _init();
        
    }
    
    static MaterialDraggable widget(final dom.HtmlElement element) => mdlComponent(element,MaterialDraggable) as MaterialDraggable;
    
    // Central Element - by default this is where mdldraggable can be found (element)
    // html.Element get hub => inputElement;

    get _isDisabled => ElementProperties.hasAttributeOrClass(element,[ 'disabled', 'is-disabled' ]);

    void consume(final data) {
        //_logger.info("Consumed: $data");
        _consumedData = data;
    }

    // --------------------------------------------------------------------------------------------
    // EventHandler

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("MaterialDraggable - init");

        element.classes.add(_cssClasses.DRAGGABLE);
        element.classes.add(_cssClasses.DND_DRAGGABLE);

        _draggable = new Draggable(element, avatarHandler: new AvatarHandler.clone());

        _draggable.onDragStart.listen(_onDragStart);
        _draggable.onDragEnd.listen(_onDragEnd);


        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    void _onDragStart(final DraggableEvent event) {
        _logger.info("_onDragStart ${event}");

        if (_isDisabled) {
            return;
        }

        List<String> _allowedDropZones() {
            if(element.attributes.containsKey("drop-zone")) {
                return element.attributes["drop-zone"].split(",");
            }
            return new List<String>();
        }

        _dragInfo.allowedDropZones = _allowedDropZones();
        _dragInfo.data = _consumedData;
    }

    void _onDragEnd(final DraggableEvent event) {
        _logger.info("_onDragEnd ${event}");
        _dragInfo.data = null;
    }
}

/// registration-Helper
void registerMaterialDraggable() {
    final MdlConfig config = new MdlWidgetConfig<MaterialDraggable>(
        _MaterialDraggableConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialDraggable.fromElement(element,injector)
    );
    
    // if you want <mdldraggable></mdldraggable> set isSelectorAClassName to false.
    // By default it's used as a class name. (<div class="mdldraggable"></div>)
    config.isSelectorAClassName = false;
    
    componentHandler().register(config);
}

