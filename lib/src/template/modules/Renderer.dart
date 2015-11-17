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

part of mdltemplate;

typedef Future _RenderFunction();

/**
 * Exchangeable Render function.
 * {TemplateRenderer} or {ListRenderer} are returning this.
 * {MdlTemplateComponent} has a Renderer for rendering.
 *
 * Sample: (ToDoItem.dart)
 *
 *      if(useRenderListFunction) {
 *           renderer = _listRenderer(element,this,_items,() => template);
 *
 *      } else {
 *           renderer = _templateRenderer(element,this,() => template);
 *
 *      }
 */
class Renderer {
    final _RenderFunction _renderFunction;

    Renderer(this._renderFunction);

    Future render() => _renderFunction();
}
