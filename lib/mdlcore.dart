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

/**
 * The core - handles the initialisation process and
 * defines the base-class for all components
 */
library mdlcore;

import 'dart:html' as dom;
import 'dart:collection';
import 'dart:async';
import 'dart:js';

import 'package:di/di.dart' as di;
import 'package:logging/logging.dart';
import 'package:mustache/mustache.dart';
import 'package:validate/validate.dart';

part "src/core/annotations.dart";
part "src/core/ConvertValue.dart";
part "src/core/interfaces.dart";
part "src/core/mock.dart";
part "src/core/utils.dart";

part "src/core/MdlComponentHandler.dart";
part "src/core/MdlConfig.dart";
part "src/core/MdlComponent.dart";

abstract class MdlDataConsumer {
    void consume(final data);
}



