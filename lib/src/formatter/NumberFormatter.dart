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

part of mdlformatter;

/**
 * Formats a number with a certain number of digits
 *
 *      <span mdl-observe="pi | number(value,2)"></span>
 */
@MdlComponentModel
class NumberFormatter {
    // final Logger _logger = new Logger('mdlformatter.NumberFormatter');

    final Map<String,Map<num, NumberFormat>> _nfs = new Map<String, Map<num, NumberFormat>>();

    /// 'number' is the formatter name. [fractionSize] defines the number of digits
    /// after the decimal point
    String number(final double value, [ int fractionSize = 2]) {
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
        //_logger.info("Called number $value value");
        return nf.format(value);
    }

    /// Important! this function is called by the framework
    ///     <span mdl-observe="pi | number(value,2)"></span>
    String call(final value, [ int fractionSize = 2]) => number(ConvertValue.toDouble(value),
        ConvertValue.toInt(fractionSize));
}
