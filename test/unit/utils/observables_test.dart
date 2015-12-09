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

import "package:mdl/mdl.dart";
import "package:mdl/mdlobservable.dart";
import 'package:logging/logging.dart';

import '../config.dart';

main() {
    final Logger _logger = new Logger("mdl.unit.test.Observables");
    configLogging();

    group('Observables', () {
        setUp(() { });

        test('> List', () {
            final ObservableList<String> list = new ObservableList<String>();

            final onChange = expectAsync((final ListChangedEvent event) {
                expect(event.changetype,ListChangeType.ADD);

                _logger.fine(list.toString());
            });

            list.onChange.listen(onChange);
            list.add("Hallo");

        }); // end of 'List' test

        

    });
    // end 'Observables' group
}
