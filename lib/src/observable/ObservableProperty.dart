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

typedef T ResetObserver<T>();
typedef String FormatObservedValue<T>(final T value, final original);
typedef T StaticCast<T>(final value);

@Directive
class ObservableProperty<T> {
    static const String _DEFAULT_NAME = "<undefinded>";

    final Logger _logger = new Logger('mdlobservable.ObservableProperty');

    @Directive
    T _value;

    /// The original value set by [value]
    dynamic _inputValue;

    /// Always convert to double
    final bool _treatAsDouble;

    Function _observe;

    /// Default interval if no specified in CTOR
    Duration _interval = new Duration(milliseconds: 100);

    final bool _observeViaTimer;

    bool _pause = false;

    /// Observername - helps with debugging!
    final String _name;

    StreamController<PropertyChangeEvent<T>> _onChange;

    /// Callback called if [reset] is executed
    ResetObserver<T> _onReset;

    /// Formatter for this value - used in [toString]
    FormatObservedValue _formatter;

    StaticCast<T> _staticCast;

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
            final bool treatAsDouble: false, final FormatObservedValue formatter } )
                : _name = name, _treatAsDouble = treatAsDouble, _observeViaTimer = observeViaTimer,
                    _formatter = formatter, _inputValue = _value {

        if(interval != null && _observeViaTimer) {
            // per default 100ms
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

    /// Sets the internal value and emits a [PropertyChangeEvent]
    /// 
    /// If mdl-model is used this event changes
    /// the corresponding Material[Textfield | Checkbox ...] (defined in ModelObserver.dart)
    void set value(final input) {
        final T old = _value;

        // Remember the original value so that we can use it in toString (_formatter)
        _inputValue = input;

        // JS does not support double - so you have to specify treatAsDouble
        if(_value.runtimeType == double || _treatAsDouble ) {

            // Strange - but this avoids DA-Warning
            _value = ConvertValue.toDouble(_inputValue) as T;

        } else if(_value.runtimeType == bool) {

            _value = ConvertValue.toBool(_inputValue) as T;

        } else if(_value.runtimeType == int) {

            _value = ConvertValue.toInt(_inputValue) as T;

        } else {
            try {
                _value = _inputValue as T;
            } catch (e) {
                if(_staticCast == null) {
                    throw e;
                }
                _value = _staticCast(_inputValue);
            }
        }

        if(_value == null && old != null) {
            _logger.warning(
                "Input-Value: '$_inputValue' (${_inputValue.runtimeType})"
                " -> "
                "'${_value}' (${_value.runtimeType}) was: $old");
        }

        _fire(new PropertyChangeEvent(_value,old));
    }

    T get value => _value;

    /// Observe values in your app
    /// Sample:
    ///      final ObservableProperty<String> nrOfItems = new ObservableProperty<String>("");
    ///      ...
    ///      nrOfItems.observes( () => items.length > 0 ? items.length.toString() : "<no records>");
    ///
    ///  HTML:
    ///      <mdl-property consumes="nrOfItems"></mdl-property>
    void observes( T observe() ) {
        _observe = observe;
        run();
    }

    /// Defines a callback that is called if
    /// [reset] is called
    ///
    /// Basically changes the internal value to the result of [callback]
    void onReset(final ResetObserver<T> callback) => _onReset = callback;

    /// If the input value for [value] can not be converted to T
    /// this [callback] is called for conversion
    void onStaticCast(final StaticCast<T> callback) => _staticCast = callback;

    /// Called before [toString] to convert the internal value to String
    void onFormat(final FormatObservedValue callback) => _formatter = callback;

    /// Pauses the checks - no further observation.
    /// Observing can be restarted via [run]
    void pause() {
        _pause = true;
    }

    /// Continues with the checks. Manually calling this function is only necessary after [pause]
    void run() {
        if(_observe != null) {

            if(_observeViaTimer) {
                // first timer comes after short period - this shows the value
                // for the first time

                new Timer(new Duration(milliseconds: 50), () {
                    update();

                    // second timer comes after specified time
                    new Timer.periodic(_interval, (final Timer timer) {
                        if (_pause) {
                            _logger.info("Pause");
                            timer.cancel();

                            // Prepare for the next run
                            // At this state auto-update is already stopped 
                            _pause = false;
                            return;
                        }
                        update();
                    });
                });
            } else {

                update();
            }
        }
    }

    /// Sets the value via callback
    /// See [observes]
    ///
    /// Call this method manually if observeViaTimer (Constructor) is
    /// set to false
    void update() {
        if(_observe != null) {
            final T newValue = _observe() as T;
            if(newValue != _value) {
                value = newValue;
            }
        }
        _fire(new PropertyChangeEvent(_value,_value));
    }

    /// Converts [value] to bool. If [value] is a String, "true", "on", "1" are valid boolean values
    bool toBool() {
        return ConvertValue.toBool(value);
    }

    /// Whatever reset should do can be defined in CTOR
    /// or by defining the resetCallback
    T reset() {
        if(_onReset != null) {
            value = _onReset();
        }
        return value;
    }

    @override
    String toString() => _formatter != null ? _formatter(_value,_inputValue) : _value.toString();

    // - private ----------------------------------------------------------------------------------

    void _fire(final PropertyChangeEvent<T> event) {
        if(_name != ObservableProperty._DEFAULT_NAME) {  _logger.fine("Fireing $event from ${_name}...");  }

        //_logger.info("onChange: ${_onChange}, hasListeners: ${_onChange ?.hasListener}");
        if(_onChange != null && _onChange.hasListener) {
            _onChange.add(event);
        }
    }
}