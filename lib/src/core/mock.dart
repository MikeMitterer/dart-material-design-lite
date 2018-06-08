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

/// Purpose of [mockComponentHandler] is to inject the componentHandler
/// with a mocked Injector for testing
///
///     setUp(() {
///         mdlmock.setUpInjector();
///         mdlmock.module((final Module module) {
///             module.bind(SignalService, toImplementation: SignalServiceImpl);
///             module.bind(Translator, toValue: _translator);
///         });
///         mockComponentHandler(mdlmock.injector(),componentFactory());
///     });
///
void mockComponentHandler(final Injector injector,final MdlComponentHandler componentHandler) {
    componentHandler._injector = injector;
}
