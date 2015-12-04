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

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialIncludeCssClasses {

    static const String MAIN_CLASS  = "mdl-js-include";

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialIncludeCssClasses();
}

/// creates MdlConfig for MaterialInclude
MdlConfig materialIncludeConfig() => new MdlWidgetConfig<MaterialInclude>(
    _MaterialIncludeCssClasses.MAIN_CLASS, (final dom.HtmlElement element,final di.Injector injector)
    => new MaterialInclude.fromElement(element,injector));

/// registration-Helper
void registerMaterialInclude() => componentFactory().register(materialIncludeConfig());

class MaterialContentEvent {

}

class MaterialInclude extends MdlComponent {
    final Logger _logger = new Logger('mdlapplication.MaterialInclude');

    //static const _MaterialIncludeConstant _constant = const _MaterialIncludeConstant();
    static const _MaterialIncludeCssClasses _cssClasses = const _MaterialIncludeCssClasses();

    /// renders a given String into HTML-Nodes
    final DomRenderer _renderer;

    /// Informs about the load-state
    final StreamController _controller = new StreamController<MaterialContentEvent>.broadcast();

    /// Everyone can listen to this {onLoadEnd} stream
    Stream<MaterialContentEvent> onLoadEnd;

    MaterialInclude.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : _renderer = injector.get(DomRenderer), super(element,injector) {

        onLoadEnd = _controller.stream;
        _init();
    }

    static MaterialInclude widget(final dom.HtmlElement element) => mdlComponent(element,MaterialInclude) as MaterialInclude;

    // Central Element - by default this is where mdl-js-include was found (element)
    // html.Element get hub => inputElement;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialInclude - init");

        if(!element.dataset.containsKey("url")) {
            _logger.shout("mdl-js-include needs a data-url attribute that defines the url to load");
            return;
        }

        final String url = element.dataset["url"];
        _logger.info("URL: ${url}");
        _load(url).then((final String content) {
            _renderer.render(element,content).then((_) {
                element.classes.add(_cssClasses.IS_UPGRADED);
                _controller.add(new MaterialContentEvent());
            });
        });

    }

    /// loads the given {url} and returns the content
    Future<String> _load(final String url) {
        final Completer completer = new Completer();
        final dom.HttpRequest request = new dom.HttpRequest();

        request.open("GET", url);
        request.onLoadEnd.listen( (final dom.ProgressEvent progressevent) {
            //_logger.info('Request complete ${request.responseText}, Status: ${request.readyState}');

            if (request.readyState == dom.HttpRequest.DONE) {

                final String content = _sanitizeResponseText(request.responseText);
                completer.complete(content);
            }
        });

        request.send();

        return completer.future;
    }
}

