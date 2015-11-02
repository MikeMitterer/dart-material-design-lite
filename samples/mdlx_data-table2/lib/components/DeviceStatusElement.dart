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
part of devicestatus;
 
/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _DeviceStatusElementCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _DeviceStatusElementCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _DeviceStatusElementConstant {

    static const String WIDGET_SELECTOR = "device-status";

    const _DeviceStatusElementConstant();
}    

/// Basic DI configuration for this Component or Service
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new DeviceStatusElementModule());
///         }     
///     }
class DeviceStatusElementModule  extends di.Module {
    DeviceStatusElementModule() {
        // bind(DeviceProxy);
    }
}


@MdlComponentModel
class DeviceStatus {
    final Logger _logger = new Logger('devicestatus.DeviceStatus');

    static int _counter = 0;
    String id;

    final String name;
    num latitude;
    final num longitude;

    bool sos;

    DeviceStatus(this.name, this.latitude, this.longitude, this.sos) {
        id = "status${_counter}";
        _counter++;
    }
}


@MdlComponentModel
class DeviceStatusElement extends MdlTemplateComponent {
    final Logger _logger = new Logger('devicestatus.DeviceStatusElement');

    //static const _DeviceStatusElementConstant _constant = const _DeviceStatusElementConstant();
    static const _DeviceStatusElementCssClasses _cssClasses = const _DeviceStatusElementCssClasses();

    final ObservableList<DeviceStatus> items = new ObservableList<DeviceStatus>();

    DeviceStatusElement.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        
        _init();
    }
    
    static DeviceStatusElement widget(final dom.HtmlElement element) => mdlComponent(element,DeviceStatusElement) as DeviceStatusElement;
    
    void addItem(final DeviceStatus status) {
        items.add(status);
    }

    // - EventHandler -----------------------------------------------------------------------------

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("DeviceStatusElement - init");
        
        /// Recommended - add SELECTOR as class
        element.classes.add(_DeviceStatusElementConstant.WIDGET_SELECTOR);
        
        render();
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
    
    //- Template -----------------------------------------------------------------------------------
    
    @override
    final String template = """
     <table class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
        <thead>
          <tr>
            <th class="mdl-data-table__cell--non-numeric">MAC</th>
            <th>Name</th>
            <th>Latitude</th>
            <th>Longitude</th>
            <th>SOS</th>
          </tr>
        </thead>
        <tbody mdl-repeat="item in items" >
            {{! ----- Turn off default mustache interpretation ---- }} {{= | | =}}
            <template>
                <tr>
                    <td class="mdl-data-table__cell--non-numeric">{{item.id}}</td>
                    <td>{{item.name}}</td>
                    <td>{{item.latitude}}</td>
                    <td>{{item.longitude}}</td>
                    <td>{{item.sos}}</td>
                </tr>
            </template>
            |= {{ }} =| {{! ----- Turn on mustache ---- }}
        </tbody>
      </table>
    """.trim().replaceAll(new RegExp(r"\s+")," ");

}

/// registration-Helper
void registerDeviceStatusElement() {
    final MdlConfig config = new MdlWidgetConfig<DeviceStatusElement>(
        _DeviceStatusElementConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new DeviceStatusElement.fromElement(element,injector)
    );
    
    // If you want <device-status></device-status> set selectorType to SelectorType.TAG.
    // If you want <div device-status></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="device-status"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

