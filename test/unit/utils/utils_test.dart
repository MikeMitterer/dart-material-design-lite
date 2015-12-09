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

@TestOn("content-shell")
import 'package:test/test.dart';

import "package:mdl/mdlutils.dart";

import '../config.dart';

main() {
    // final Logger _logger = new Logger("test.DataAttribute");
    configLogging();

    group('DataAttribute', () {
        setUp(() { });

        test('> asBool', () {
            expect(DataAttribute.forValue(null).asBool(), isFalse);
            expect(DataAttribute.forValue("true").asBool(), isTrue);
            expect(DataAttribute.forValue("false").asBool(), isFalse);
            expect(DataAttribute.forValue("").asBool(), isFalse);
            expect(DataAttribute.forValue("").asBool(handleEmptyStringAs: true), isTrue);
        }); // end of 'asBool' test


    });
    // end 'DataAttribute' group
}

