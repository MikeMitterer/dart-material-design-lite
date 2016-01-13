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

library mdldirective;

//@MirrorsUsed(metaTargets: const [ MdlComponentModelAnnotation ])
//import 'dart:mirrors';

import 'dart:html' as dom;
import 'dart:async';
import 'dart:collection';

import 'package:di/di.dart' as di;
import 'package:logging/logging.dart';
import 'package:mustache/mustache.dart';
import 'package:validate/validate.dart';

import "package:mdl/mdlformatter.dart";
import 'package:mdl/mdlapplication.dart';
import 'package:mdl/mdlcomponents.dart';
import 'package:mdl/mdlcore.dart';
import 'package:mdl/mdlobservable.dart';

part "src/directive/components/MaterialObserve.dart";
part "src/directive/components/MaterialModel.dart";
part "src/directive/components/MaterialClass.dart";
part "src/directive/components/MaterialAttribute.dart";

part "src/directive/components/model/ModelObserverFactory.dart";
part "src/directive/components/model/ModelObserver.dart";

part "src/directive/utils.dart";

class MdlDirectiveModule extends di.Module {
    MdlDirectiveModule() {
        bind(ModelObserverFactory);
    }
}
final MdlDirectiveModule _directiveModule = new MdlDirectiveModule();


void registerMdlDirectiveComponents() {

    registerMaterialObserve();
    registerMaterialModel();
    registerMaterialClass();
    registerMaterialAttribute();

    componentHandler().addModule(_directiveModule);

}