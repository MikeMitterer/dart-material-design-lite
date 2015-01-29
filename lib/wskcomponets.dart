library wskcomponents;

import 'dart:html' as html;
import 'dart:math' as Math;
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import "package:wsk_material/wskcore.dart";

part "src/components/MaterialButton.dart";
part "src/components/MaterialRipple.dart";

final ComponentHandler _componenthandler = new ComponentHandler();

void registerMaterialButton() => _componenthandler.register(new WskConfig<MaterialButton>());
void registerMaterialRipple() => _componenthandler.register(new WskConfig<MaterialRipple>());

void registerAllWskComponents() {
    registerMaterialButton();
    registerMaterialRipple();
}

Future upgradeAllRegistered() {
    return _componenthandler.upgradeAllRegistered();
}

@WskCssClass("wsk-js-toolbar")
class MaterialToolBar extends WskComponent {
    final Logger _logger = new Logger('wskcomponents.MaterialToolBar');

    MaterialToolBar(final html.HtmlElement element) : super(element) {
        _init();
    }

    void _init() {
        _logger.info("MaterialButton - init");
    }

}