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

/// Mustache (+mirrors) needs to know which classes to include
//class MdlComponentModelAnnotation extends Reflectable {
//    const MdlComponentModelAnnotation(): super(
//        invokingCapability,
//        reflectedTypeCapability
//    );
//}


/**
 * Helps mustache to know which vars are available to render
 * Sample:
 *
 * @MdlComponentModel
 * class Model {
 *     int sliderValue = 20;
 * }
 *
 * mustache.template = """
 *             <div>
 *                 Slider value: {{sliderValue}}
 *             </div>""";
 *
 * mustache.render(model);
 */
const MustacheMirrorsUsedAnnotation MdlComponentModel = const MustacheMirrorsUsedAnnotation();
const MustacheMirrorsUsedAnnotation mdltemplate = const MustacheMirrorsUsedAnnotation();

/**
 * Helper for Transformer to generate documentation
 */
class MdlPublicFunctionAnnotation { const MdlPublicFunctionAnnotation(); }
const MdlPublicFunctionAnnotation public = const MdlPublicFunctionAnnotation();