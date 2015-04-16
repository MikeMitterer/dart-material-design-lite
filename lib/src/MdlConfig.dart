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

part of mdlcore;

typedef void MdlCallback(final html.HtmlElement element);

typedef MdlComponent MdlComponentFactory(final html.HtmlElement element);

class MdlConfig<T extends MdlComponent> {
    final List<MdlCallback> callbacks = new List<MdlCallback>();

    final MdlComponentFactory _componentFactory;
    String cssClass;

    /// The higher the priority the later the component will be upgraded.
    /// This is important for the ripple-effect. Must be called as last upgrade process
    /// Default {priority} is 1, materialRippleConfig sets {priority} to 10
    int priority = 1;

    /// Avoids problems with Components and Helpers like MaterialRipple
    final bool isWidget;

    MdlConfig(this.cssClass, T componentFactory(final html.HtmlElement element), { final bool isWidget: false })
    : _componentFactory = componentFactory, this.isWidget = isWidget {

        Validate.isTrue(T != "dynamic", "Add a type-information to your MdlConfig like new MdlConfig<MaterialButton>()");
        Validate.notBlank(cssClass, "cssClass must not be blank.");
        Validate.notNull(_componentFactory);
    }

    String get classAsString => type.toString();

    Type get type => T;

    MdlComponent newComponent(final html.HtmlElement element) {
        return _componentFactory(element);
    }

//- private -----------------------------------------------------------------------------------

}

class MdlWidgetConfig<T extends MdlComponent> extends MdlConfig<T> {
    MdlWidgetConfig(final String cssClass, T componentFactory(final html.HtmlElement element)) :
    super(cssClass, componentFactory, isWidget: true);
}