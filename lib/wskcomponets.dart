library wskcomponents;

import 'dart:html' as html;
import 'package:logging/logging.dart';

import "package:wsk_material/wskcore.dart";

part "src/components/MaterialButton.dart";

class MaterialToolBar extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialToolBar');

    MaterialToolBar(final html.HtmlElement element) : super(element) {
        init();
    }

    @override
    void init() {
        _logger.info("MaterialButton - init");
    }

}