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

class MergeMaster {

    void copyOrigFiles(final Sample sample) {
        Validate.isTrue(sample.type == Type.Core || sample.type == Type.Ignore);
        Validate.notNull(sample);

        final String mdlDir = config.mdldir;

        final Directory mdlSampleDir = new Directory("${mdlDir}/${sample.name}");
        final Directory mdlSnippetDir = new Directory("${mdlDir}/${sample.name}/snippets");
        final Directory sassDir = new Directory("${config.sassdir}/${sample.name}");
        final Directory demoBaseDir = new Directory("${config.demobase}/${sample.name}");
        final Directory demoBaseSnippetDir = new Directory("${config.demobase}/${sample.name}/snippets");

        if(!mdlSampleDir.existsSync()) {
            throw "${mdlSampleDir.path} does not exist!";
        }

        if(sample.hasDemoHtml) {
            demoBaseDir.createSync(recursive: true);
        }
        if(sample.hasSnippet) {
            if(demoBaseSnippetDir.existsSync()) {
                demoBaseSnippetDir.deleteSync(recursive: true);
            }
            demoBaseSnippetDir.createSync(recursive: true);
        }

        final File srcSCSS = new File("${mdlSampleDir.path}/${sample.scssFile}");
        final File targetSCSS = new File("${sassDir.path}/${sample.scssFileTarget}");
        srcSCSS.copySync(targetSCSS.path);

        if(sample.hasReadme) {
            final File srcReadme = new File("${mdlSampleDir.path}/${sample.readme}");
            final File targetReadme = new File("${sassDir.path}/${sample.readme}");
            srcReadme.copySync(targetReadme.path);
        }

        if(sample.hasDemoHtml) {
            final File srcDemoHtml = new File("${mdlSampleDir.path}/${sample.htmlDemo}");
            final File targetDemoHtml = new File("${demoBaseDir.path}/${sample.htmlDemo}");
            srcDemoHtml.copySync(targetDemoHtml.path);
        }

        if(sample.hasSnippet) {
            mdlSnippetDir.listSync(recursive: false).forEach((final FileSystemEntity entity) {
                final File src = new File(entity.path);
                final File target = new File(entity.path.replaceFirst(mdlSnippetDir.path,demoBaseSnippetDir.path));
                src.copySync(target.path);
                //log("${src.path} -> ${target.path}");
            });
        }

        if(sample.hasDemoCss) {
            final File srcCSS = new File("${mdlSampleDir.path}/${sample.cssDemo}");
            final File targetCSS = new File("${demoBaseDir.path}/${sample.cssDemo}");
            srcCSS.copySync(targetCSS.path);
        }

        if(sample.hasScript) {

            final File srcJS = new File("${mdlSampleDir.path}/${sample.jsFile}");
            final File targetJS = new File("${config.jsbase}/${sample.jsFile}");
            final File targetDemoJS = new File("${demoBaseDir.path}/${sample.jsFile}");
            final File targetConvertedJS = new File("${config.portbase}/${sample.convertedJSFile}");

            if(!srcJS.existsSync()) {
                throw "${srcJS.path} does not exist!";
            }

            srcJS.copySync(targetJS.path);
            srcJS.copySync(targetConvertedJS.path);

            if(sample.hasDemoHtml) {
                srcJS.copySync(targetDemoJS.path);
            }

            new JSConverter().convert(targetConvertedJS);
        }
    }

    void copyOrigExtraFiles() {

        final String sassDir = config.sassdir;
        final String mdlDir = config.mdldir;

        final Directory mdlSampleDir = new Directory("${mdlDir}");

        final File srcScss = new File("${mdlSampleDir.path}/_mixins.scss");
        final File targetScss = new File("${sassDir}/mixins/_mixins.orig.scss");

        // log.fine("mixins: ${srcScss.path} -> ${targetScss.path}");

        srcScss.copySync(targetScss.path);

        final File srcJS = new File("${mdlDir}/mdlComponentHandler.js");
        final File targetConvertedJS = new File("${config.portbase}/mdlComponentHandler.js.dart");

        srcJS.copySync(targetConvertedJS.path);
        new JSConverter().convert(targetConvertedJS);

        final File srcVariables = new File("${mdlDir}/_variables.scss");
        final File targetVariables = new File("${sassDir}/variables/_variables.orig.scss");

        srcVariables.copySync(targetVariables.path);

        final File srcFunctions = new File("${mdlDir}/_functions.scss");
        final File targetFunctions = new File("${sassDir}/variables/_functions.orig.scss");

        srcFunctions.copySync(targetFunctions.path);

        final File srcColordef = new File("${mdlDir}/_color-definitions.scss");
        final File targetColordev = new File("${sassDir}/palette/_color-definitions.orig.scss");

        srcColordef.copySync(targetColordev.path);
    }

    void genMaterialCSS() {
        final File srcScss = new File("${config.mdldir}/material-design-lite.scss");
        final File targetCss = new File("${config.demobase}/material.css");

        //log("${srcScss.path} -> ${targetCss.path}");
        Utils.sasscAndAutoPrefix(srcScss,targetCss,useSass: false, minify: true);
    }

    void copyDemoCSS() {
        final File src = new File("${config.mdldir}/demos.css");
        final File target = new File("${config.demobase}/demos.css");

        src.copySync(target.path);
    }

    // -- private -------------------------------------------------------------
}


