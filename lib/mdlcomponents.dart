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

library mdlcomponents;

import 'dart:html' as dom;
import 'dart:math' as Math;
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dryice/dryice.dart';
import 'package:reflected_mustache/mustache.dart';
import 'package:validate/validate.dart';
import 'package:platform_detect/platform_detect.dart';

import "package:mdl/mdlcore.dart";
import "package:mdl/mdlformatter.dart";

part "src/components/MaterialAccordion.dart";
part "src/components/MaterialBadge.dart";
part "src/components/MaterialButton.dart";
part "src/components/MaterialCheckbox.dart";
part "src/components/MaterialDataTable.dart";
part "src/components/MaterialDivDataTable.dart";
part "src/components/MaterialIconToggle.dart";
part "src/components/MaterialLabelfield.dart";
part "src/components/MaterialLayout.dart";
part "src/components/MaterialMenu.dart";
part "src/components/MaterialProgress.dart";
part "src/components/MaterialProgressVertical.dart";
part "src/components/MaterialRadio.dart";
part "src/components/MaterialRipple.dart";
part "src/components/MaterialSlider.dart";
part "src/components/MaterialSpinner.dart";
part "src/components/MaterialSwitch.dart";
part "src/components/MaterialTabs.dart";
part "src/components/MaterialTextfield.dart";
part "src/components/MaterialTooltip.dart";

final MdlComponentHandler _componenthandler = new MdlComponentHandler();

MdlComponentHandler componentHandler() {
    return _componenthandler;
}

void registerMdlComponents() {

    registerMaterialAccordion();
    registerMaterialBadge();
    registerMaterialButton();
    registerMaterialCheckbox();
    registerMaterialDataTable();
    registerMaterialDivDataTable();
    registerMaterialIconToggle();
    registerMaterialLabelfield();
    registerMaterialLayout();
    registerMaterialMenu();
    registerMaterialProgress();
    registerMaterialProgressVertical();
    registerMaterialRadio();
    registerMaterialRadioGroup();
    registerMaterialSlider();
    registerMaterialSpinner();
    registerMaterialSwitch();
    registerMaterialTabs();
    registerMaterialTextfield();
    registerMaterialTooltip();

    // should be the last registration
    registerMaterialRipple();
}

Future<MaterialApplication> upgradeCoreComponents() {
    return componentHandler().run();
}
