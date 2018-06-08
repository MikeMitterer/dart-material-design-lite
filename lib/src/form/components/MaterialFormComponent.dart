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
part of mdlform;
 
/// Basic DI configuration for this Component or Service
/// Usage:
///     class MainModule extends Module {
///         MainModule() {
///             install(new MaterialFormComponentModule());
///         }     
///     }
class MaterialFormComponentModule  extends Module {
  @override
  configure() {
      // register(DeviceProxy);
  }
}

enum MaterialFormState {
    VALID, INVALID
}

class FormChangedEvent {
    final MdlComponent currentTarget;

    FormChangedEvent(this.currentTarget);
}

/// Callback can be set as a last resort for
/// validation checks
///
/// [originalState] is the status determined by MaterialFormComponent
typedef bool IsFormValidCallback(final MaterialFormState originalState);

/**
 * Upgrades mdl-form und does some validation checks.
 *
 * The CSS-Class 'is-invalid' is set if not all requirement defined via HTML are met.
 * The CSS-Class 'is-dirty' will be set the first time one of the input elements gets an "onChange" event
 *
 * If MaterialFormComponent finds mdl-button--submit it enables/disables this
 * element depending on the validation check.
 * 
 *      <form method="post" class="right mdl-form mdl-form-registration demo-registration">
 *          <h5 class="mdl-form__title">Register for launch</h5>
 *          <div class="mdl-form__content">
 *              <div class="mdl-textfield">
 *                  <input class="mdl-textfield__input" type="text" id="sample1" required />
 *                  <label class="mdl-textfield__label" for="sample1">Name</label>
 *                  <span class="mdl-textfield__error">This field must not be empty</span>
 *              </div>
 *              <div class="mdl-textfield">
 *                  <input class="mdl-textfield__input" type="email" id="email" required />
 *                  <label class="mdl-textfield__label" for="email">Email</label>
 *              </div>
 *              <label class="mdl-checkbox mdl-js-checkbox mdl-ripple-effect" for="remember_me">
 *                  <input type="checkbox" id="remember_me" class="mdl-checkbox__input" required />
 *                  <span class="mdl-checkbox__label">Remember me</span>
 *              </label>
 *              </div>
 *          <div class="mdl-form__actions">
 *              <button class="mdl-button mdl-js-button mdl-button--submit mdl-button--raised
 *                  mdl-button--primary mdl-ripple-effect" disabled>
 *                 Login
 *              </button>
 *              </div>
 *      </form>
 */
class MaterialFormComponent extends MdlComponent {
    final Logger _logger = new Logger('mdlform.MaterialFormComponent');

    //static const _MaterialFormComponentConstant _constant = const _MaterialFormComponentConstant();
    static const _MaterialFormComponentCssClasses _cssClasses = const _MaterialFormComponentCssClasses();

    final List<MdlComponent> _components = new List<MdlComponent>();
    final List<MaterialButton> _submitButtons = new List<MaterialButton>();

    /// Will be set to true the first time one of the form-elements receives a
    /// [onChange]
    bool isDirty = false;

    StreamController<FormChangedEvent> _onChange;

    MaterialFormComponent.fromElement(final dom.HtmlElement element,final Injector injector)
        : super(element,injector) {
        
        _init();
    }
    
    static MaterialFormComponent widget(final dom.HtmlElement element) => mdlComponent(element,MaterialFormComponent) as MaterialFormComponent;

    /// Iterates through all MdlComponent in this form,
    /// checks if all the requirements are fulfilled (set via HTML)
    ///
    /// If the check returns true the "is-invalid" class is removed 
    /// Normally it's not necessary to call this function manually.
    /// This is done automatically if one of the
    /// MdlComponents gets an "onChange" event
    @override
    void update() => _updateStatus(repeatAfter: new Duration(milliseconds: 100));

    /// Returns true if all requirements are fulfilled 
    bool get isValid => _isFormValid();

    /// If focus changes from one field to the other
    Stream<FormChangedEvent> get onChange {
        if(_onChange == null) {
            _onChange = new StreamController<FormChangedEvent>.broadcast(onCancel: () => _onChange = null);
        }
        return _onChange.stream;
    }

    /// Called by the framework as last resort before it enables/disables the
    /// submit-button
    IsFormValidCallback isFormValidCallback = (final MaterialFormState state)
        => state == MaterialFormState.VALID;

    // - EventHandler -----------------------------------------------------------------------------

    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialFormComponent - init");

        _components.clear();
        _components.addAll(getAllMdlComponents(element));

        _components.forEach((final MdlComponent component) {
            if(component is MaterialButton && component.classes.contains(_cssClasses.SUBMIT_BUTTON)) {
                _submitButtons.add(component);
            }
        });

