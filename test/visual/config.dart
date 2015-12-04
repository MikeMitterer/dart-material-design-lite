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
     
library mdl.test.visual.config;

import 'dart:async';

import 'package:mdl/mdl.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

/*
 * Two ways to run these tests
 *
 * 1.) Make sure that the following line is include (not commented out) in test.html:
 *      <script async type="application/dart" src="test.dart"></script>
 *
 *      "cd" to test/visual
 *      Start your favorite test-WebServer (pub serve does not work for this case)
 *          e.g. sitegen --serve --port 9000 --docroot .
 *      In Dartium / Chromium:
 *          http://localhost:9000/test.html
 *
 * 2.) Make sure that the following line is NOT!!!! include (commented out) in test.html:
 *      <script async type="application/dart" src="test.dart"></script>
 *
 *      pub run test -p content-shell test/visual/test.dart
 */

void configLogging() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());
}

Future initComponents() async {
    final Logger _logger = new Logger('mdl.test.visual.config.initComponents');

    final Stopwatch stopwatch = new Stopwatch()..start();
    await componentFactory().run();
    stopwatch.stop();

    _logger.info("UI Initialized, took ${stopwatch.elapsedMilliseconds}ms...");
}