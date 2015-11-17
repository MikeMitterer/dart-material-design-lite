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

@di.Injectable()
class ModelObserverFactory {
    final Logger _logger = new Logger('mdldirective.ModelObserverFactory');

    final Map<Type,ModelObserverBuilder> _builders = new Map<Type,ModelObserverBuilder>();

    ModelObserverFactory() {
        _setDefaultBuilders();
    }

    ModelObserver createFor(final dom.Element element) {
        final MdlComponent component = mdlComponent(element,null);
        final Type type = component.runtimeType;

        if(_builders.containsKey(type)) {

            return _builders[type](component);

        } else {

            throw new ArgumentError("${element} cannot be observed. Probably not a MdlComponent! Type: ${type}");

        }
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

    }
}

