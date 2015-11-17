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

part of mdlobservable;

class PropertyChangeEvent<T> {
    final T oldValue;
    final T value;

    PropertyChangeEvent(this.value,this.oldValue);
}

@MdlComponentModel
class ObservableProperty<T> {
    static const String _DEFAULT_NAME = "<undefinded>";

    final Logger _logger = new Logger('mdlobservable.ObservableProperty');

    @MdlComponentModel
    T _value;

    /// Always convert to double
    final bool _treatAsDouble;

    Function _observe;

    /// Default interval if no specified in CTOR
    Duration _interval = new Duration(milliseconds: 100);

    bool _pause = false;

    /// Observername - helps with debugging!
    final String _name;

    StreamController<PropertyChangeEvent<T>> _onChange;

    /**
     * [_value] The observed value
     * [observe] Function in parent to observe special values
     * [interval] Check-Interval
     * [name] is useful for debugging. If you set this name and if you set your loglevel to "info" it
     * you should see a log output if this object fires a PropertyChangeEvent
     *
     * If you set [observeViaTimer] to false the PropertyChangeEvent is only triggered on "set value"
     *
     * Use [treatAsDouble] if you want to be sure that all your values are converted to double.
     * This works around the problem that Dart does not recognize a double if compiled to JS
     *
     * Sample:
     *      final ObservableProperty<double> long = new ObservableProperty<double>(0.0,treatAsDouble: true);
     *
     *      final ObservableProperty<String> time = new ObservableProperty<String>("", interval: new Duration(seconds: 1));
     *      Application() {
     *          time.observes(() => _getTime());
     *      }
     */
    ObservableProperty(this._value,{ T observe(), final Duration interval,
        final String name: ObservableProperty._DEFAULT_NAME, final bool observeViaTimer: true,
            final bool treatAsDouble: false } ) : _name = name, _treatAsDouble = treatAsDouble {

        if(interval != null && observeViaTimer) {
            _interval = interval;
        }
        if(observe != null) {
            observes(observe);

        } else {
            void _triggerFirstChangeEvent() {
                value = _value;
            }
            _triggerFirstChangeEvent();
        }
    }

    Stream<PropertyChangeEvent<T>> get onChange {
        if(_onChange == null) {
            _onChange = new StreamController<PropertyChangeEvent<T>>.broadcast(onCancel: () => _onChange = null);
        }
        return _onChange.stream;
    }

    void set value(final val) {
        final T old = _value;

        if(_value.runtimeType == double || _treatAsDouble ) {

            // Strange - but this avoids DA-Warning
            _value = ConvertValue.toDouble(val) as dynamic;

        } else if(_value.runtimeType == bool) {

            _value = ConvertValue.toBool(val) as T;

        } else if(_value.runtimeType == int) {

            _value = ConvertValue.toInt(val) as T;

        } else {
            _value = val;
        }

        _logger.fine("Input-Value: '$val' (${val.runtimeType}) -> '${_value}' (${_value.runtimeType})");

        _fire(new PropertyChangeEvent(_value,old));
    }

    T get value => _value;

    /**
     * Observe values in your app
     * Sample:
     *      final ObservableProperty<String> nrOfItems = new ObservableProperty<String>("");
     *      ...
     *      nrOfItems.observes( () => items.length > 0 ? items.length.toString() : "<no records>");
     *
     *  HTML:
     *      <mdl-property consumes="nrOfItems"></mdl-property>
     */
    void observes( T observe() ) {
        _observe = observe;
        run();
    }

    /// Pauses the checks - no further observation.
    /// Observing can be restarted via [run]
    void pause() {
        _pause = true;
    }

    /// Continues with the checks. Manually calling this function is only necessary after [pause]
    void run() {
        if(_observe != null) {
            // first timer comes after short period - this shows the value
            // for the first time
            new Timer(new Duration(milliseconds: 50),() {
                _setValue();

                // second timer comes after specified time
                new Timer.periodic(_interval,(final Timer timer) {
                    if(_pause) {
                        _logger.info("Pause");
                        timer.cancel();
                        _pause = false;
                        return;
                    }
                    _setValue();
                });
            });
        }
    }

    /// Converts [value] to bool. If [value] is a String, "true", "on", "1" are valid boolean values
    bool toBool() {
        return ConvertValue.toBool(value);
    }

    // - private ----------------------------------------------------------------------------------

    void _setValue() {
        if(_observe != null) {
            final T newValue = _observe();
            if(newValue != _value) {
              value = newValue;
              }
          }
     }

    void _fire(final PropertyChangeEvent<T> event) {
        if(_name != ObservableProperty._DEFAULT_NAME) {  _logger.fine("Fireing $event from ${_name}...");  }

        if(_onChange != null && _onChange.hasListener) {
            _onChange.add(event);
        }
    }
}