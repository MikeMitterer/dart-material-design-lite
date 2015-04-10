library wskcomponents;

import 'dart:html' as html;
import 'dart:math' as Math;
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:browser_detect/browser_detect.dart';

import "package:wsk_material/wskcore.dart";

part "src/components/MaterialAccordion.dart";
part "src/components/MaterialBadge.dart";
part "src/components/MaterialButton.dart";
part "src/components/MaterialRipple.dart";
part "src/components/MaterialCheckbox.dart";
part "src/components/MaterialColumnLayout.dart";
part "src/components/MaterialIconToggle.dart";
part "src/components/MaterialItem.dart";
part "src/components/MaterialLayout.dart";
part "src/components/MaterialMenu.dart";
part "src/components/MaterialProgress.dart";
part "src/components/MaterialRadio.dart";
part "src/components/MaterialSlider.dart";
part "src/components/MaterialSpinner.dart";
part "src/components/MaterialSwitch.dart";
part "src/components/MaterialTabs.dart";
part "src/components/MaterialTextfield.dart";
part "src/components/MaterialTooltip.dart";

final WskComponentHandler componenthandler = new WskComponentHandler();

void registerAllWskComponents() {

    registerMaterialAccordion();
    registerMaterialBadge();
    registerMaterialButton();
    registerMaterialCheckbox();
    registerMaterialColumnLayout();
    registerMaterialIconToggle();
    registerMaterialItem();
    registerMaterialLayout();
    registerMaterialMenu();
    registerMaterialProgress();
    registerMaterialRadio();
    registerMaterialSlider();
    registerMaterialSpinner();
    registerMaterialSwitch();
    registerMaterialTabs();
    registerMaterialTextfield();
    registerMaterialTooltip();

    // should be the last registration
    registerMaterialRipple();
}

Future upgradeAllRegistered() {
    return componenthandler.upgradeAllRegistered();
}
