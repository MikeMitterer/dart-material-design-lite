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

class Styleguide {

    void generate(final Sample sample) {
        final Sample sampleStyleguide = samples.firstWhere((final Sample sample) => sample.type == Type.Styleguide);

        final String sampleName = sample.name;

        _copyDemoCssToStyleguide(sampleName, dir,config.samplesdir,samplesToExclude: [ "layout" ]);
        _copySampleViewToStyleguide(sampleName, dir,config.samplesdir,samplesToExclude: [ "layout" ]);
        _createUsageContentInStyleguide(sampleName, dir,config.samplesdir);
        _createDartPartialInStyleguide(sampleName, dir,config);
        _createHtmlPartialInStyleguide(sampleName, dir,config,samplesToExclude: [ "layout" ]);
        _createReadmePartialInStyleguide(sampleName, dir,config);
    }

    // -- private -------------------------------------------------------------

    /// {sassDir} -> lib/sass/accordion
    void _copyDemoCssToStyleguide(final String sampleName,final Directory sassDir,final String samplesDir,
                                  { final List<String> samplesToExclude: const [] }) {
        Validate.notBlank(sampleName);
        Validate.notNull(sassDir);
        Validate.notBlank(samplesDir);

        final File srcScss = new File("${sassDir.path}/demo.scss");
        final Directory targetScssDir = new Directory("${samplesDir}/styleguide/web/assets/styles/_demo");
        final File targetScss = new File("${targetScssDir.path}/_${sampleName}.scss");

        if(!srcScss.existsSync()) {
            return;
        }

        if(!targetScssDir.existsSync()) {
            targetScssDir.createSync(recursive: true);
        }

        if(targetScss.existsSync() && samplesToExclude.contains(sampleName)) {
            return;
        }

        // log.fine("Coping CSS's to styleguide $sampleName: ${targetScss.path}");

        String content = srcScss.readAsStringSync();
        content = content.replaceAll(new RegExp(r"@import[^;]*;(\n|\r)*",caseSensitive: false, multiLine: true),"");

        targetScss.writeAsStringSync(content);
    }

    void _copySampleViewToStyleguide(final String sampleName,final Directory sassDir,final String samplesDir,
                                     { final List<String> samplesToExclude: const [] }) {
        Validate.notBlank(sampleName);
        Validate.notNull(sassDir);
        Validate.notBlank(samplesDir);

        final File secSampleOrig = new File("${sassDir.path}/demo.html");
        final File srcSampleDart = new File("${sassDir.path}/demo.dart.html");
        final File srcSample = srcSampleDart.existsSync() ? srcSampleDart : secSampleOrig;

        final Directory targetSampleDir = new Directory("${samplesDir}/styleguide/.sitegen/html/_content/views");
        final File targetSample = new File("${targetSampleDir.path}/${sampleName}.html");

        if(!srcSample.existsSync()) {
            return;
        }

        if(!targetSampleDir.existsSync()) {
            targetSampleDir.createSync(recursive: true);
        }

        if(targetSample.existsSync() && samplesToExclude.contains(sampleName)) {
            return;
        }

        // log.fine("Coping view to styleguide $sampleName: ${targetSample.path}");

        String content = srcSample.readAsStringSync();

        content = content.replaceFirstMapped(
            new RegExp(
                r"(?:.|\n|\r)*" +
                r"<body[^>]*>([^<]*(?:(?!<\/?body)<[^<]*)*)<\/body[^>]*>" +
                r"(?:.|\n|\r)*",
                multiLine: true, caseSensitive: false),
                (final Match m) {

                return '${m[1]}';
            });

        content = content.replaceAll(new RegExp(r"<script[^>]*>.*</script>(?:\n|\r)*",caseSensitive: false, multiLine: true),"");
        content = content.replaceAll(new RegExp(r".*<!--[^>]*>.*(?:\n|\r)*",caseSensitive: false, multiLine: true),"");

        content = content.replaceAll(new RegExp(r"^",caseSensitive: false, multiLine: true),"    ");

        final StringBuffer buffer = new StringBuffer();

        buffer.writeln('<section class="demo-section demo-section--$sampleName">');
        buffer.writeln('    <div id="usage" class="mdl-include mdl-js-include" data-url="views/usage/$sampleName.html">');
        buffer.writeln("        Loading...");
        buffer.writeln('    </div>');
        buffer.writeln(content);
        buffer.writeln('</section>');

        targetSample.writeAsStringSync(buffer.toString());
        Utils.optimizeHeaderTags(targetSample);
    }

