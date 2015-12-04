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

class Styleguide {

    void generate(final Sample sample) {
        // final Sample sampleStyleguide = samples.firstWhere((final Sample sample) => sample.type == Type.Styleguide);

        _copyDemoCssToStyleguide(sample,samplesToExclude: [ "layout1" ]);
        _copySampleViewToStyleguide(sample,samplesToExclude: [ "layout1" ]);
        _createUsageContentInStyleguide(sample);

        _createDartPartialInStyleguide(sample);
        _createHtmlPartialInStyleguide(sample,samplesToExclude: [ "layout1" ]);
        _createReadmePartialInStyleguide(sample);
    }

    // -- private -------------------------------------------------------------

    /// {sassDir} -> lib/sass/accordion
    void _copyDemoCssToStyleguide(final Sample sample,{ final List<String> samplesToExclude: const [] } ) {
        Validate.notNull(sample);

        final Directory webDir = new Directory("${config.samplesdir}/${sample.dirname}/web");
        final Directory targetScssDir = new Directory("${config.samplesdir}/styleguide/web/assets/styles/_demo");

        final File srcScss = new File("${webDir.path}/demo.scss");
        final File targetScss = new File("${targetScssDir.path}/_${sample.name}.scss");

        if(!srcScss.existsSync()) {
            return;
        }

        if(!targetScssDir.existsSync()) {
            targetScssDir.createSync(recursive: true);
        }

        if(targetScss.existsSync() && samplesToExclude.contains(sample.name)) {
            return;
        }

        // log.fine("Coping CSS's to styleguide $sampleName: ${targetScss.path}");

        String content = srcScss.readAsStringSync();
        content = content.replaceAll(new RegExp(r"^\/*@import[^;]*;$(?:\n|\r)*",caseSensitive: false, multiLine: true),"");

        targetScss.writeAsStringSync(content);
    }

    void _copySampleViewToStyleguide(final Sample sample, { final List<String> samplesToExclude: const [] }) {
        Validate.notNull(sample);

        //final Directory webDir = new Directory("${config.samplesdir}/${sample.dirname}/web");
        final Directory sitegenDir = new Directory("${config.samplesdir}/${sample.dirname}/.sitegen/html/_content");
        final File srcSample = new File("${sitegenDir.path}/index.html");

        final Directory targetSampleDir = new Directory("${config.samplesdir}/styleguide/.sitegen/html/_content/views");
        final File targetSample = new File("${targetSampleDir.path}/${sample.name}.html");

        if(!srcSample.existsSync()) {
            log("${srcSample.path} does not exist!");
            return;
        }

        if(!targetSampleDir.existsSync()) {
            targetSampleDir.createSync(recursive: true);
        }

        if(targetSample.existsSync() && samplesToExclude.contains(sample.name)) {
            return;
        }

        // log.fine("Coping view to styleguide $sampleName: ${targetSample.path}");

        String content = srcSample.readAsStringSync();

        content = content.replaceAll(new RegExp(r"<script[^>]*>.*</script>(?:\n|\r)*",caseSensitive: false, multiLine: true),"");
        content = content.replaceAll(new RegExp(r".*<!--[^>]*>.*(?:\n|\r)*",caseSensitive: false, multiLine: true),"");

        content = content.replaceAll(new RegExp(r"^",caseSensitive: false, multiLine: true),"    ");

        // YAML-Block
        content = content.replaceFirst(
            new RegExp(
                r"(?:([^~]*))~*$[\n\r]",
                multiLine: true, caseSensitive: false),"");

        // Mustache-Block (not called - just to remember)
//        void _removeMustacheBlock() {
//            content = content.replaceAll(
//                new RegExp(
//                    // switches for mustache-delimiter
//                    r"(?:(\{\{= \| \| =\}\})|(\|= \{\{ \}\} =\|))",
//                    multiLine: true, caseSensitive: false),"");
//
//            content = content.replaceAll(
//                new RegExp(
//                    // Mustache comment
//                    r"\{\{\![^}]*\}\}",
//                    multiLine: true, caseSensitive: false),"");
//        }

        //content = content.replaceAll(new RegExp(r"^",caseSensitive: false, multiLine: true),"    ");

        final StringBuffer buffer = new StringBuffer();

        buffer.writeln('<section class="demo-section demo-section--${sample.name} demo-page--${sample.name}">');
        buffer.writeln('    <div id="usage" class="mdl-include mdl-js-include" data-url="views/usage/${sample.name}.html">');
        buffer.writeln("        Loading...");
        buffer.writeln('    </div>');
        buffer.writeln(content);
        buffer.writeln('</section>');

        // remove blank lines
        content = buffer.toString().replaceAll(new RegExp(r"(?:(^\s*\n){1})",multiLine: true),"");
        targetSample.writeAsStringSync(content);

//        if(sample.name != "typography") {
//            Utils.optimizeHeaderTags(targetSample);
//        }
    }

