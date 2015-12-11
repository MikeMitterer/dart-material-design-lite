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

/// Helps testing MDL/Dart + DI
///
///     import 'package:mdl/mdlmock.dart' as mdlmock;
///
///     main() {
///         ...
///         setUp( () {
///
///             mdlmock.setUpInjector();
///             mdlmock.module((final di.Module module) {
///                 module.bind(SignalService, toImplementation: SignalServiceImpl);
///                 module.bind(Translator, toValue: _translator);
///         });
///
///         mdlmock.mockComponentHandler(mdlmock.injector(),mdlmock.componentFactory());
///         }
///     }
library mdlmock;

//import 'package:logging/logging.dart';
//import 'package:validate/validate.dart';

import 'dart:mirrors';
import 'package:di/di.dart' as di;

import 'package:mdl/mdlapplication.dart';
export 'package:mdl/mdlcore.dart' show mockComponentHandler;
export 'package:mdl/mdlapplication.dart' show componentFactory;

_MdlInjector _mdlInjector = null;

class _MdlInjector {
    final List<di.Module> _modules = new List<di.Module>();

    di.Injector _injector;

    void addModule(final di.Module module) {
        if(!_modules.contains(module)) {
            _modules.add(module);
        }
    }

    void inject(Function function) {
        _create();

        final ClosureMirror cm = reflect(function);
        final MethodMirror mm = cm.function;

        final List args = mm.parameters.map( (ParameterMirror parameter) {
            var metadata = parameter.metadata;

            di.Key key = new di.Key(
                (parameter.type as ClassMirror).reflectedType,
                    metadata.isEmpty ? null : metadata.first.type.reflectedType);

            return _injector.getByKey(key);

        }).toList();

        return cm.apply(args).reflectee;
    }

    // - private -------------------------------------------------------------------------------------------------------

    /// Creates the "Injector" also called by the global [injector()] Function
    void _create() {
        if(_injector == null) {
            _injector = new di.ModuleInjector(_modules);
        }
    }
}

class MdlMockModule extends di.Module {

    MdlMockModule() {

    }
}

/// Call this method in your test harness [setUp] method to setup the injector.
void setUpInjector() {
    _mdlInjector = new _MdlInjector();

    _mdlInjector.addModule(new MdlMockModule());
    _mdlInjector.addModule(new MdlModule());
}

void module(void regFunction(final di.Module module)) {
    final di.Module mod = new di.Module();

    regFunction(mod);

    if(_mdlInjector == null) {
        setUpInjector();
    }

    _mdlInjector.addModule(mod);
}

void inject(Function fn) {
    if(_mdlInjector == null) {
        setUpInjector();
    }
    _mdlInjector.inject(fn);
}

/// Call this method in your test harness [tearDown] method to cleanup the injector.
void tearDownInjector() {
    _mdlInjector = null;
}

/// Returns this mocked injector
///
///     setUp(() {
///         mdlmock.setUpInjector();
///         mdlmock.module((final di.Module module) {
///             module.bind(SignalService, toImplementation: SignalServiceImpl);
///             module.bind(Translator, toValue: _translator);
///         });
///         mockComponentHandler(mdlmock.injector(),componentFactory());
///     });
di.Injector injector() {
    if(_mdlInjector == null) {
        setUpInjector();
    }
    _mdlInjector._create();
    return _mdlInjector._injector;
}

