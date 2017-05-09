@TestOn("content-shell")
library test.unit.core.mdlcomponent;

import 'dart:async';
import 'dart:html' as dom;
import 'package:test/test.dart';
import 'package:dice/dice.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlmock.dart' as mdlmock;

//import 'package:logging/logging.dart';

import '../config.dart';

part '_lib/SlowComponent.dart';

main() async {
    //final Logger _logger = new Logger("test.MdlComponent");
    
    configLogging();

    final DomRenderer renderer = new DomRenderer();
    final dom.DivElement parent = new dom.DivElement();

    final String html = '''
        <div class="mdl-panel">
            <button id="first" class="mdl-button mdl-ripple-effect">First button</button>            
            <button id="second" class="mdl-button mdl-ripple-effect">Second button</button>
            <canvas width="100" height="100">Loading</canvas>            
            <slow-component></slow-component>
        </div>    
    '''.trim().replaceAll(new RegExp(r"\s+")," ");

    group('MdlComponent', () {
        setUp(() async {
            mdlmock.setUpInjector();

            mdlmock.mockComponentHandler(mdlmock.injector(), mdlmock.componentFactory());
            await prepareMdlTest( () async {
                await registerMaterialButton();
                await registerSlowComponent();
                await registerMdlTemplateComponents();
            });
        });

        test('> Registration', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final MaterialButton button = MaterialButton.widget(element.querySelector("#second"));

            expect(button,isNotNull);

        }); // end of 'Registration' test

        test('> SlowComponent', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final SlowComponent component = SlowComponent.widget(element.querySelector("slow-component"));

            // It takes a while until DOM is rendered for SlowComponent
            // (requestAnimationFrame is used for rendering)
            expect(component.element.innerHtml,isEmpty);

            // wait for 500ms to give requestAnimationFrame a chance to do its work
            // insertElement + removes mdl-content__loading flag from element
            new Future.delayed(new Duration(milliseconds: 500), expectAsync0( () {
                final SlowComponent component = SlowComponent.widget(element.querySelector("slow-component"));
                //_logger.info(component.element.innerHtml);
                expect(component,isNotNull);
            }));

        }); // end of 'SlowComponent' test

        test('> waitForChild', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final SlowComponent component = SlowComponent.widget(element.querySelector("slow-component"));

            // It takes a while until DOM is ready for SlowComponent (~400ms)
            // (requestAnimationFrame is used for rendering)
            expect(component.element.innerHtml,isEmpty);

            // mdl-button is a child within <slow-component>
            final dom.ButtonElement buttonInTemplate = await component.waitForChild(".mdl-button");
            expect(buttonInTemplate,isNotNull);

        }); // end of 'waitForChild' test

        test('> Timeout', () async {
            final dom.HtmlElement element = await renderer.render(parent,html);

            await componentHandler().upgradeElement(element);
            final SlowComponent component = SlowComponent.widget(element.querySelector("slow-component"));

            // It takes a while until DOM is ready for SlowComponent (~400ms)
            // (requestAnimationFrame is used for rendering)
            expect(component.element.innerHtml,isEmpty);

            // mdl-button is a child within <slow-component>
            // Remember: Rendering takes ~400ms!
            bool foundException = false;
            try {
                // Wait only 50ms (default wait-time (50ms) times maxIterations)
                await component.waitForChild(".mdl-button", maxIterations: 1);
            } on TimeoutException catch(_) {
                foundException = true;
            }
            expect(foundException,isTrue);

        }); // end of 'Timeout' test

    });
    // End of 'MdlComponent' group
}

// - Helper --------------------------------------------------------------------------------------
