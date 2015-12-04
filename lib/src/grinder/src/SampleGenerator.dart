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

class SampleGenerator {

    void generate(final Sample sample) {

        _createExamplesDir();
        _createSampleDir(sample);
        _createSitegenDir(sample);
        _createWebDir(sample);
        _createPackagesFolder(sample);
        _writeYaml(sample);

        _copyDemoFiles(sample);
        _updateYamlBlock(sample);
        _copyReadme(sample);
    }

    // -- private -------------------------------------------------------------

    void _copyDemoFiles(final Sample sample) {
        final Directory webDir = new Directory("${config.samplesdir}/${sample.dirname}/web");
        final Directory sitegenDir = new Directory("${config.samplesdir}/${sample.dirname}/.sitegen/html/_content");

        if(sample.hasDemoHtml) {

            File srcHtmlDemo;
            if(!sample.hasOwnDemoHtml) {
                srcHtmlDemo = new File("${config.mdldartdir}/${config.demobase}/${sample.name}/demo.html");
            } else {
                srcHtmlDemo = new File("${webDir.path}/index.html");
            }

            final String content = srcHtmlDemo.readAsStringSync();
            final File sitegenIndexHtml = new File("${sitegenDir.path}/index.html");
            final File contentTemplateFile = new File("${config.contenttemplate}");

            String contentTemplate = contentTemplateFile.readAsStringSync();

            final RegExp regexp = new RegExp(r"<body[^>]*>([^<]*(?:(?!<\/?body)<[^<]*)*)<\/body[^>]*>",caseSensitive: false);
            final bool hasBodyContent = regexp.hasMatch(content);

            String bodyContent = "";
            if(hasBodyContent) {
                final Match match = regexp.firstMatch(content);
                bodyContent = match.group(1);
            } else {
                bodyContent = content;
            }

            contentTemplate = contentTemplate.replaceAll("{{content}}",bodyContent);

            if(!sample.hasOwnDemoHtml || !sitegenIndexHtml.existsSync()) {
                contentTemplate = _commentOutScript(contentTemplate);
                contentTemplate = _removeLoadingBlock(contentTemplate);
                contentTemplate = _removeDemoPageClass(sample,contentTemplate);
                contentTemplate = _removeUnnecessaryBlanks(contentTemplate);
                sitegenIndexHtml.writeAsStringSync(contentTemplate);
            }

//            if(sample.name != "typography") {
//                Utils.optimizeHeaderTags(sitegenIndexHtml);
//            }

            if(!sample.hasOwnDartMain) {
                final File targetDartMain = new File("${webDir.path}/main.dart");
                final File srcTemplateDartMain = new File("${config.maintemplate}");

                srcTemplateDartMain.copySync(targetDartMain.path);
            }
            // log.fine("    ${targetDemo.path} created...");
        }

        if(sample.type == Type.Core) {
            final File srcCss = new File("${config.demobase}/${sample.name}/demo.css");
            final File targetCss = new File("${webDir.path}/demo.orig.css");

            if(srcCss.existsSync()) {
                srcCss.copySync(targetCss.path);
            } else {
                if(targetCss.existsSync()) {
                    targetCss.deleteSync();
                }
            }
        }

        final File targetScss = new File("${webDir.path}/demo.scss");
        final File targetCss = new File("${webDir.path}/demo.css");

        if(!targetScss.existsSync()) {
            targetScss.createSync(recursive: true);
            targetScss.writeAsStringSync(".demo-page--${sample.name}, .demo-section--${sample.name} {\n}");
        }
        Utils.sasscAndAutoPrefix(targetScss,targetCss);

        if(sample.hasStyle && sample.type == Type.Core) {
            _copySubdirs(new File("${config.mdldartdir}/${config.demobase}/${sample.name}"),new File(webDir.path));
        }
    }

