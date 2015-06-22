/**
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

//@TestOn("dartium")

library mdl.ui.unit.test;

import 'dart:html' as dom;
import 'dart:async';
import 'package:test/test.dart';

//-----------------------------------------------------------------------------
// Logging

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import "package:mdl/mdl.dart";

part "core/componenthandler_test.dart";

part "components/accordion_test.dart";
part "components/button_test.dart";
part "components/checkbox_test.dart";
part "components/icon_toggle_test.dart";
part "components/data-table_test.dart";
part "components/layout_test.dart";
part "components/menu_test.dart";
part "components/progress_test.dart";
part "components/radio_test.dart";

part "template/components/repeat_test.dart";

/**
 * run the test with your favorit webserver.
 * In my case I run it with with:
 *      visual $ sitegen --serve --docroot .
 */
main() async {
    final Logger _logger = new Logger('wsk_material.unit.test');

    configLogging();

    registerMdl();

    Future initComponents() async {
        final Stopwatch stopwatch = new Stopwatch()..start();
        await componentFactory().run();
        stopwatch.stop();
        _logger.info("UI Initialized, took ${stopwatch.elapsedMilliseconds}ms...");
    }

    await initComponents();

    testComponentHandler();

    testAccordion();
    testButton();
    testCheckbox();
    testIconToggle();
    testDataTable();
    testLayout();
    testMenu();
    testProgress();
    testRadio();

    testRepeat();
}

void configLogging() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}