        _components.forEach((final MdlComponent component) {
            eventStreams.add(
                // Update internal form-status onInput
                component.onInput.listen((final dom.Event event) {
                    _logger.fine("$component changed!");
                    _componentChanged(component);
            }));

            eventStreams.add(
                // If focus changes - send FormChangedEvent
                component.hub.onChange.listen((final dom.Event event) {
                    _fire(new FormChangedEvent(component));
                })
            );

            eventStreams.add(
                component.hub.onKeyDown.listen((final dom.KeyboardEvent event) {
                    if(event.keyCode == dom.KeyCode.ENTER) {
                        if(component is MaterialTextfield) {
                            event.preventDefault();
                            
                            component.element.nextElementSibling.focus();
                            component.blur();
                        }
                    }
                })
            );
        });

        eventStreams.add(
            // Send from MaterialTextfield
            element.on["MaterialTextfieldChanged"].listen((event) {
                event.preventDefault();
                
                final customEvent = event as dom.CustomEvent;
                final component = customEvent.detail as MdlComponent;

                _logger.fine("${component} changed! (on MaterialTextfieldChanged)");
                _componentChanged(component);
            })
        );


        final dom.HtmlElement elementWithAutoFocus = element.querySelector("[autofocus]");
        if(elementWithAutoFocus != null) {
            elementWithAutoFocus.focus();
        }

        _updateStatus(repeatAfter: new Duration(milliseconds: 100));
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    void _componentChanged(final MdlComponent component) {
        isDirty = true;
        element.classes.add(_cssClasses.DIRTY);

        _updateStatus(repeatAfter: new Duration(milliseconds: 100));
    }

    bool _isFormValid() {
        var state = MaterialFormState.VALID;

        _components.forEach((final MdlComponent component) {
            if(component.hub is dom.InputElement) {
                if(!(component.hub as dom.InputElement).checkValidity()) {
                    _logger.fine("Checked ${component.hub.id}");
                    state = MaterialFormState.INVALID;
                    return;
                }
            }
        });
        return (isFormValidCallback == null ? state : isFormValidCallback(state));
    }

    void _setFormState(final MaterialFormState state) {

        if(state == MaterialFormState.VALID) {
            element.classes.remove(_cssClasses.INVALID);
        } else {
            element.classes.add(_cssClasses.INVALID);
        }
    }

    void _setSubmitButtonState(final MaterialFormState state) {
        _submitButtons.forEach((final MaterialButton button) {
            button.enabled = state == MaterialFormState.VALID;
        });
    }

    void _fire(final FormChangedEvent event) {
        if(_onChange != null && _onChange.hasListener) {
            _onChange.add(event);
        }
    }

    /// Updates the FormState (Valid/Invalid) and the status of the
    /// SubmitButton.
    ///
    /// With [repeatAfter] you can define if you want to repeat this
    /// function-call automatically after [repeatAfter]
    ///
    /// This is necessary for form-fields connected via [ObservableProperty] and [MaterialModel]
    void _updateStatus({ final Duration repeatAfter }) {
        final bool isFormValid = _isFormValid();

        _setFormState(isFormValid ? MaterialFormState.VALID : MaterialFormState.INVALID);
        _setSubmitButtonState(isFormValid ? MaterialFormState.VALID : MaterialFormState.INVALID);

        if(repeatAfter != null) {
            // Update Form-State again - just in case something took longer than expected
            new Timer(repeatAfter, () {
                _logger.fine("Auto-Update form state!");
                _updateStatus();
            });
        }
    }
}

/// registration-Helper
void registerMaterialFormComponent() {
    final MdlConfig config = new MdlWidgetConfig<MaterialFormComponent>(
        _MaterialFormComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final Injector injector) => new MaterialFormComponent.fromElement(element,injector)
    );
    
    // If you want <mdl-form></mdl-form> set selectorType to SelectorType.TAG.
    // If you want <div mdl-form></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdl-form"></div>)
    config.selectorType = SelectorType.CLASS;

    // With priority PRE_WIDGET we make sure that all children are registered before this components gets initialized
    config.priority = RegistrationPriority.POST_WIDGET;

    componentHandler().register(config);
}

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialFormComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    final String INVALID = 'is-invalid';
    final String DIRTY = 'is-dirty';

    final String SUBMIT_BUTTON = 'mdl-button--submit';

    const _MaterialFormComponentCssClasses(); }

/// Store constants in one place so they can be updated easily.
class _MaterialFormComponentConstant {

    static const String WIDGET_SELECTOR = "mdl-form";

    const _MaterialFormComponentConstant();
}