    void _createUsageContentInStyleguide(final String sampleName,final Directory sassDir,final String samplesDir) {
        Validate.notBlank(sampleName);
        Validate.notNull(sassDir);
        Validate.notBlank(samplesDir);

        final Directory targetUsageDir = new Directory("${samplesDir}/styleguide/.sitegen/html/_content/views/usage");
        final File targetSample = new File("${targetUsageDir.path}/${sampleName}.html");
        if(targetSample.existsSync()) {
            // log.fine("${targetSample.path} already exists!");
            return;
        }

        final StringBuffer buffer = new StringBuffer();

        buffer.writeln("template: usage");
        buffer.writeln("");
        buffer.writeln("dart: ->usage.${sampleName}.dart");
        buffer.writeln("html: ->usage.${sampleName}.html");
        buffer.writeln("readme: ->usage.${sampleName}.readme");
        buffer.writeln("");
        buffer.writeln("component: ${sampleName}");
        buffer.writeln("~~~");

        targetSample.writeAsStringSync(buffer.toString());
    }

    void _createDartPartialInStyleguide(final String sampleName,final Directory sassDir,final Config config) {
        Validate.notBlank(sampleName);
        Validate.notNull(sassDir);
        Validate.notNull(config);

        final Directory targetUsageDir = new Directory("${config.samplesdir}/styleguide/.sitegen/html/_partials/usage/${sampleName}");
        if(!targetUsageDir.existsSync()) {
            targetUsageDir.createSync(recursive: true);
        }

        final srcDart = new File("${config.samplesdir}/${sampleName}/web/main.dart");
        if(!srcDart.existsSync()) {
            log("${srcDart.path} does not exists!");
            return;
        }

        final targetDart = new File("${targetUsageDir.path}/dart.html");

        String content = srcDart.readAsStringSync();
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
        content = content.replaceFirst(new RegExp(r".*configLogging\(\);\n\n*",multiLine: true),"");

        //log(new HtmlEscape().convert(buffer.toString()));
        targetDart.writeAsStringSync(new HtmlEscape().convert(content));
    }

    void _createHtmlPartialInStyleguide(final String sampleName,final Directory sassDir,final Config config,
                                        { final List<String> samplesToExclude: const [] }) {
        Validate.notBlank(sampleName);
        Validate.notNull(sassDir);
        Validate.notNull(config);

        final Directory targetUsageDir = new Directory("${config.samplesdir}/styleguide/.sitegen/html/_partials/usage/${sampleName}");
        if(!targetUsageDir.existsSync()) {
            targetUsageDir.createSync(recursive: true);
        }

        final srcHtml = new File("${config.samplesdir}/styleguide/.sitegen/html/_content/views/${sampleName}.html");
        if(!srcHtml.existsSync()) {
            log("${srcHtml.path} does not exists!");
            return;
        }

        final targetHtml = new File("${targetUsageDir.path}/html.html");
        if(targetHtml.existsSync() && samplesToExclude.contains(sampleName)) {
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

    void _createReadmePartialInStyleguide(final String sampleName,final Directory sassDir,final Config config) {
        Validate.notBlank(sampleName);
        Validate.notNull(sassDir);
        Validate.notNull(config);

        final Directory targetUsageDir = new Directory("${config.samplesdir}/styleguide/.sitegen/html/_partials/usage/${sampleName}");
        if(!targetUsageDir.existsSync()) {
            targetUsageDir.createSync(recursive: true);
        }

        String content = "";
        final srcReadme = new File("${config.samplesdir}/${sampleName}/web/README.md");
        final srcReadmeTemplate = new File(config.readmetemplate);
        final targetReadme = new File("${targetUsageDir.path}/readme.html");

        if(!srcReadme.existsSync()) {
            content = srcReadmeTemplate.readAsStringSync();
            content = content.replaceAll('{{sample}}',sampleName);
            targetReadme.writeAsStringSync(content);
        } else {

            final ProcessResult result = Process.runSync('pandoc',
            [ srcReadme.path, "-f", "markdown_github", "-t", "html", "-o", targetReadme.path]);

            if(result.exitCode != 0) {
                log(result.stderr);
            } else {
                Utils.optimizeHeaderTags(targetReadme);
                log("    ${targetReadme.path} created...");
            }
        }
    }
}