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
@TestOn("content-shell")
import 'package:test/test.dart';

import 'dart:html' as dom;

import 'package:mdl/mdl.dart';

import '../config.dart';

main() async {
    // final Logger _logger = new Logger("test.Progress");
    configLogging();

    registerMdl();
    await initComponents();

    group('Progress', () {
        setUp(() { });
        
        test('> check if upgraded', () {
            final dom.HtmlElement element = dom.document.querySelector("#p1");

            expect(element,isNotNull);
            expect(element.dataset.containsKey("upgraded"),isTrue);
            expect(element.dataset["upgraded"],"MaterialProgress");
        }); // end of 'check if upgraded' test

        test('> widget', () {
            final dom.HtmlElement element = dom.document.querySelector("#p1");

            final MaterialProgress widget = MaterialProgress.widget(element);
            expect(widget,isNotNull);

            widget.progress = 50;
            expect(widget.progress,50);

            MaterialProgress.widget(dom.querySelector("#p3")).progress = 33;
            MaterialProgress.widget(dom.querySelector("#p3")).buffer = 66;


        }); // end of 'widget' test

        test('> Min / Max', () {
            final MaterialProgress maxCheck = MaterialProgress.widget(dom.querySelector("#p4"));
            final MaterialProgress minCheck = MaterialProgress.widget(dom.querySelector("#p5"));

            expect(maxCheck,isNotNull);
            expect(minCheck,isNotNull);

            maxCheck.progress = 133;
            minCheck.progress = -66;

            expect(maxCheck.progress,100);
            expect(minCheck.progress,0);

        }); // end of 'Min / Max' test

    });
    // end 'Progress' group
}

// - Helper --------------------------------------------------------------------------------------