    void _updateYamlBlock(final Sample sample) {
        final Directory sitegenDir = new Directory("${config.samplesdir}/${sample.dirname}/.sitegen/html/_content");
        final File sitegenIndexHtml = new File("${sitegenDir.path}/index.html");
        final File contentTemplateFile = new File("${config.contenttemplate}");

        String contentTemplate = contentTemplateFile.readAsStringSync();
        String content = sitegenIndexHtml.readAsStringSync();

        // Remove YAML-Block
        content = content.replaceFirst(
            new RegExp(
                r"(?:([^~]*))~*$[\n\r]",
                multiLine: true, caseSensitive: false),"");

        contentTemplate = contentTemplate.replaceAll("{{title}}",sample.name.toUpperCase());
        contentTemplate = contentTemplate.replaceAll("{{prefix}}",sample.prefix);
        contentTemplate = contentTemplate.replaceAll("{{samplename}}",sample.name);
        contentTemplate = contentTemplate.replaceAll("{{content}}",content);

        sitegenIndexHtml.writeAsStringSync(contentTemplate);
    }

    String _commentOutScript(final String content) {
        final RegExp regexp = new RegExp(r"(<script[^>]*>" + "[^<]*(?:(?!<\/?script)<[^<]*)*" + "<\/script[^>]*>)",caseSensitive: false);
        String retVal = content;

        if(regexp.hasMatch(content)) {
            regexp.allMatches(content).forEach((final Match match) {
                retVal = retVal.replaceAll(match.group(0),"<!-- ${match.group(0)} -->");
            });
            // return content.replaceAll(regexp,"<!-- here was a script x -->");
        }

        // remove double comments...
        retVal = retVal.replaceAll("<!-- <!--","<!--");
        retVal = retVal.replaceAll("--> -->","-->");

        return retVal;
    }

    String _removeLoadingBlock(final String content) {
        String retVal = content.replaceFirst('<div class="loading">Loading...</div>\n',"");
        return retVal;
    }

    String _removeDemoPageClass(final Sample sample,final String content) {
        return content.replaceAll(new RegExp("[ ]+demo-page--${sample.name}",multiLine: true),"");
    }

    String _removeUnnecessaryBlanks(final String content) {
        // if there is a blank line between ~~~~ and the the first tag remove it.
        String retVal = content.replaceFirst(new RegExp(r"~~~$[\n\r]^(?:(\s)*)$\n",multiLine: true),"\n");

        // move comments to the left
        retVal = retVal.replaceAll(new RegExp(r"^\s+<!--",multiLine: true),"<!--");
        return retVal;
    }

    void _createPackagesFolder(final Sample sample) {
        final Directory webDir = new Directory("${config.samplesdir}/${sample.dirname}/web");

        final Link targetPackages = new Link("${webDir.path}/packages");
        final File srcPackages = new File("../../../packages");

        if(!targetPackages.existsSync()) {
            targetPackages.createSync(srcPackages.path);
            // log.fine("    ${srcPackages.path} created...");
        }
    }

    void _createWebDir(final Sample sample) {
        final Directory webDir = new Directory("${config.samplesdir}/${sample.dirname}/web");

        webDir.createSync();
        //log("${webDir.path} created...");
    }

    void _createSampleDir(final Sample sample) {
        final Directory sampleDir = new Directory("${config.samplesdir}/${sample.dirname}");
        final Directory backupDir = new Directory("${config.samplesdir}/${sample.dirname}.backup");

        if(sample.hasOwnDemoHtml || sample.hasOwnDartMain) {
            return;
        }

        if(sampleDir.existsSync() && backupDir.existsSync()) {
            backupDir.deleteSync(recursive: true);
            // log.fine("${backupDir.path} removed...");
        }
        if(sampleDir.existsSync() && config.mkbackup ) {
            sampleDir.renameSync(backupDir.path);
            // log.fine("made ${sampleDir.path}} -> ${backupDir.path} backup...");

        }
        //else if(sampleDir.existsSync()) {
        //    sampleDir.deleteSync(recursive: true);
        //    // log.fine("${sampleDir.path} deleted...");
        //}

        if(!sampleDir.existsSync()) {
            sampleDir.createSync();
        }
        //log("${sampleDir.path} created...");
    }

