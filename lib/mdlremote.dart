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

library mdlremote;

import 'dart:html' as html;
import 'dart:math' as Math;
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:browser_detect/browser_detect.dart';
import 'package:route_hierarchical/client.dart';
import 'package:mustache/mustache.dart';

import 'package:mdl/mdlcore.dart';
import 'package:mdl/mdlcomponets.dart';

part "src/remote/ViewFactory.dart";
part "src/remote/Renderer.dart";

part "src/remote/MaterialContent.dart";
part "src/remote/MaterialMustache.dart";


part "src/remote/MaterialContoller.dart";

void registerAllMdlRemoteComponents() {

    registerMaterialContent();
    registerMaterialMustache();

}
