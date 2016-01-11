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

part of mdlapplication;

typedef _EventHandler(final dom.Element element,invoke(final dom.Event event));

/**
 * Connects data-mdl-[event] attributes with object-functions
 *
 * Needed in mdltemplatecomponents!
 */
@di.Injectable()
class EventCompiler {
    final Logger _logger = new Logger('mdlapplication.EventCompiler');

    static final Map<String,_EventHandler> datasets = {
        'mdl-abort':            _onAbort,
        'mdl-beforecopy':       _onBeforeCopy,
        'mdl-beforecut':        _onBeforeCut,
        'mdl-beforepaste':      _onBeforePaste,
        'mdl-blur':             _onBlur,
        'mdl-change':           _onChange,
        'mdl-click':            _onClick,
        'mdl-contextmenu':      _onContextMenu,
        'mdl-copy':             _onCopy,
        'mdl-cut':              _onCut,
        'mdl-doubleclick':      _onDoubleClick,
        'mdl-drag':             _onDrag,
        'mdl-dragend':          _onDragEnd,
        'mdl-dragenter':        _onDragEnter,
        'mdl-dragleave':        _onDragLeave,
        'mdl-dragover':         _onDragOver,
        'mdl-dragstart':        _onDragStart,
        'mdl-drop':             _onDrop,
        'mdl-error':            _onError,
        'mdl-focus':            _onFocus,
        'mdl-fullscreenchange': _onFullscreenChange,
        'mdl-fullscreenerror':  _onFullscreenError,
        'mdl-input':            _onInput,
        'mdl-invalid':          _onInvalid,
        'mdl-keydown':          _onKeyDown,
        'mdl-keypress':         _onKeyPress,
        'mdl-keyup':            _onKeyUp,
        'mdl-load':             _onLoad,
        'mdl-mousedown':        _onMouseDown,
        'mdl-mouseenter':       _onMouseEnter,
        'mdl-mouseleave':       _onMouseLeave,
        'mdl-mousemove':        _onMouseMove,
        'mdl-mouseout':         _onMouseOut,
        'mdl-mouseover':        _onMouseOver,
        'mdl-mouseup':          _onMouseUp,
        'mdl-mousewheel':       _onMouseWheel,
        'mdl-paste':            _onPaste,
        'mdl-reset':            _onReset,
        'mdl-scroll':           _onScroll,
        'mdl-search':           _onSearch,
        'mdl-select':           _onSelect,
        'mdl-selectstart':      _onSelectStart,
        'mdl-submit':           _onSubmit,
        'mdl-touchcancel':      _onTouchCancel,
        'mdl-touchend':         _onTouchEnd,
        'mdl-touchenter':       _onTouchEnter,
        'mdl-touchleave':       _onTouchLeave,
        'mdl-touchmove':        _onTouchMove,
        'mdl-touchstart':       _onTouchStart,
        'mdl-transitionend':    _onTransitionEnd
    };

    EventCompiler();

