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
part of mdldirective;
 
/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialObserveCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _MaterialObserveCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _MaterialObserveConstant {

    static const String WIDGET_SELECTOR = "mdl-observe";

    const _MaterialObserveConstant();
}    


class NumberFormatter {
    final Logger _logger = new Logger('formatter.NumberFormatter');

    final Map<String,Map<num, NumberFormat>> _nfs = new Map<String, Map<num, NumberFormat>>();

    String number(final value, [ int fractionSize = 2]) {
        double dVal;

        if(fractionSize is String) {
            fractionSize = int.parse(fractionSize as String);
        }

        if (value is String) {
            dVal = double.parse(value);
        }
        else if (value is num) {
            dVal = value;
        }
        else {
            dVal = double.parse(value.toString());
        }

        final String verifiedLocale = Intl.verifiedLocale(Intl.getCurrentLocale(), NumberFormat.localeExists);

        _nfs.putIfAbsent(verifiedLocale, () => new Map<num, NumberFormat>());

        NumberFormat nf = _nfs[verifiedLocale][fractionSize];
        if (nf == null) {
            nf = new NumberFormat()..maximumIntegerDigits = 2;
            if (fractionSize != null) {
                nf.minimumFractionDigits = fractionSize;
                nf.maximumFractionDigits = fractionSize;
            }
            _nfs[verifiedLocale][fractionSize] = nf;
        }

        //nf = new NumberFormat()..maximumIntegerDigits = 2;
        //_logger.info("Called number $value $dVal");
        return nf.format(dVal);
    }
}

class MaterialObserve extends MdlComponent with NumberFormatter implements ScopeAware {
    final Logger _logger = new Logger('mdldirective.MaterialObserve');

    static const _MaterialObserveCssClasses _cssClasses = const _MaterialObserveCssClasses();
    static const _MaterialObserveConstant _constant = const _MaterialObserveConstant();

    Scope scope;

    MaterialObserve.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

//        _logger.info("Vor SCOPE1----------");
//
//        scope = new Scope(this, mdlParentScope(this));
//
//        _logger.info("Nach SCOPE1______ ${scope.parentContext} ___________");
//
//        _init();
    }
    
    static MaterialObserve widget(final dom.HtmlElement element) => mdlComponent(element,MaterialObserve) as MaterialObserve;

    @public
    void set value(final val) => element.text = (val != null ? val.toString() : "");

    @public
    String get value => element.text.trim();

    @override
    void attached() {
        scope = new Scope(this,mdlParentScope(this));
        _init();
    }

    // --------------------------------------------------------------------------------------------
    // EventHandler

    //- private -----------------------------------------------------------------------------------



    void _init() {
        _logger.fine("MaterialObserve - init");

        /// Recommended - add SELECTOR as class
        element.classes.add(_MaterialObserveConstant.WIDGET_SELECTOR);

        if(element.attributes[_MaterialObserveConstant.WIDGET_SELECTOR].isNotEmpty) {
            final List<String> parts = element.attributes[_MaterialObserveConstant.WIDGET_SELECTOR].trim().split("|");
            final String fieldname = parts.first.trim();

            Invoke formatterFunction;
            StringToFunction stf;

            if(parts.length > 1) {
                final String formatter = parts[1].trim();
                stf = new StringToFunction(formatter);
                formatterFunction = new Invoke(new Scope(this,mdlParentScope(this)));

            }
            scope.context = scope.parentContext;
            final val = (new Invoke(scope)).field(fieldname);

            void _setValue(dynamic val) {
                if(formatterFunction != null) {
                    val = formatterFunction.function(stf,varsToReplace: { "value" : val });
                }
                element.text = (val != null ? val.toString() : "");
            }

            if(val != null && val is ObservableProperty) {
                final ObservableProperty prop = val;

                _setValue(prop.value);
                prop.onChange.listen( (final PropertyChangeEvent event) => _setValue(event.value));

            } else {

                _setValue(val);
            }

            //_logger.info("Property done!");
        }
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

/// registration-Helper
void registerMaterialObserve() {
    final MdlConfig config = new MdlConfig<MaterialObserve>(
        _MaterialObserveConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new MaterialObserve.fromElement(element,injector)
    );
    
    // if you want <mdl-property></mdl-property> set isSelectorAClassName to false.
    // By default it's used as a class name. (<div class="mdl-property"></div>)
    config.selectorType = SelectorType.ATTRIBUTE;

    componentHandler().register(config);
}

