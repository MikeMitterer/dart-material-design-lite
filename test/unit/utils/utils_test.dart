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

        test('> asInt', () {
            expect(DataAttribute.forValue("10").asInt(), 10);
            expect(DataAttribute.forValue("1000").asInt(), 1000);
            expect(DataAttribute.forValue("99").asInt(defaultValue: 42), 99);
            expect(DataAttribute.forValue("99.-").asInt(defaultValue: 42), 42);

            expect(DataAttribute.forValue("abc").asInt(), 0);
            expect(DataAttribute.forValue("1000,10").asInt(), 0);
            expect(DataAttribute.forValue("1.000").asInt(), 0);

            expect(DataAttribute.forValue(null).asInt(), 0);
            expect(DataAttribute.forValue("true").asInt(), 0);
            expect(DataAttribute.forValue("false").asInt(), 0);
            expect(DataAttribute.forValue("").asInt(), 0);

        }); // end of 'asInt' test

    });
    // end 'DataAttribute' group
}

