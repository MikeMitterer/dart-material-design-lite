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

/// Translate
///
/// https://angular.io/guide/i18n
/// http://www.labri.fr/perso/fleury/posts/programming/a-quick-gettext-tutorial.html
/// 
@Component
class MaterialTranslate extends MdlComponent {
    final Logger _logger = new Logger('mdldirective.MaterialTranslate');

    //static const _MaterialTranslateConstant _constant = const _MaterialTranslateConstant();
    static const _MaterialTranslateCssClasses _cssClasses = const _MaterialTranslateCssClasses();

    String _idToTranslate = "";

    MaterialTranslate.fromElement(final dom.HtmlElement element,final Injector injector)
        : super(element,injector) {

        _init();
    }

    static MaterialTranslate widget(final dom.HtmlElement element) => mdlComponent(element,MaterialTranslate) as MaterialTranslate;

    /// Resets text in the corresponding Element to the translation
    /// and returns the [value] set for this Element
    String reset() {
        if (_idToTranslate.isNotEmpty) {
            value = _idToTranslate;
        }
        else {
            _logger.shout("ID to Translate is empty!!!");
        }

        return value;
    }

    void set value(final String idToTranslate) {
        if(idToTranslate == null) {
            element.text = "null";
            return;
        } else if(idToTranslate.isEmpty) {
            element.text = "";
            return;
        }

        _idToTranslate = idToTranslate;
        
        // If attribute is set to true or if attribute is available but has no
        // value set
        if(_fieldvalue) {
            final String translation = l10n(_idToTranslate);
            element.text = translation;
        } else {
            element.text = _idToTranslate;
        }
    }

    String get value => element.text;

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialTranslate - init");

        // Recommended - add SELECTOR as class
        element.classes.add(_MaterialTranslateConstant.WIDGET_SELECTOR);

        /*final String translation =*/ element.text.replaceFirstMapped(
            new RegExp(
                '(_|l10n|L10N)(\\(\'|\\(\")'
                '(.*)'
                '(\'\\)|\"\\))'),
                (final Match match) {
                _idToTranslate = match.group(3).trim();
                /*
                for(int i = 1;i <= match.groupCount;i++) {
                    _logger.info(match[i]);
                }
                _logger.info("......................................");
                */
                //return translator.translate(new L10N(_idToTranslate));
            });

        //_logger.info("-> " + _idToTranslate);

        if (_idToTranslate.isNotEmpty) {
            value = _idToTranslate;
        }
        else {
            _logger.shout("ID to Translate is empty!!!");
        }

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// Returns true if attribute has no value set or if it's value is set to 'no'
    bool get _fieldvalue => !('no' == element.attributes[_MaterialTranslateConstant.WIDGET_SELECTOR]?.trim());
}

/// registration-Helper
void registerMaterialTranslate() {
    final MdlConfig config = new MdlConfig<MaterialTranslate>(
        _MaterialTranslateConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final Injector injector) => new MaterialTranslate.fromElement(element,injector)
    );
    
    // If you want <mdl-model></mdl-model> set selectorType to SelectorType.TAG.
    // If you want <div mdl-model></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdl-model"></div>)
    config.selectorType = SelectorType.ATTRIBUTE;

    componentHandler().register(config);
}

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialTranslateCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialTranslateCssClasses(); }

/// Store constants in one place so they can be updated easily.
class _MaterialTranslateConstant {

    static const String WIDGET_SELECTOR = "translate";

    const _MaterialTranslateConstant();
}
