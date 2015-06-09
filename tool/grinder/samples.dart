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

part of gensamples;

enum Type {
    Core, Extra, Dart, DartOld, SPA, Styleguide, Template, Ignore
}

class Sample {
    final String name;
    final Type type;
    
    final bool hasScript;
    final bool hasDemoHtml;
    final bool hasDemoCss;
    final bool hasReadme;
    final bool hasOwnDartMain;
    final bool hasOwnDemoHtml;
    final bool hasOwnPubSpec;
    final bool excludeFromStyleguide;

    // Sample has his own demo.scss
    //final bool hasOwnDemoSCSS;

    /// does lib/assets/styles/<samplename> exist (not the case for example for content, include...)
    final bool hasStyle;

    String scssFile;
    String scssFileTarget;

    String jsFile;
    String convertedJSFile;

    String readme =     "README.md";
    String htmlDemo =   "demo.html";
    String cssDemo =    "demo.css";

    Sample(this.name,this.type,
           {    final hasScript: true, final hasDemoCss: true,
                final bool hasReadme: true, final bool hasDemoHtml: true,
                final bool hasOwnDartMain: false, bool hasOwnDemoHtml: false,
                final bool excludeFromStyleguide: false,
                final bool hasStyle: true, final bool hasOwnPubSpec: false
           }) :
                this.hasScript = hasScript, this.hasDemoCss = hasDemoCss,
                this.hasReadme = hasReadme,this.hasDemoHtml = hasDemoHtml,
                this.hasOwnDartMain = hasOwnDartMain, this.hasOwnDemoHtml = hasOwnDemoHtml,
                this.excludeFromStyleguide = excludeFromStyleguide,
                this.hasStyle = hasStyle, this.hasOwnPubSpec = hasOwnPubSpec
            {

    scssFile = "_${name}.scss";
    scssFileTarget = "_${name}.orig.scss";

    jsFile = "${name}.js";
    convertedJSFile = "${name}.js.dart";
    }

    String get dirname => "${prefix}${name}";

    String get prefix {
        switch(type) {
            case Type.Core:
                return "mdl_";

            case Type.Extra:
                return "???_";

            case Type.Dart:
                return "mdlx_";

            case Type.DartOld:
                return "mdlo_";

            case Type.SPA:
                return "spa_";

            case Type.Styleguide:
                return "";

            case Type.Template:
                return "template_";

            case Type.Ignore:
                return "???_";

            default:
                throw "No prefix for $type";
        }
    }
}

final List<Sample> samples = new List<Sample>();

void createSampleList() {
    // MDL Core
    samples.add(new Sample("animation", Type.Core,  hasReadme: false, hasOwnDartMain: true)..jsFile = "demo.js" );
    samples.add(new Sample("badge",     Type.Core,  hasScript: false, hasReadme: false, hasOwnDartMain: true, hasOwnDemoHtml: true));
    samples.add(new Sample("button",    Type.Core,  hasOwnDemoHtml: true ));
    samples.add(new Sample("card",      Type.Core,  hasScript: false));
    samples.add(new Sample("checkbox",  Type.Core,  hasDemoCss: false));
    samples.add(new Sample("data-table",Type.Core,  hasDemoCss: false, hasReadme: false));

    samples.add(new Sample("footer",    Type.Core,  hasScript: false)
        ..scssFile = "_mega_footer.scss"
        ..scssFileTarget = "_mega_footer.orig.scss");

    samples.add(new Sample("footer",    Type.Core,  hasScript: false)
        ..scssFile = "_mini_footer.scss"
        ..scssFileTarget = "_mini_footer.orig.scss");

    samples.add(new Sample("grid",      Type.Core,  hasScript: false));
    samples.add(new Sample("icon-toggle",Type.Core, hasReadme: false, hasOwnDartMain: true, hasOwnDemoHtml: true));
    samples.add(new Sample("layout",    Type.Core));
    samples.add(new Sample("list",      Type.Core,  hasScript: false));
    samples.add(new Sample("menu",      Type.Core,  hasOwnDartMain: true, hasOwnDemoHtml: true));
    samples.add(new Sample("palette",   Type.Core,  hasScript: false, hasReadme: false));
    samples.add(new Sample("progress",  Type.Core,  hasDemoCss: false, hasOwnDemoHtml: true, hasOwnDartMain: true));
    samples.add(new Sample("radio",     Type.Core,  hasDemoCss: false, hasOwnDartMain: true));
    samples.add(new Sample("shadow",    Type.Core,  hasScript: false));
    samples.add(new Sample("slider",    Type.Core,  hasDemoCss: false, hasOwnDartMain: true, hasOwnDemoHtml: true));
    samples.add(new Sample("spinner",   Type.Core,  hasDemoCss: false, hasOwnDartMain: true, hasOwnDemoHtml: true));
    samples.add(new Sample("switch",    Type.Core,  hasDemoCss: false));
    samples.add(new Sample("tabs",      Type.Core));
    samples.add(new Sample("textfield", Type.Core));
    samples.add(new Sample("tooltip",   Type.Core));
    samples.add(new Sample("typography",Type.Core,  hasScript: false));

    samples.add(new Sample("ripple",    Type.Ignore,  hasDemoCss: false, hasDemoHtml: false, hasReadme: false, excludeFromStyleguide: true ));

    // MDL Extras
    samples.add(new Sample("resets",Type.Extra));
    samples.add(new Sample("demo-images",Type.Extra));
    samples.add(new Sample("third_party",Type.Extra));

    // MDL/Dart
    samples.add(new Sample("accordion", Type.Dart, hasOwnDemoHtml: true));
    samples.add(new Sample("dialog",    Type.Dart, hasOwnDartMain: true, hasOwnDemoHtml: true));
    samples.add(new Sample("forms",     Type.Dart, hasOwnDemoHtml: true));
    samples.add(new Sample("nav-pills", Type.Dart, hasOwnDemoHtml: true));
    samples.add(new Sample("panel",     Type.Dart, hasOwnDemoHtml: true));
    samples.add(new Sample("snackbar",  Type.Dart, hasOwnDartMain: true, hasOwnDemoHtml: true));

    // MDL/Dart old
    samples.add(new Sample("icons",Type.DartOld));

    // SPA Samples
    samples.add(new Sample("content",   Type.SPA, hasOwnDartMain: true, hasOwnDemoHtml: true, hasStyle: false));
    samples.add(new Sample("include",   Type.SPA, hasOwnDartMain: true, hasOwnDemoHtml: true, hasStyle: false, hasOwnPubSpec: true));
    samples.add(new Sample("todo",      Type.SPA, hasOwnDartMain: true, hasOwnDemoHtml: true, hasStyle: false));

    // Styleguide!
    samples.add(new Sample("styleguide",Type.Styleguide));

    // Layout (Template-Samples)
    samples.add(new Sample("admin",Type.Template));
    samples.add(new Sample("blog",Type.Template));
    samples.add(new Sample("dashboard",Type.Template));
    samples.add(new Sample("fixed-header",Type.Template));
    samples.add(new Sample("general",Type.Template));
    samples.add(new Sample("product",Type.Template));
    samples.add(new Sample("sticky-footer",Type.Template));
    samples.add(new Sample("text-only",Type.Template));

    samples.add(new Sample("layout-header-drawer",Type.Template));

}