    void _createSitegenDir(final Sample sample) {
        final Directory sitegenDir = new Directory("${config.samplesdir}/${sample.dirname}/.sitegen/html/_content");

        if(!sitegenDir.existsSync()) {
            sitegenDir.createSync(recursive: true);
        }

        final File srcSite = new File(config.sitetemplate);
        final File targetSite = new File(("${config.samplesdir}/${sample.dirname}/.sitegen/site.yaml"));

        if(!targetSite.existsSync()) {
            srcSite.copySync(targetSite.path);
        }
    }

    void _createExamplesDir() {
        final Directory samplesDir = new Directory(config.samplesdir);
        if(!samplesDir.existsSync()) {
            samplesDir.createSync();
        }
    }

    void _copyReadme(final Sample sample) {
        Validate.notNull(sample);

        final String sampleName = sample.name;

        final Directory webDir = new Directory("${config.samplesdir}/${sample.dirname}/web");
        final File srcREADME = new File("${config.sassdir}/${sampleName}/${sample.readme}");
        final File targetREADME = new File("${webDir.path}/${sample.readme}");

        if(srcREADME.existsSync()) {
            // log.fine("    ${srcREADME.path} -> ${targetREADME.path} copied...");
            srcREADME.copySync(targetREADME.path);

            String content = targetREADME.readAsStringSync();
            content = content.replaceAll(new RegExp(r"##Basic use(?:.|\n|\r)*?##",multiLine: true),"##");
            content = content.replaceAll("www.github.com/google/material-design-lite/src/$sampleName/demo.html",
            "https://github.com/MikeMitterer/dart-material-design-lite/tree/mdl/${config.samplesdir}/$sampleName");

            content = content.replaceAll("sourceCode html","prettyprint linenums lang-html");

            targetREADME.writeAsStringSync(content);
        }
    }

    void _writeYaml(final Sample sample) {
        Validate.notNull(sample);

        final File srcYaml = new File("${config.yamltemplate}");
        final File targetYaml = new File("${config.samplesdir}/${sample.dirname}/pubspec.yaml");

        if(sample.hasOwnPubSpec) {
            return;
        }

        if(targetYaml.existsSync()) {
            targetYaml.deleteSync();
        }
        final String contents = srcYaml.readAsStringSync().replaceAll("{{samplename}}",sample.name.replaceAll("-","_"));
        targetYaml.writeAsStringSync(contents);
    }

