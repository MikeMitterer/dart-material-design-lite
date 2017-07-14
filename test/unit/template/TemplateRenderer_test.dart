@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:html' as dom;
import 'dart:async';

import 'package:dice/dice.dart' as di;

import "package:mdl/mdl.dart";
import 'package:mdl/mdlmock.dart' as mdlmock;

//import 'package:logging/logging.dart';

import '../config.dart';

@MdlComponentModel
class TestComponent extends MdlTemplateComponent {
    static const String WIDGET_SELECTOR = "test-component";

    final String name = "Mike";

    TestComponent.fromElement(final dom.HtmlElement element, final di.Injector injector)
        : super(element, injector) {

        _init();
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        render();

        element.classes.add("is-upgraded");
    }

    //- Template -----------------------------------------------------------------------------------

    @override
    final String template = """
        <div>
            <span class="name">{{name}}</span>
        </div>
    """.trim().replaceAll(new RegExp(r"\s+"), " ");
}

void registerTestComponent() {
    final MdlConfig config = new MdlWidgetConfig<TestComponent>(
        TestComponent.WIDGET_SELECTOR,
        (final dom.HtmlElement element,final di.Injector injector) => new  TestComponent.fromElement(element,injector)
    );

    // If you want <test-component></test-component> set selectorType to SelectorType.TAG.
    // If you want <div test-component></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="test-component"></div>)
    config.selectorType = SelectorType.TAG;

    componentHandler().register(config);
}

main() async {
    //final Logger _logger = new Logger("test.TemplateRenderer");

    configLogging();
    final DomRenderer renderer = new DomRenderer();

    group('TemplateRenderer', () {
        setUp(() async {
            mdlmock.setUpInjector();
            mdlmock.mockComponentHandler(mdlmock.injector(), mdlmock.componentFactory());
            prepareMdlTest(() async {
                await registerTestComponent();
                await registerMdlTemplateComponents();
            });
        });

        test('> Upgrade element with Template', () async {
            final dom.DivElement parent = new dom.DivElement();

            final dom.HtmlElement element = await renderer.render(parent,"<test-component></test-component>");

            await componentHandler().upgradeElement(element);

            // wait for 500ms to give requestAnimationFrame a chance to do its work
            // insertElement + removes mdl-content__loading flag from element
            new Future.delayed(new Duration(milliseconds: 500), expectAsync0( () {
                final String content = parent.innerHtml;
                expect(content,
                    '<test-component class="is-upgraded mdl-upgraded mdl-content__loaded" data-upgraded="TestComponent">'
                        '<div class="mdl-upgraded"> <span class="name">Mike</span> </div>'
                    '</test-component>');
                //_logger.info(content);
            }));
        }); // end of 'Upgrade element with Template' test

    });
    // End of 'TemplateRenderer' group
}

// - Helper --------------------------------------------------------------------------------------
