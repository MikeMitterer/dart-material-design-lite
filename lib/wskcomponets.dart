library wskcomponents;

import 'dart:html' as html;
import 'dart:math' as Math;
import 'dart:async';
import 'package:logging/logging.dart';

import "package:wsk_material/wskcore.dart";

part "src/components/MaterialButton.dart";
part "src/components/MaterialRipple.dart";
part "src/components/MaterialAnimation.dart";
part "src/components/MaterialCheckbox.dart";

final WskComponentHandler _componenthandler = new WskComponentHandler();

void registerAllWskComponents() {

    registerMaterialButton();
    registerMaterialAnimation();
    registerMaterialCheckbox();

    registerMaterialRipple();
}

Future upgradeAllRegistered() {
    return _componenthandler.upgradeAllRegistered();
}