    void _copySubdirs(final File sourceDir, final File targetDir, { int level: 0 } ) {
        Validate.notNull(sourceDir);
        Validate.notNull(targetDir);

        // log.fine("Start!!!! ${sourceDir.path} -> ${targetDir.path} , Level: $level");
        final Directory directory = new Directory(sourceDir.path);
        directory.listSync(recursive: false).where((final FileSystemEntity entity) {
            // log("Check ${entity.path}");

            if(entity.path.startsWith(".") || entity.path.contains("/.")) {
                return false;
            }
            if(FileSystemEntity.isLinkSync(entity.path)) {
                return false;
            }

            if(entity.path.endsWith(".js") ||
            entity.path.endsWith("/demo.html") ||
            entity.path.endsWith("/demo.orig.html") ||
            entity.path.endsWith("/demo.dart.html") ||
            entity.path.endsWith("/demo.scss") ||
            entity.path.endsWith("/demo.orig.scss") ||
            entity.path.endsWith("/demo.dart.scss") ||
            entity.path.contains("snippet")
            ) {
                return false;
            }

            return true;

        }).forEach((final FileSystemEntity entity) {
            //log("D ${entity.path}");

            if (FileSystemEntity.isDirectorySync(entity.path)) {
                //final File src = new File(entity.path);
                final File target = new File(entity.path.replaceFirst(sourceDir.path,""));
                _copySubdirs(new File("${entity.path}"),new File("${targetDir.path}${target.path}"),level: ++level);

            } else {
                if(level > 0) {
                    final File src = new File(entity.path);
                    final File target = new File("${targetDir.path}${entity.path.replaceFirst(sourceDir.path,"")}");
                    if(!target.existsSync()) {
                        target.createSync(recursive: true);
                    }
                    //log("    copy ${src.path} -> ${target.path} (Level $level)...");
                    src.copySync(target.path);
                }
            }
        });
    }

//    void _addDartMainToIndexHTML(final File indexFile) {
//        Validate.notNull(indexFile);
//        Validate.isTrue(indexFile.existsSync());
//
//        final List<String> lines = indexFile.readAsLinesSync();
//        final StringBuffer buffer = new StringBuffer();
//
//        bool commentLine = false;
//        lines.forEach((final String line) {
//            if(line.contains("<script")) {
//                commentLine = true;
//            }
//
//            if(commentLine || (line.contains("<script") && line.contains("</script"))) {
//                final String newline = "    <!-- ${line.trim()} -->";
//                buffer.writeln(newline);
//            }
//
//
//            else if(line.contains("</body>")) {
//                buffer.writeln('    <!-- start Autogenerated with gensamples.dart -->');
//                buffer.writeln('    <script type="application/dart" src="main.dart"></script>');
//                buffer.writeln('    <script type="text/javascript" src="packages/browser/dart.js"></script>');
//                buffer.writeln('    <!-- end Autogenerated with gensamples.dart -->');
//                buffer.writeln(line);
//            }
//            else {
//                buffer.writeln(line);
//            }
//
//            if(line.contains("</script")) {
//                commentLine = false;
//            }
//
//        });
//
//        final String style = """\t<style>
//            /* Autogenerated with gensamples.dart */
//            div.loading { display: none; }
//            body.mdl-upgrading > * { display: none; }
//            body.mdl-upgrading div.loading { display: block; }\n\t</style>""";
//
//        //final String newBody = '\t<body class="mdl-upgrading"> <div class="loading">Loading...</div>';
//
//        String contents = buffer.toString();
//        contents = contents.replaceFirst(new RegExp(r".*</head>"),"\n$style\n  </head>");
//
//        //contents = contents.replaceFirst(new RegExp(r".*<body>"),newBody);
//        contents = contents.replaceAllMapped(new RegExp(r'<body class="([^"]*)"[^>]*>'),
//            (final Match m) => '<body class="${m[1]} mdl-upgrading mdl-typography">  <div class="loading">Loading...</div>');
//
//        indexFile.writeAsStringSync(contents);
//    }

//    void _changeImportStatementInSassFile(final File scssFile,final String sampleName) {
//        Validate.notNull(scssFile);
//        Validate.isTrue(scssFile.existsSync());
//
//        final List<String> lines = scssFile.readAsLinesSync();
//        final StringBuffer contents = new StringBuffer();
//
//        lines.forEach((final String line) {
//            if(line.contains('@import "../mixins"')) {
//                final String newLine = '@import "packages/mdl/assets/styles/mixins/mixins";';
//                contents.writeln(newLine);
//
//            } else if(line.contains(new RegExp("@import [\"']{1}\\\.{2}"))) {
//                final String newline = line.replaceAllMapped(new RegExp("@import ([\"']){1}\\\.{2}/"),
//                    (final Match m) => "@import ${m[1]}packages/mdl/assets/styles/");
//
//                contents.writeln(newline);
//
//            } else if(line.contains(new RegExp("@import [\"']{1}"))) {
//                final String newline = line.replaceAllMapped(new RegExp("@import ([\"']){1}"),
//                    (final Match m) => "@import ${m[1]}packages/mdl/assets/styles/$sampleName/");
//
//                contents.writeln(newline);
//            }
//            else {
//                contents.writeln(line);
//            }
//        });
//
//        scssFile.writeAsStringSync(contents.toString());
//    }

//    void _addImportStatementInSassFile(final File scssFile) {
//        String content = scssFile.readAsStringSync();
//
//        content = '@import "packages/mdl/assets/styles/material-design-lite";\n\n' + content;
//        scssFile.writeAsStringSync(content);
//    }
}