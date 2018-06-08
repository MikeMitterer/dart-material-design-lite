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

typedef void MdlCallback(final dom.HtmlElement element);

typedef MdlComponent MdlComponentFactory(final dom.HtmlElement element,final Injector injector);

enum SelectorType { CLASS, TAG, ATTRIBUTE }

enum RegistrationPriority {
    FIRST,

    // e.g. MaterialFormatter
    PRE_WIDGET,

    // e.g. MaterialButton
    WIDGET,

    // e.g. MaterialDivDataTableRow (MaterialDivDataTable has WIDGET-Priority to make sure
    // each row has its MaterialDivDataTable-Parent
    CHILD_WIDGET,

    // e.g. MaterialForm needs all other Widgets
    POST_WIDGET,

    // everything else!
    DEFAULT,

    LAST
}

class MdlConfig<T extends MdlComponent> {
    final List<MdlCallback> callbacks = new List<MdlCallback>();

    /// {_componentFactory} is more or less a function that constructs the appropriate
    /// Object.
    /// Sample:
    ///     (final dom.HtmlElement element,final Injector injector)
    ///         => new MaterialAccordion.fromElement(element,injector));
    ///
    final MdlComponentFactory _componentFactory;

    /// Holds the Component-Class or the Components TAG name
    /// Sample:
    ///    mdl-js-accordion
    String _selector;

    /// by default {selector} is a css-class-name.
    SelectorType selectorType = SelectorType.CLASS;

    /// Returns the appropriate selector for this component. Either a class-selector, attribute-selector
    /// or a Tag-Name
    String get selector {

        switch(selectorType) {
            case SelectorType.TAG:
                return _selector;

            case SelectorType.ATTRIBUTE:
                return "[${_selector}]";

            case SelectorType.CLASS:
            default:
                return ".${_selector}";
        }
    }

    /// The selector how it is defined in the Component
    String get baseSelector => _selector;

    /// The higher the priority the later the component will be upgraded.
    /// This is important e.g. for the ripple-effect. The ripple-effect must be called as last upgrade process
    /// Default {priority} is 5, materialRippleConfig sets {priority} to 10
    /// It's important do know that MdlWidgetConfig gets [priority] 3
    /// This guaranties that a widget exists always before it's properties
    RegistrationPriority priority = RegistrationPriority.DEFAULT;

    /// Avoids problems with Components and Helpers like MaterialRipple
    final bool isWidget;

    MdlConfig(this._selector, T componentFactory(final dom.HtmlElement element,final Injector injector),
              { final bool isWidget: false }) : _componentFactory = componentFactory, this.isWidget = isWidget {

        Validate.isTrue(T != "dynamic", "Add a type-information to your MdlConfig like new MdlConfig<MaterialButton>()");
        Validate.notBlank(_selector, "cssClass must not be blank.");
        Validate.notNull(_componentFactory);
    }

    String get classAsString => type.toString();

    Type get type => T;

    MdlComponent newComponent(final dom.HtmlElement element,final Injector injector) {
        return _componentFactory(element,injector);
    }

    //- private -----------------------------------------------------------------------------------

}

/// Helps to decide what is a real Widget and what is just a helper.
/// MaterialRipple would be such a "helper"
///
/// MdlWidgetConfig sets [priority] to 3. (default is 5) This guaranties that a widget will be created before it's
/// (MdlComponent) properties!
class MdlWidgetConfig<T extends MdlComponent> extends MdlConfig<T> {
    MdlWidgetConfig(final String selector,
                    T componentFactory(final dom.HtmlElement element,final Injector injector)) :
                        super(selector, componentFactory, isWidget: true) {

    priority = RegistrationPriority.WIDGET;
    }
}