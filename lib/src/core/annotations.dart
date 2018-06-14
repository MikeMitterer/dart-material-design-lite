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

/// Core-Annotations got it's own library so that it's not DOM-Related.
///
/// Makes it better testable.
///
///     @Component
///     class Person {
///         final String id;
///         String name;
///
///         Person(this.nae) : id = new Uuid().v1();
///
///         Person.from(final Person person) : name = person.name, id = person.id;
///     }
///
library mdlcore.annotations;

/// Mustache (+mirrors) needs to know which classes to include
class MdlAnnotation {
    const MdlAnnotation();
}


/// Helps dryice to know which vars are available to render
///
/// Sample:
///     @Component
///     class Model {
///         int sliderValue = 20;
///     }
///     mustache.template = """
///                 <div>
///                    Slider value: {{sliderValue}}
///                </div>""";
///     mustache.render(model);
///
/// For 'class Application...' use @inject
///
///     @inject
///     class Application extends MaterialApplication {
///         ...
///     }
@deprecated
const MdlAnnotation MdlComponentModel = const MdlAnnotation();

/// All MDLComponents
const MdlAnnotation Component = const MdlAnnotation();

/// Usually used for Templates
const MdlAnnotation Model = const MdlAnnotation();
//const InjectAnnotation model = const InjectAnnotation();
//const MdlComponentModelAnnotation Model = const MdlComponentModelAnnotation();

/// Directives like [Formatter]
const MdlAnnotation Directive = const MdlAnnotation();
//const InjectAnnotation directive = const InjectAnnotation();
//const MdlComponentModelAnnotation Directive = const MdlComponentModelAnnotation();

/**
 * Helper for Transformer to generate documentation
 */
class MdlPublicFunctionAnnotation { const MdlPublicFunctionAnnotation(); }
const MdlPublicFunctionAnnotation public = const MdlPublicFunctionAnnotation();
