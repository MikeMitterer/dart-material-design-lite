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

part of mdlcore;

/**
 * Basis for your Application
 *
 * Sample:
 *      class Application extends MaterialApplication {
 *          ...
 *          @override
 *          void run() {
 *              ...
 *          }
 *      }
 *
 *      main() {
 *          registerMdl();
 *
 *          componentFactory().rootContext(Application).run()
 *              .then( (final MaterialApplication application) {
 *
 *              application.run();
 *          });
 *      }
 */
@MdlComponentModel @di.Injectable()
class MaterialApplication {
    void run() {}
}

/**
 * MdlComponent that has a "refresh" Functions.
 * Best way to invoke this function is via [refreshComponentsInSubtree]
 *
 * Sample-Component:
 *      [MaterialModel]
 */
abstract class RefreshableComponent {
    void refresh();
}

/**
 * For Components like [_MaterialDialogComponent] where it's necessary to
 * change the ParentScope on runtime. For example if [MaterialDialog] pops up
 * the Parent-Scope is set to the new Dialog
 */
abstract class HasDynamicParentScope {
    void set parentScope(final Object parent);
}