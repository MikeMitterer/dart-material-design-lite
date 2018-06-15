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

// @TestOn("dartium")
@TestOn("chrome")
import 'package:test/test.dart';

import 'dart:html' as dom;
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

import '../config.dart';
import 'datatable_test.reflectable.dart';

main() async {
    final Logger _logger = new Logger("test.DataTable");
    configLogging();

    initializeReflectable();

    registerMdl();
    await initComponents();

    group('DataTable', () {
        setUp(() { });

        test('> check if upgraded', () {
            final dom.TableElement element = dom.document.querySelector("#data-table");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialDataTable");

            final MaterialDataTable component = MaterialDataTable.widget(element);
            expect(component,isNotNull);

        }); // end of 'check if upgraded' test

        test('> widget', () {
            final dom.TableElement element = dom.document.querySelector("#data-table");

            final MaterialDataTable widget = MaterialDataTable.widget(element);
            expect(widget,isNotNull);

        }); // end of 'widget' test

    });
    // end 'DataTable' group
}

// - Helper --------------------------------------------------------------------------------------
