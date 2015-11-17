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
 * This library its mainly for internal use!
 *
 * It is used to generate all the necessary files for MDL/Dart and
 * for MDL/Dart-Website. Some!!! path are hardcoded and refer to my local machine
 */
library mdl.grinder;

import 'dart:io';
import 'dart:convert';

import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as Path;
import 'package:validate/validate.dart';

part 'src/samples.dart';
part 'src/config.dart';

part 'src/MergeMaster.dart';
part 'src/SampleGenerator.dart';
part 'src/ThemeGenerator.dart';
part 'src/JSConverter.dart';
part 'src/Styleguide.dart';
part 'src/Utils.dart';