    void _createUsageContentInStyleguide(final Sample sample) {
        Validate.notNull(sample);

        final Directory targetUsageDir = new Directory("${config.samplesdir}/styleguide/.sitegen/html/_content/views/usage");
        final File targetSample = new File("${targetUsageDir.path}/${sample.name}.html");
        if(targetSample.existsSync()) {
            // log.fine("${targetSample.path} already exists!");
            return;
        }

        final StringBuffer buffer = new StringBuffer();

        buffer.writeln("template: usage");
        buffer.writeln("");
        buffer.writeln("dart: ->usage.${sample.name}.dart");
        buffer.writeln("html: ->usage.${sample.name}.html");
        buffer.writeln("readme: ->usage.${sample.name}.readme");
        buffer.writeln("");
        buffer.writeln("component: ${sample.name}");
        buffer.writeln("~~~");

        targetSample.writeAsStringSync(buffer.toString());
    }

    void _createDartPartialInStyleguide(final Sample sample) {
        Validate.notNull(sample);

        final Directory targetUsageDir = new Directory("${config.samplesdir}/styleguide/.sitegen/html/_partials/usage/${sample.name}");
        if(!targetUsageDir.existsSync()) {
            targetUsageDir.createSync(recursive: true);
        }

        final srcDart = new File("${config.samplesdir}/${sample.dirname}/web/main.dart");
        if(!srcDart.existsSync()) {
            log("${srcDart.path} does not exists!");
            return;
        }

        final targetDart = new File("${targetUsageDir.path}/dart.html");

        String content = srcDart.readAsStringSync();
        if(content.contains("@MdlComponentModel")) {
            final int index = content.indexOf("\@MdlComponentModel");
            content = "import 'package:mdl/mdl.dart';\nimport 'package:mdl/mdlobservable.dart';\n\n" +
                content.substring(index);

            content = content.replaceAll(new RegExp(r"void configLogging\(\) {(?:[^}]|\n|\r)*?}",multiLine: true),"");

        } else {
            content = content.replaceAll(new RegExp(r"(?:.|\n|\r)*main\(\)",multiLine: true),"main()");

            final StringBuffer buffer = new StringBuffer();
            int counter = 0;

            buffer.writeln("import 'package:mdl/mdl.dart';");
            buffer.writeln("\n");
            for(int index = 0;index < content.codeUnits.length;index++) {
                final int unit = content.codeUnitAt(index);
                final String char = new String.fromCharCode(unit);

                buffer.writeCharCode(unit);
                if(char == "{") {
                    counter++;
                } else if(char == "}") {
                    counter--;
                    if(counter == 0) {
                        break;
                    }
                }

                //log(char);
            };
            content = buffer.toString();
        }

        content = content.replaceFirst(new RegExp(r".*configLogging\(\);\n\n*",multiLine: true),"");

        //log(new HtmlEscape().convert(buffer.toString()));
        targetDart.writeAsStringSync(new HtmlEscape().convert(content).replaceAll("{","&#123;").replaceAll("}","&#125;"));
    }

    void _createHtmlPartialInStyleguide(final Sample sample, { final List<String> samplesToExclude: const [] }) {
        Validate.notNull(sample);

        final Directory targetUsageDir = new Directory("${config.samplesdir}/styleguide/.sitegen/html/_partials/usage/${sample.name}");
        if(!targetUsageDir.existsSync()) {
            targetUsageDir.createSync(recursive: true);
        }

        final srcHtml = new File("${config.samplesdir}/styleguide/.sitegen/html/_content/views/${sample.name}.html");
        if(!srcHtml.existsSync()) {
            log("${srcHtml.path} does not exists!");
            return;
        }

        final targetHtml = new File("${targetUsageDir.path}/html.html");
        if(targetHtml.existsSync() && samplesToExclude.contains(sample.name)) {
            return;
        }

        String content = srcHtml.readAsStringSync();
        content = content.replaceFirst(new RegExp(r"<section[^>]*>.*\n*",multiLine: true),"");
        content = content.replaceFirst(new RegExp(r"</section[^>]*>\n*",multiLine: true),"");
        content = content.replaceFirst(new RegExp(r'<div id="usage"(?:.|\n|\r)*?</div>',multiLine: true),"");
        content = content.replaceAll(new RegExp(r"^[ ]{4}",multiLine: true),"");
        content = content.replaceAll(new RegExp(r"^\s*[\n\r]",multiLine: true),"");

        targetHtml.writeAsStringSync(new HtmlEscape().convert(content));
    }

    void _createReadmePartialInStyleguide(final Sample sample) {
        Validate.notNull(sample);

        final Directory targetUsageDir = new Directory("${config.samplesdir}/styleguide/.sitegen/html/_partials/usage/${sample.name}");
        if(!targetUsageDir.existsSync()) {
            targetUsageDir.createSync(recursive: true);
        }

        String content = "";
        final srcReadme = new File("${config.samplesdir}/${sample.dirname}/web/README.md");
        final srcReadmeTemplate = new File(config.readmetemplate);
        final targetReadme = new File("${targetUsageDir.path}/readme.html");

        if(!srcReadme.existsSync()) {
            content = srcReadmeTemplate.readAsStringSync();
            content = content.replaceAll('{{sample}}',sample.name);
            targetReadme.writeAsStringSync(content);
        } else {

            final ProcessResult result = Process.runSync('pandoc',
            [ srcReadme.path, "-f", "markdown_github", "-t", "html", "-o", targetReadme.path]);

            if(result.exitCode != 0) {
                log(result.stderr);
            } else {
                // Utils.optimizeHeaderTags(targetReadme);
            }
        }
    }
}