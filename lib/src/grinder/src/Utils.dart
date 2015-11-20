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

class Utils {

    static String genMaterialCSS() {
        final String sassDir = config.sassdir;

        final File srcScss = new File("${sassDir}/material-design-lite.scss");
        final File targetCss = new File("${sassDir}/material.css");

        //log("${srcScss.path} -> ${targetCss.path}");
        sasscAndAutoPrefix(srcScss,targetCss,useSass: false, minify: true);

        return targetCss.path;
    }

    static String genSplashScreenCSS() {
        final String sassDir = config.sassdir;

        final File srcScss = new File("${sassDir}/splashscreen/dots.scss");
        final File targetCss = new File("${sassDir}/splashscreen/dots.css");

        sasscAndAutoPrefix(srcScss,targetCss,useSass: false, minify: true);

        return targetCss.path;
    }

    static String genFontsCSS() {
        final String fontsDir = config.fontsdir;

        final File srcScss = new File("${fontsDir}/fonts.scss");
        final File targetCss = new File("${fontsDir}/fonts.css");

        sasscAndAutoPrefix(srcScss,targetCss,useSass: false, minify: true);

        return targetCss.path;
    }

    static List<String> genPredefLayoutsCSS() {
        final String layoutsDir = config.layoutsdir;
        final List<String> layouts = <String>[ "2col-header-footer-props" ];
        final List<String> result = [];

        layouts.forEach((final String layout) {
            final File srcScss = new File("${layoutsDir}/$layout/$layout.scss");
            final File targetCss = new File("${layoutsDir}/$layout.css");

            sasscAndAutoPrefix(srcScss,targetCss,useSass: false, minify: true);

            result.add(targetCss.path);
        });


        return result;
    }

    static void sasscAndAutoPrefix(final File targetScss,final File targetCss,
                             { final bool useSass: false, final bool minify: false, final bool prefix: true }) {

        Validate.notNull(targetScss);
        Validate.notNull(targetCss);

        final String baseCss = "${Path.dirname(targetCss.path)}/${Path.basenameWithoutExtension(targetCss.path)}";
        final String sassCompiler = useSass ? "sass" : "sassc";

        ProcessResult result = Process.runSync(sassCompiler, [ targetScss.path, targetCss.path]);

        if(result.exitCode != 0) {
            log(result.stderr);
        } else {
            //log("    ${targetCss.path} created...");
        }

        if(prefix) {
            final ProcessResult resultPrefixer = Process.runSync('autoprefixer', [ targetCss.path]);
            if(resultPrefixer.exitCode != 0) {
                log(resultPrefixer.stderr);
            } else {
                //log("    ${targetCss.path} prefixed...");
            }
        }

        if(minify) {
            final String targetMinimize = "${baseCss}.min.css";
            final ProcessResult resultMinimize = Process.runSync("minify", [ "--output", targetMinimize, targetCss.path ]);

            if(resultMinimize.exitCode != 0) {
                log(resultMinimize.stderr);
            } else {
                //log("    ${targetMinimize} created...");
            }
        }
    }

    static void optimizeHeaderTags(final File htmlDemo) {
        Validate.notNull(htmlDemo);

        String content = htmlDemo.readAsStringSync();

        content = content.replaceAll("<h2","<h5");
        content = content.replaceAll("</h2>","</h5>");
        content = content.replaceAll("<h3","<h5");
        content = content.replaceAll("</h3>","</h5>");
        content = content.replaceAll("<h1","<h4");
        content = content.replaceAll("</h1>","</h4>");

        htmlDemo.writeAsStringSync(content);
    }


}