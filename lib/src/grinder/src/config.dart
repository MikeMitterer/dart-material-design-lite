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

part of mdl.grinder;

const String _MDL_DIR        = '/Volumes/Daten/DevLocal/DevDart/material-design-lite/src';
const String _MDL_DART_DIR   = '/Volumes/Daten/DevLocal/DevDart/MaterialDesignLite';
const String _GIT_THEMES_DIR = '/Volumes/Daten/DevLocal/DevDart/MaterialDesignLiteTheme';
const String _SITE_DIR       = '/Volumes/Daten/DevLocal/DevDart/MaterialDesignLiteSite';

final Config config = new Config();

/**
 * Defines default-configurations.
 * Most of these configs can be overwritten by commandline args.
 */
class Config {

    static const String _KEY_SASS_DIR                 = "sassdir";
    static const String _KEY_MDL_DIR                  = "mdldir";
    static const String _KEY_MDL_DART_DIR             = "mdldartdir";
    static const String _KEY_SAMPLES_DIR              = "samples";
    static const String _KEY_THEMES_DIR               = "themesdir";
    static const String _KEY_LAYOUTS_DIR              = "layoutsdir";
    static const String _KEY_FONTS_DIR                = "fontsdir";
    static const String _KEY_GIT_THEMES_DIR           = "gitthemesdir";
    static const String _KEY_SITE_DIR                 = "sitedir";
    static const String _KEY_LOGLEVEL                 = "loglevel";
    static const String _KEY_MK_BACKUP                = "mkbackup";
    static const String _KEY_MAIN_TEMPLATE            = "maintemplate";
    static const String _KEY_INDEX_TEMPLATE           = "indextemplate";
    static const String _KEY_YAML_TEMPLATE            = "yamltemplate";
    static const String _KEY_SCSS_TEMPLATE            = "scsstemplate";
    static const String _KEY_README_TEMPLATE          = "readmetemplate";
//    static const String _KEY_DEMO_TEMPLATE            = "demotemplate";
    static const String _KEY_SITEGEN_CONTENT_TEMPLATE = "contenttemplate";
    static const String _KEY_SITEGEN_SITE_TEMPLATE    = "sitetemplate";
    static const String _KEY_FOLDERS_TO_EXCLUDE       = "excludefolder";
    static const String _KEY_PORT_BASE                = "portbase";
    static const String _KEY_DEMO_BASE                = "demobase";
    static const String _KEY_JS_BASE                  = "jsbase";

    final Map<String,dynamic> _settings = new Map<String,dynamic>();

    Config() {

        _settings[_KEY_SASS_DIR]                  = 'lib/assets/styles';
        _settings[_KEY_SAMPLES_DIR]               = 'samples';
        _settings[_KEY_THEMES_DIR]                = 'lib/assets/themes';
        _settings[_KEY_LAYOUTS_DIR]               = 'lib/assets/layouts';
        _settings[_KEY_FONTS_DIR]                 = 'lib/assets/fonts';
        _settings[_KEY_LOGLEVEL]                  = 'info';
        _settings[_KEY_MK_BACKUP]                 = false;
        _settings[_KEY_MAIN_TEMPLATE]             = "tool/templates/main.tmpl.dart";
        _settings[_KEY_INDEX_TEMPLATE]            = "tool/templates/index.tmpl.html";
        _settings[_KEY_YAML_TEMPLATE]             = "tool/templates/pubspec.tmpl.yaml";
        _settings[_KEY_SCSS_TEMPLATE]             = "tool/templates/material-design-lite.tmpl.scss";
        _settings[_KEY_README_TEMPLATE]           = "tool/templates/README.tmpl.html";
//        _settings[_KEY_DEMO_TEMPLATE]             = "tool/templates/demo.tmpl.html";
        _settings[_KEY_SITEGEN_CONTENT_TEMPLATE]  = "tool/templates/content.tmpl.html";
        _settings[_KEY_SITEGEN_SITE_TEMPLATE]     = "tool/templates/site.tmpl.yaml";
        _settings[_KEY_FOLDERS_TO_EXCLUDE]        = "demo-images,demo,third_party,variables,resets,fonts,images,mixins,ripple,bottombar,dialog";   // Liste durch , getrennt
        _settings[_KEY_PORT_BASE]                 = "tool/portbase"; // Ziel für die konvertierten JS-Files
        _settings[_KEY_DEMO_BASE]                 = "tool/demobase"; // Ziel für die konvertierten DEMO-Files
        _settings[_KEY_JS_BASE]                   = "tool/jsbase"; // Basis für die JS-Files

        _settings[_KEY_MDL_DIR]                   = _MDL_DIR;
        _settings[_KEY_GIT_THEMES_DIR]            = _GIT_THEMES_DIR;
        _settings[_KEY_SITE_DIR]                  = _SITE_DIR;
        _settings[_KEY_MDL_DART_DIR]              = _MDL_DART_DIR;



    }

