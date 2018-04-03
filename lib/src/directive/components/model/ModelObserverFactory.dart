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

part of mdldirective;

typedef ModelObserver ModelObserverBuilder(final MdlComponent component);

@di.injectable
class ModelObserverFactory {
    final Logger _logger = new Logger('mdldirective.ModelObserverFactory');

    final Map<Type,ModelObserverBuilder> _builders = new Map<Type,ModelObserverBuilder>();

    ModelObserverFactory() {
        _setDefaultBuilders();
    }

    ModelObserver createFor(final dom.Element element) {
        final components = mdlComponents(element);

        Type type = null;
        MdlComponent component;

        _logger.info("CL ${components.length}/${components.first.runtimeType}");
        if(components.length == 0) {
            throw new ArgumentError("${element} cannot be observed. This is not a MdlComponent! Type: ${type}");

        }
        // Element is probably a div or a span
        else if(components.length == 1 && components.first.runtimeType == MaterialModel) {
            component = components.first;
            type = component.runtimeType;
            if(_builders.containsKey(type)) {
                component = components.first;
            }
        }
        // Take first MDL-Component that is not a MaterialModel
        else {
            _logger.info("IST in ELSE");
            
            // Model has lowest priority if multiple components defined
            MaterialModel model;

            component = components.firstWhere((final MdlComponent componentFromElement) {
                type = componentFromElement.runtimeType;
                if(type == MaterialModel) {
                    // Remember the model
                    model = componentFromElement;
                    return false;
                }
                return _builders.containsKey(type);

            },orElse: () => null);

            // If we have no other components - use MaterialModel
            if(component == null && model != null) {
                type = model.runtimeType;
                component = model;
            }
        }

        if(component == null) {
            final attributes = new List<String>();
            element.attributes.forEach((key,value) => attributes.add("$key:$value"));

            String classes = element.classes.join(", ");

            throw new ArgumentError(
                "${element} cannot be observed. This is not an observable type! Maybe you want to use 'mdl-observe'?\n"
                "    Type: ${type},\n"
                "    Attributes: ${attributes.join(", ")},\n"
                "    Classes: ${classes}"
            );
        }

        return _builders[type](component);
    }

    void setBuilderFor(final Type type,final ModelObserverBuilder builder) {
        Validate.notNull(type);
        Validate.notNull(builder);

        _builders[type] = builder;
    }

    //- private -----------------------------------------------------------------------------------

    void _setDefaultBuilders() {

        setBuilderFor( MaterialTextfield, (final MdlComponent component) {
            Validate.notNull(component);
            return new _TextFieldObserver._internal(component);
        });

        setBuilderFor( MaterialCheckbox, (final MdlComponent component) {
            Validate.notNull(component);
            return new _CheckBoxObserver._internal(component);
        });

        setBuilderFor( MaterialRadioGroup, (final MdlComponent component) {
            Validate.notNull(component);
            return new _RadioObserver._internal(component);
        });

        setBuilderFor( MaterialSwitch, (final MdlComponent component) {
            Validate.notNull(component);
            return new _SwitchObserver._internal(component);
        });

        setBuilderFor( MaterialSlider, (final MdlComponent component) {
            Validate.notNull(component);
            return new _SliderObserver._internal(component);
        });

        // Fits e.g. for span or div elements
        setBuilderFor( MaterialModel, (final MdlComponent component) {
            Validate.notNull(component);
            return new _HtmlElementObserver._internal(component);
        });

    }
}

