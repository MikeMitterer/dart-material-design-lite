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

part of mdlapplication;

abstract class MaterialController {
    /**
     * {injector} will be set after {ViewFactory} receives the {onLoadEnd} Event
     *
     * Part in ViewFactory:
     *      main.render(content).then( (_) {
     *          controller.injector = main.injector;
     *          controller.loaded(event.route);
     *      });
     */
    di.Injector injector;

    /// {loaded} is called after {ViewFactory} received the {onLoadEnd} Event
    void loaded(final Route route);

    /// Called before the next controller is loaded
    void unload() {}
}

class DummyController extends MaterialController {
    final Logger _logger = new Logger('mdlapplication.DummyController');

    @override
    void loaded(final Route route) {
        _logger.info("View loaded! (Route: ${route.name})");
    }

    @override
    void unload() {
        _logger.info("Unload Controller...");
    }
}