    //List<String> get dirstoscan => _argResults.rest;

    String get loglevel => _settings[_KEY_LOGLEVEL];

    String get sassdir => _settings[_KEY_SASS_DIR];

    String get mdldir => _settings[_KEY_MDL_DIR];

    String get mdldartdir => _settings[_KEY_MDL_DART_DIR];

    String get samplesdir => _settings[_KEY_SAMPLES_DIR];

    String get themesdir => _settings[_KEY_THEMES_DIR];

    String get layoutsdir => _settings[_KEY_LAYOUTS_DIR];

    String get fontsdir => _settings[_KEY_FONTS_DIR];

    String get gitthemesdir => _settings[_KEY_GIT_THEMES_DIR];

    String get sitedir => _settings[_KEY_SITE_DIR];

    bool get mkbackup => _settings[_KEY_MK_BACKUP];

    String get maintemplate => _settings[_KEY_MAIN_TEMPLATE];

    String get indextemplate => _settings[_KEY_INDEX_TEMPLATE];

    String get yamltemplate => _settings[_KEY_YAML_TEMPLATE];

    String get scsstemplate => _settings[_KEY_SCSS_TEMPLATE];

    String get readmetemplate => _settings[_KEY_README_TEMPLATE];

//    String get demotemplate => _settings[_KEY_DEMO_TEMPLATE];

    String get contenttemplate => _settings[_KEY_SITEGEN_CONTENT_TEMPLATE];

    String get sitetemplate => _settings[_KEY_SITEGEN_SITE_TEMPLATE];

    String get folderstoexclude => _settings[_KEY_FOLDERS_TO_EXCLUDE];

    String get portbase => _settings[_KEY_PORT_BASE];

    String get demobase => _settings[_KEY_DEMO_BASE];

    String get jsbase => _settings[_KEY_JS_BASE];

    Map<String,String> get settings {
        final Map<String,String> settings = new Map<String,String>();

        settings["SASS-Dir"]                    = sassdir;
        settings["Samples-Dir"]                 = samplesdir;
        settings["Themes-Dir"]                  = themesdir;
        settings["Layouts-Dir"]                 = layoutsdir;
        settings["Fonts-Dir"]                   = fontsdir;
        settings["loglevel"]                    = loglevel;
        settings["make backup"]                 = mkbackup ? "yes" : "no";
        settings["Main-Template"]               = maintemplate;
        settings["Index-Template"]              = indextemplate;
        settings["YAML-Template"]               = yamltemplate;
        settings["SCSS-Template"]               = scsstemplate;
        settings["README-Template"]             = readmetemplate;
        settings["Sitegen content-Template"]    = contenttemplate;
        settings["Sitegen site-Template"]       = sitetemplate;
        settings["Folders to exclude"]          = folderstoexclude;
        settings["Base-Dir for js2Dart files"]  = portbase;
        settings["Base-Dir for Demo files"]     = demobase;
        settings["Base-Dir for ORIG JS files"]  = jsbase;

        settings["MDL-Dir"]                     = mdldir;
        settings["MDL/Dart-Dir"]                = mdldartdir;
        settings["GIT-Themes-Dir"]              = gitthemesdir;
        settings["Site-Dir"]                    = sitedir;

        return settings;
    }

    // -- private -------------------------------------------------------------

//    _overwriteSettingsWithArgResults() {
//
//        /// Makes sure that path does not end with a /
//        //String checkPath(final String arg) {
//        //    String path = arg;
//        //    if(path.endsWith("/")) {
//        //        path = path.replaceFirst(new RegExp("/\$"),"");
//        //    }
//        //    return path;
//        //}
//
//        if(_argResults[Application._ARG_LOGLEVEL] != null) {
//            _settings[_KEY_LOGLEVEL] = _argResults[Application._ARG_LOGLEVEL];
//        }
//
//        if(_argResults[Application._ARG_MK_BACKUP] != null) {
//            _settings[_KEY_MK_BACKUP] = _argResults[Application._ARG_MK_BACKUP] as bool;
//        }
//    }
}