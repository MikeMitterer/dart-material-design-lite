// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wsk_material.unit.test;

import 'package:unittest/unittest.dart';

//-----------------------------------------------------------------------------
// Logging

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_material/wskcore.dart';
import 'package:wsk_material/wskcomponets.dart';

main() {
    final Logger _logger = new Logger('wsk_material.unit.test');

    configLogging();

    group('A group of tests', () {
        final ComponentHandler componenthandler = new ComponentHandler();

        setUp(() {

            componenthandler.register(new WskConfig<MaterialButton>("wsk-button"));
            componenthandler.register(new WskConfig<MaterialButton>("wsk-button"));
            componenthandler.register(new WskConfig("wsk-button"));
            componenthandler.register(new WskConfig<MaterialToolBar>("wsk-toolbar"));
        });

        test('First Test', () {
            componenthandler.upgradeAllRegistered().then(expectAsync((_) {

            }));
        });
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}