    /**
     * {scope} represents an object/class where the functions are located,
     * {element} has children with data-mdl-[eventname] attributes.
     * Sample:
     *      <tag ... data-mdl-click="check({{id}})"></tag>
     *
     *      <tag ... data-mdl-keyup="handleKeyUp(\$event)"></tag>
     *      <tag ... data-mdl-keyup="handleKeyUp()"></tag>
     *
     * compileElement connects these definitions
     */
    Future compileElement(final Object scope,final dom.Element element) async {

        final InstanceMirror myClassInstanceMirror = mdltemplate.reflect(scope);

        datasets.keys.forEach((final String dataset) {

            // Create new List because querySelectorAll returns a ImmutableList!
            final List<dom.Element> elements = new List.from(element.querySelectorAll("[data-${dataset}]"));

            // If the current element has this attribute add it to the list
            if(element.attributes.containsKey("data-${dataset}")) {
                elements.add(element);
            }

            if(elements.isNotEmpty) {
                _logger.fine("Searching for '[data-${dataset}] in $element, found ${elements.length} subelements.");
            }

            elements.forEach( (final dom.Element element) {
                //_logger.info("$dataset for $element");

                // finds function name and params
                final Match match = new RegExp(r"([^(]*)\(([^)]*)\)").firstMatch(element.dataset[dataset]);

                // from the above sample this would be: check
                String getFunctionName() => match.group(1);

                List getParams() {
                    final List params = new List();

                    // first group is function name, second - params
                    if(match.groupCount == 2) {
                        final List<String> matches = match.group(2).split(",");
                        if(matches.isNotEmpty && matches[0].isNotEmpty) {
                            params.addAll(matches);
                        }
                    }
                    return params;
                }

                datasets[dataset](element,(final dom.Event event) {
                    //_logger.info("Compiled ${datasets[dataset]} for $element...");
                    _invokeFunction(myClassInstanceMirror,getFunctionName(),getParams(),event);
                });
            });

        });
        _logger.fine("Events compiled...");
    }

    //- private -----------------------------------------------------------------------------------

    bool _hasEvent(final List params) => (params != null && params.contains("\$event") ? true : false);
    bool _hasNoEvent(final List params) => !_hasEvent(params);

    /// Replaces $event with {event}
    List _replaceEventInParams(final List params,final dom.Event event) {
        if(_hasEvent(params)) {
            final int index = params.indexOf("\$event");
            params.replaceRange(index,index + 1, [ event ] );
        }
        return params;
    }

    /// Calls the defined function. If there is a $event param defined for the function it will be replace
    /// with {event}. If no $event param is defined then preventDefault and stopPropagation is called on this {event}
    void _invokeFunction(final InstanceMirror myClassInstanceMirror,final String functionName, final List params, final dom.Event event) {
        if(_hasNoEvent(params)) {
            //event.preventDefault();
            //event.stopPropagation();
        }
        myClassInstanceMirror.invoke(functionName, _replaceEventInParams(params,event));
    }

    //- events ------------------------------------------------------------------------------------

