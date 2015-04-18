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
part of mdlremote;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialIncludeCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialIncludeCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialIncludeConstant {
    const _MaterialIncludeConstant();
}

/// registration-Helper
void registerMaterialInclude() => componenthandler.register(new MdlWidgetConfig<MaterialInclude>(
    "mdl-js-include", (final html.HtmlElement element) => new MaterialInclude.fromElement(element)));

class MaterialContentEvent {

}

class MaterialInclude extends MdlComponent {
    final Logger _logger = new Logger('mdlcomponents.MaterialInclude');

    //static const _MaterialIncludeConstant _constant = const _MaterialIncludeConstant();
    static const _MaterialIncludeCssClasses _cssClasses = const _MaterialIncludeCssClasses();

    /// renders a given String into HTML-Nodes
    final Renderer _renderer = new Renderer();

    /// Informs about the load-state
    final StreamController _controller = new StreamController<MaterialContentEvent>.broadcast();

    /// Everyone can listen to this {onLoadEnd} stream
    Stream<MaterialContentEvent> onLoadEnd;

    MaterialInclude.fromElement(final html.HtmlElement element) : super(element) {
        onLoadEnd = _controller.stream;

        _init();
    }

    static MaterialInclude widget(final html.HtmlElement element) => mdlComponent(element) as MaterialInclude;

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
        final html.HttpRequest request = new html.HttpRequest();

        request.open("GET", url);
        request.onLoadEnd.listen( (final html.ProgressEvent progressevent) {
            //_logger.info('Request complete ${request.responseText}, Status: ${request.readyState}');

            if (request.readyState == html.HttpRequest.DONE) {

                final String content = _sanitizeResponseText(request.responseText);
                completer.complete(content);
            }
        });

        request.send();

        return completer.future;
    }
}

