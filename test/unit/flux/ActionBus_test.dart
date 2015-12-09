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
import "package:mdl/mdlflux.dart";

import '../config.dart';

class TestDataAction extends DataAction<String> {
     static const ActionName NAME = const ActionName("unit.test.TestDataAction");
     const TestDataAction(final String id) : super(NAME,id);
}

class TestSignal extends Action {
    static const ActionName NAME = const ActionName("unit.test.TestSignal");
    const TestSignal() : super(ActionType.Signal,NAME);
}

main() {
    // final Logger _logger = new Logger("test.ActionBus");
    configLogging();

    group('ActionBus', () {

        group('> SendSignal', () {
            final ActionBus actionbus = new ActionBus();

            setUp(() {

            });

            test('> fire Simple Action', () {
                expect(actionbus, isNotNull);

                final Function onSignalTest = expectAsync( (final Action action ) {
                    //_logger.info("ActionTest: ${action.name}");

                    expect(action.type,ActionType.Signal);
                    expect(action.hasData,isFalse);
                });

                actionbus.on(TestSignal.NAME).listen(onSignalTest);

                actionbus.fire(const TestSignal());
            });

            test('> fire Action with Data', () {
                expect(actionbus, isNotNull);

                /// Hier komm angular-signal-test an (Keine Daten!!!!!)
                final Function onDataActionTest = expectAsync( (final DataAction<String> action ) {
                    //_logger.info("ActionTest: ${action.name}");

                    expect(action.type,ActionType.Data);
                    expect(action.hasData,isTrue);
                    expect(action.data,"Test");
                });

                actionbus.on(TestDataAction.NAME).listen(onDataActionTest);

                actionbus.fire(const TestDataAction("Test"));
            });

        }); // End of 'SendSignal' group

    });
    // end 'ActionBus' group
}