    static final _EventHandler _onAbort = (final dom.Element element, invoke(final dom.Event event)) {
        element.onAbort.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onBeforeCopy = (final dom.Element element, invoke(final dom.Event event)) {
        element.onBeforeCopy.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onBeforeCut = (final dom.Element element, invoke(final dom.Event event)) {
        element.onBeforeCut.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onBeforePaste = (final dom.Element element, invoke(final dom.Event event)) {
        element.onBeforePaste.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onBlur = (final dom.Element element, invoke(final dom.Event event)) {
        element.onBlur.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onChange = (final dom.Element element, invoke(final dom.Event event)) {
        element.onChange.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onClick = (final dom.Element element, invoke(final dom.Event event)) {
        element.onClick.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onContextMenu = (final dom.Element element, invoke(final dom.Event event)) {
        element.onContextMenu.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onCopy = (final dom.Element element, invoke(final dom.Event event)) {
        element.onCopy.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onCut = (final dom.Element element, invoke(final dom.Event event)) {
        element.onCut.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onDoubleClick = (final dom.Element element, invoke(final dom.Event event)) {
        element.onDoubleClick.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onDrag = (final dom.Element element, invoke(final dom.Event event)) {
        element.onDrag.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onDragEnd = (final dom.Element element, invoke(final dom.Event event)) {
        element.onDragEnd.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onDragEnter = (final dom.Element element, invoke(final dom.Event event)) {
        element.onDragEnter.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onDragLeave = (final dom.Element element, invoke(final dom.Event event)) {
        element.onDragLeave.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onDragOver = (final dom.Element element, invoke(final dom.Event event)) {
        element.onDragOver.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onDragStart = (final dom.Element element, invoke(final dom.Event event)) {
        element.onDragStart.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onDrop = (final dom.Element element, invoke(final dom.Event event)) {
        element.onDrop.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onError = (final dom.Element element, invoke(final dom.Event event)) {
        element.onError.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onFocus = (final dom.Element element, invoke(final dom.Event event)) {
        element.onFocus.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onFullscreenChange = (final dom.Element element, invoke(final dom.Event event)) {
        element.onFullscreenChange.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onFullscreenError = (final dom.Element element, invoke(final dom.Event event)) {
        element.onFullscreenError.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onInput = (final dom.Element element, invoke(final dom.Event event)) {
        element.onInput.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onInvalid = (final dom.Element element, invoke(final dom.Event event)) {
        element.onInvalid.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onKeyDown = (final dom.Element element, invoke(final dom.Event event)) {
        element.onKeyDown.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onKeyPress = (final dom.Element element, invoke(final dom.Event event)) {
        element.onKeyPress.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onKeyUp = (final dom.Element element, invoke(final dom.Event event)) {
        element.onKeyUp.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onLoad = (final dom.Element element, invoke(final dom.Event event)) {
        element.onLoad.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onMouseDown = (final dom.Element element, invoke(final dom.Event event)) {
        element.onMouseDown.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onMouseEnter = (final dom.Element element, invoke(final dom.Event event)) {
        element.onMouseEnter.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onMouseLeave = (final dom.Element element, invoke(final dom.Event event)) {
        element.onMouseLeave.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onMouseMove = (final dom.Element element, invoke(final dom.Event event)) {
        element.onMouseMove.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onMouseOut = (final dom.Element element, invoke(final dom.Event event)) {
        element.onMouseOut.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onMouseOver = (final dom.Element element, invoke(final dom.Event event)) {
        element.onMouseOver.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onMouseUp = (final dom.Element element, invoke(final dom.Event event)) {
        element.onMouseUp.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onMouseWheel = (final dom.Element element, invoke(final dom.Event event)) {
        element.onMouseWheel.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onPaste = (final dom.Element element, invoke(final dom.Event event)) {
        element.onPaste.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onReset = (final dom.Element element, invoke(final dom.Event event)) {
        element.onReset.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onScroll = (final dom.Element element, invoke(final dom.Event event)) {
        element.onScroll.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onSearch = (final dom.Element element, invoke(final dom.Event event)) {
        element.onSearch.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onSelect = (final dom.Element element, invoke(final dom.Event event)) {
        element.onSelect.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onSelectStart = (final dom.Element element, invoke(final dom.Event event)) {
        element.onSelectStart.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onSubmit = (final dom.Element element, invoke(final dom.Event event)) {
        element.onSubmit.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onTouchCancel = (final dom.Element element, invoke(final dom.Event event)) {
        element.onTouchCancel.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onTouchEnd = (final dom.Element element, invoke(final dom.Event event)) {
        element.onTouchEnd.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onTouchEnter = (final dom.Element element, invoke(final dom.Event event)) {
        element.onTouchEnter.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onTouchLeave = (final dom.Element element, invoke(final dom.Event event)) {
        element.onTouchLeave.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onTouchMove = (final dom.Element element, invoke(final dom.Event event)) {
        element.onTouchMove.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onTouchStart = (final dom.Element element, invoke(final dom.Event event)) {
        element.onTouchStart.listen((final dom.Event event) => invoke(event));
    };

    static final _EventHandler _onTransitionEnd = (final dom.Element element, invoke(final dom.Event event)) {
        element.onTransitionEnd.listen((final dom.Event event) => invoke(event));
    };
}

/// Same as {EventCompiler} but uses MdlComponent as basis.
/// {MdlComponent} already brings it's dom.Element
class MdlEventCompiler extends EventCompiler {
    final Logger _logger = new Logger('mdltemplatecomponents.MdlEventCompiler');

    Future compile(final MdlComponent component) async {
        final dom.Element element = component.element;
        compileElement(component,element);
    }

}