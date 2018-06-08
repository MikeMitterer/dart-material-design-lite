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

library mdlformatter;

import 'dart:html' as dom;

import 'dart:collection';
import 'package:dryice/dryice.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:mdl/mdlcore.dart';
import 'package:mdl/mdlcomponents.dart';
import 'package:mdl/mdlapplication.dart';

part 'src/formatter/components/MaterialFormatter.dart';

part 'src/formatter/utils/FallbackFormatter.dart';
part 'src/formatter/utils/FormatterPipeline.dart';

part 'src/formatter/ChooseFormatter.dart';
part 'src/formatter/DecoratorFormatter.dart';
part 'src/formatter/LowerCaseFormatter.dart';
part 'src/formatter/NumberFormatter.dart';
part 'src/formatter/UpperCaseFormatter.dart';

/**
 * Formatter ist a collection of formatters.
 * To add your own formatter follow the sample below
 *
 *      @Directive
 *      class MyFormatter extends Formatter {
 *
 *          // Your super cool formatter
 *          final TestFormatter test = new TestFormatter();
 *      }
 *
 *      class MyFormatterModule extends Module {
 *          MyFormatterModule() {
 *              bind(Formatter, ,toImplementation: MyFormatter);
 *          }
 *      }
 *
 *      main() {
 *          ...
 *            componentFactory().rootContext(Application).
 *               addModule(new StyleguideModule()).run()
 *                  .then((final MaterialApplication application) {
 *
 *                application.run();
 *          });
 *
 *          ...
 *      }
 *
 * HTML:
 *      <span mdl-observe="pi | test(value)"></span>
 *      or
 *      <div class="mdl-labelfield" mdl-formatter="uppercase(value)">...</div>
 */
@inject
class Formatter {
    final NumberFormatter    number = new NumberFormatter();
    final DecoratorFormatter decorate = new DecoratorFormatter();
    final UpperCaseFormatter uppercase = new UpperCaseFormatter();
    final LowerCaseFormatter lowercase = new LowerCaseFormatter();
    final ChooseFormatter    choose = new ChooseFormatter();
}

/// Makes Formatter available in DI
class MdlFormatterModule extends Module {
    configure() {
        bind(Formatter);
    }
}
final MdlFormatterModule _formatterModule = new MdlFormatterModule();

/// No components here at the moment but function-name fits the naming-conventions
/// Add MdlFormatterModule to DI-Framework
void registerMdlFormatterComponents() {

    void _addModule() {
        componentHandler().addModule(_formatterModule);
    }

    _addModule();

    registerMaterialFormatter();
}
