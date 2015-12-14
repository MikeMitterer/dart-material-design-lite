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

library mdldialog;

import 'dart:html' as dom;
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdlcore.dart';
import 'package:mdl/mdlcomponents.dart';
import 'package:mdl/mdlapplication.dart';
import 'package:mdl/mdltemplate.dart';
import 'package:mdl/mdlanimation.dart';

part "src/dialog/MaterialDialog.dart";
part "src/dialog/MaterialAlertDialog.dart";

part "src/dialog/MaterialConfirmDialog.dart";

part "src/dialog/MaterialSnackbar.dart";
part "src/dialog/MaterialNotification.dart";

part "src/dialog/components/MaterialDialogComponent.dart";

void registerMdlDialogComponents() {
    _registerMaterialDialogComponent();
}