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

library mdlform;

import 'dart:async';
import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:dryice/dryice.dart';

import 'package:mdl/mdlcore.dart';
import 'package:mdl/mdlcomponents.dart';

part "src/form/components/MaterialFormComponent.dart";

void registerMdlFormComponents() {
    registerMaterialFormComponent();
}