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

library mdlapplication;

//@MirrorsUsed(metaTargets: const [ MdlComponentModelAnnotation ],
//targets: const [ 'List' ],
//symbols: const [ '[]' ])
//import 'dart:mirrors';

import 'dart:html' as dom;
import 'dart:async';
import 'dart:js';

import 'package:di/di.dart' as di;
import 'package:logging/logging.dart';
import 'package:reflectable/reflectable.dart';
import 'package:route_hierarchical/client.dart';
import 'package:validate/validate.dart';

import "package:mdl/mdlcomponents.dart";
import "package:mdl/mdlcore.dart";
import "package:mdl/mdlflux.dart";

part "src/application/interfaces.dart";

part "src/application/mirrors/StringToFunction.dart";
part "src/application/mirrors/Invoke.dart";

part "src/application/modules/DomRenderer.dart";
part "src/application/modules/EventCompiler.dart";
part "src/application/modules/ViewFactory.dart";
part "src/application/modules/Scope.dart";

part "src/application/components/MaterialContent.dart";
part "src/application/components/MaterialInclude.dart";

part "src/application/MaterialContoller.dart";

part "src/application/Utils.dart";

/**
 * This is the top level module which describes all extended MDL-Components and Services.
 * When instantiating an MDL application through componentFactory() MdlModule is automatically included.
 *
 * Sample:
 *      main() {
 *          registerMdl();
 *          componentFactory().run().then((_) {
 *
 *          });
 *      }
 */
class MdlModule extends di.Module {

    MdlModule() {
        bind(MaterialApplication);

        bind(DomRenderer);
        bind(EventCompiler);
        bind(ViewFactory);
        bind(RootScope);

        bind(ActionBus, toImplementation: ActionBusImpl);
        bind(DataStore, toImplementation: FireOnlyDataStore);
    }
}

final MdlModule _mdlmodule = new MdlModule();

MdlComponentHandler componentFactory() => componentHandler();

void registerApplicationComponents() {

    registerMaterialContent();
    registerMaterialInclude();

    void _addModule() {
        componentHandler().addModule(_mdlmodule);
    }

    _addModule();
}