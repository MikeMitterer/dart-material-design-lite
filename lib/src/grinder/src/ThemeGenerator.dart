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

class ThemeGenerator {
    void generate() {

        final Directory dirThemes = new Directory(config.themesdir);
        if(!dirThemes.existsSync()) {
            dirThemes.createSync(recursive: true);
        }

        final Directory dirGitThemes = new Directory(config.gitthemesdir);

        final File templateFile = new File(config.scsstemplate);
        final String template = templateFile.readAsStringSync();

        final List<String> colors = [ "red", "pink", "purple", "deep-purple", "indigo", "blue", "light-blue",
        "cyan", "teal", "green", "light-green", "lime", "yellow", "amber", "orange", "deep-orange", "brown",
        "grey", "blue-grey"];

        int counter = 0;
        final StringBuffer buffer = new StringBuffer();
        buffer.writeln("[");

        colors.forEach((final String primaryColor) => colors.forEach((final String accentColor) {
            if(primaryColor != accentColor) {
                final String themeFolder = "${primaryColor.replaceAll("-","_")}-${accentColor.replaceAll("-","_")}";

                log("Theme #${counter + 1} - Primary: $primaryColor, Accent: $accentColor");
                _createTheme(primaryColor,accentColor,themeFolder,template,dirThemes,dirGitThemes);

                buffer.writeln('{ "primary": "$primaryColor", "accent": "$accentColor", "theme": "${themeFolder}" },');
                counter++;
            }
        }));

        buffer.writeln("]");
        final File jsonFile = new File("${config.themesdir}/themes.json");
        jsonFile.writeAsStringSync(buffer.toString());
    }

    // -- private -------------------------------------------------------------

    void _createTheme(final String primaryColor,final String accentColor,final String themeFolder,final  String template,final  Directory dirThemes,final Directory dirGitThemes) {
        Validate.notBlank(primaryColor);
        Validate.notBlank(accentColor);
        Validate.notBlank(themeFolder);
        Validate.notBlank(template);
        Validate.notNull(dirThemes);
        Validate.notNull(dirGitThemes);

        final Directory dirTheme = new Directory("${dirThemes.path}/${themeFolder}");
        if(!dirTheme.existsSync()) {
            dirTheme.createSync(recursive: true);
        }

        final Directory dirGitTheme = new Directory("${dirGitThemes.path}/${themeFolder}");
        if(!dirGitTheme.existsSync()) {
            dirGitTheme.createSync(recursive: true);
        }

        final File scssFile = new File("${dirTheme.path}/material-design-lite.scss");
        final File cssFile = new File("${dirGitTheme.path}/material.css");

        scssFile.writeAsStringSync(template.replaceAll("{{primary}}",primaryColor).replaceAll("{{accent}}",accentColor));

        Utils.sasscAndAutoPrefix(scssFile,cssFile,useSass: false, minify: true);
    }
}