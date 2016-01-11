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

library mdltemplate;

//@MirrorsUsed(metaTargets: const [ MdlComponentModelAnnotation ])
//import 'dart:mirrors';

import 'dart:html' as dom;
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';
import 'package:mustache/mustache.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdlcore.dart';
import 'package:mdl/mdlcomponents.dart';
import 'package:mdl/mdlapplication.dart';
import 'package:mdl/mdlobservable.dart';

part "src/template/interfaces.dart";

part "src/template/MdlTemplateComponent.dart";

part "src/template/components/MaterialMustache.dart";
part "src/template/components/MaterialRepeat.dart";

part "src/template/modules/Renderer.dart";
part "src/template/modules/TemplateRenderer.dart";
part "src/template/modules/ListRenderer.dart";

class MdlTemplateModule extends di.Module {
    MdlTemplateModule() {
        bind(TemplateRenderer);
        bind(ListRenderer);
    }
}
final MdlTemplateModule _templateModule = new MdlTemplateModule();

void registerMdlTemplateComponents() {

    registerMaterialMustache();
    registerMaterialRepeat();

    componentHandler().addModule(_templateModule);
}