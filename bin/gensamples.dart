#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:args/args.dart';

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

import 'package:validate/validate.dart';

class Application {
    final Logger _logger = new Logger("gensamples.Application");

    static const _ARG_HELP          = 'help';
    static const _ARG_LOGLEVEL      = 'loglevel';
    static const _ARG_SETTINGS      = 'settings';
    static const _ARG_GENERATE      = 'gen';
    static const _ARG_MK_BACKUP     = 'makebackup';

    ArgParser _parser;

    Application() : _parser = Application._createOptions();

    void run(List<String> args) {

        try {
            final ArgResults argResults = _parser.parse(args);
            final Config config = new Config(argResults);

            _configLogging(config.loglevel);

            if (argResults[_ARG_HELP] || (config.dirstoscan.length == 0 && args.length == 0)) {
                _showUsage();
            }
            else if(argResults[_ARG_SETTINGS]) {
                _printSettings(config.settings);
            }
            else if(argResults[_ARG_GENERATE]) {
                final List<_LinkInfo> links = new List<_LinkInfo>();

                _iterateThroughDirSync(config.sassdir,(final File file) {
                    final String sampleName = file.parent.path.replaceFirst("${config.sassdir}/","");
                    //_logger.info("   Found: $file in $sampleName");

                    final Directory samples = new Directory(config.samplesdir);
                    if(!samples.existsSync()) {
                        samples.createSync();
                    }

                    final Directory sample = new Directory("${config.samplesdir}/${sampleName}");
                    final Directory backup = new Directory("${config.samplesdir}/${sampleName}.backup");
                    if(sample.existsSync() && backup.existsSync()) {
                        backup.deleteSync(recursive: true);
                        _logger.fine("${backup.path} removed...");
                    }
                    if(sample.existsSync() && config.mkbackup ) {
                        sample.renameSync(backup.path);
                        _logger.fine("made ${sample.path}} -> ${backup.path} backup...");
                    }

                    sample.createSync();
                    _logger.info("${sample.path} created...");

                    final File srcDemo = new File("${config.sassdir}/${sampleName}/demo.html");
                    final File srcScss = new File("${config.sassdir}/${sampleName}/demo.scss");
                    final File targetDemo = new File("${sample.path}/index.html");
                    final File targetScss = new File("${sample.path}/demo.scss");
                    final File targetCss = new File("${sample.path}/demo.css");

                    final File srcJs = new File("${config.sassdir}/${sampleName}/${sampleName}.js");
                    final File srcDartMain = new File("${config.maintemplate}");
                    final File targetDartMain = new File("${sample.path}/main.dart");
                    final File targetConvertedJS = new File("${sample.path}/_${sampleName}.js.dart");

                    final Link packages = new Link("${sample.path}/packages");
                    final File targetPackages = new File("../../packages");

                    links.add(new _LinkInfo(targetDemo.path,srcJs.existsSync()));

                    if(srcDemo.existsSync()) {
                        srcDemo.copySync(targetDemo.path);
                        _addDartMain(targetDemo);

                        if(!packages.existsSync()) {
                            packages.createSync(targetPackages.path);
                            _logger.fine("    ${targetPackages.path} created...");
                        }

                        _logger.fine("    ${targetDemo.path} created...");
                    }
                    if(srcScss.existsSync()) {
                        srcScss.copySync(targetScss.path);
                        _logger.fine("    ${targetScss.path} created...");
                        _changeImportStatement(targetScss,sampleName);

                        final ProcessResult result = Process.runSync('sassc', [targetScss.path, targetCss.path]);
                        if(result.exitCode != 0) {
                            _logger.severe(result.stderr);
                        } else {
                            _logger.fine("    ${targetCss.path} created...");
                        }

                        final ProcessResult resultPrefixer = Process.runSync('autoprefixer', [ targetCss.path]);
                        if(resultPrefixer.exitCode != 0) {
                            _logger.severe(resultPrefixer.stderr);
                        } else {
                            _logger.fine("    ${targetCss.path} prefixed...");
                        }
                    }

                    if(srcJs.existsSync()) {
                        _logger.fine("    ${srcDartMain.path} -> ${targetDartMain.path} copied...");
                        srcDartMain.copySync(targetDartMain.path);
                        srcJs.copySync(targetConvertedJS.path);
                        _Js2Dart(targetConvertedJS);
                    }

                });
                _writeIndexHtml(config,links);
            }
            else {
                _showUsage();
            }
        }

        on FormatException
        catch (error) {
            _showUsage();
        }
    }

    // -- private -------------------------------------------------------------
    void _Js2Dart(final File jsToConvert) {
        Validate.notNull(jsToConvert);
        Validate.notNull(jsToConvert.existsSync());

        final List<String> lines = jsToConvert.readAsLinesSync();
        final StringBuffer contents = new StringBuffer();
        bool isCommentTurnedOn = false;

        contents.writeln("import 'dart:html' as html;");
        contents.writeln("import 'dart:math' as Math;");
        contents.writeln();

        for(final String line in lines) {
            if(isCommentTurnedOn) {
                contents.writeln("// $line");
                continue;
            }
            if(line.contains("// in the global")) {
                isCommentTurnedOn = true;
                contents.writeln("// $line\n");
                continue;
            }

            if(line.contains("this.element_ = element;")) { continue; }
            if(line.contains("'use strict';")) { continue; }
            if(line.contains("* @private")) { continue; }
            if(line.contains("/**")) { continue; }
            if(line.contains(" */")) { continue; }

            String newLine = line.replaceAll("this.element_","element");
            newLine = newLine.replaceAll("this.CssClasses_.","_cssClasses.");
            newLine = newLine.replaceAll(".CssClasses_.","._cssClasses.");
            newLine = newLine.replaceAll(".classList.",".classes.");
            newLine = newLine.replaceAll(".appendChild(",".append(");
            newLine = newLine.replaceAll("this.Constant_.","_constant.");
            newLine = newLine.replaceAll("this.init()","init()");
            newLine = newLine.replaceAll("};","}");
            newLine = newLine.replaceAll("===","==");
            newLine = newLine.replaceAll(".bind(this)","");
            newLine = newLine.replaceAll("var ","final ");
            newLine = newLine.replaceAll("document.querySelector(","html.querySelector(");
            newLine = newLine.replaceAll("document.createElement('span')","new html.SpanElement()");
            newLine = newLine.replaceAll("document.createElement('div')","new html.DivElement()");
            newLine = newLine.replaceAll("document.getElementById","html.document.getElementById");
            newLine = newLine.replaceAll("if (element) {","if (element != null) {");
            newLine = newLine.replaceAll(".parentElement.",".parent.");

            if(newLine.contains("final ")) { contents.writeln(); }
            if(newLine.contains("= new html.")) { contents.writeln(); }
            if(newLine.contains("} else {")) { contents.writeln(); }

            newLine = newLine.replaceAllMapped(new RegExp('\s*([A-Z_]+):[ ]([0-9\-]+).*'),
                (final Match m) => "  final int ${m[1]} = ${m[2]};");

            newLine = newLine.replaceAllMapped(new RegExp("\s*([A-Z_]+):[ ]'([^']+)'.*"),
                (final Match m) => "  final String ${m[1]} = '${m[2]}';");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.CssClasses_ ="),
                (final Match m) => "class _${m[1]}CssClasses");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.Constant_ ="),
                (final Match m) => "class _${m[1]}Constant");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.Mode_ ="),
                (final Match m) => "class _${m[1]}Mode");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.([^_]+)(_*) = function\\(\\)"),
                (final Match m) => "/// $line\nvoid ${m[3]}${m[2]}()");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.([^_]+)(_*) = function\\(([^\\)]+)\\)"),
                (final Match m) => "/// $line\nvoid ${m[3]}${m[2]}(final ${m[4]})");

            newLine = newLine.replaceAll("(final event)","(final html.Event event)");

            newLine = newLine.replaceFirst(new RegExp("^ \\* "),"/// ");

            newLine = newLine.replaceAllMapped(new RegExp("this\\.([^_]+)_"),
                (final Match m) => "_${m[1]}");

            newLine = newLine.replaceAllMapped(new RegExp("\\.([a-zA-Z]+)_+(\\.|\\()"),
                (final Match m) => "._${m[1]}${m[2]}");

            newLine = newLine.replaceFirst(new RegExp("^function "),"/*function*/\nclass ");
            newLine = newLine.replaceAll(", function()",", /*function*/ ()");
            newLine = newLine.replaceAll("(function()","( /*function*/ ()");
            newLine = newLine.replaceAll(", function(e)",", /*function*/ (e)");
            newLine = newLine.replaceAll("= function()","= /*function*/ ()");

            if (line.contains(".addEventListener('click',")) {
                contents.writeln("\n\t// .addEventListener('click', -> .onClick.listen(<MouseEvent>);");
                newLine = newLine.replaceFirst(".addEventListener('click',",".onClick.listen(");
            }
            if (line.contains(".addEventListener('scroll',")) {
                contents.writeln("\n\t// .addEventListener('scroll', -- .onScroll.listen(<Event>);");
                newLine = newLine.replaceFirst(".addEventListener('scroll',",".onScroll.listen(");
            }
            if (line.contains(".addEventListener('change',")) {
                contents.writeln("\n\t// .addEventListener('change', -- .onChange.listen(<Event>);");
                newLine = newLine.replaceFirst(".addEventListener('change',",".onChange.listen(");
            }
            if (line.contains(".addEventListener('focus',")) {
                contents.writeln("\n\t// .addEventListener('focus', -- .onFocus.listen(<Event>);");
                newLine = newLine.replaceFirst(".addEventListener('focus',",".onFocus.listen(");
            }
            if (line.contains(".addEventListener('blur',")) {
                contents.writeln("\n\t// .addEventListener('blur', -- .onBlur.listen(<Event>);");
                newLine = newLine.replaceFirst(".addEventListener('blur',",".onBlur.listen(");
            }
            if (line.contains(".addEventListener('mouseup',")) {
                contents.writeln("\n\t// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);");
                newLine = newLine.replaceFirst(".addEventListener('mouseup',",".onMouseUp.listen(");
            }
            if (line.contains(".addEventListener('mouseenter',")) {
                contents.writeln("\n\t// .addEventListener('mouseenter', -- .onMouseEnter.listen(<MouseEvent>);");
                newLine = newLine.replaceFirst(".addEventListener('mouseenter',",".onMouseEnter.listen(");
            }
            if (line.contains(".addEventListener('mouseleave',")) {
                contents.writeln("\n\t// .addEventListener('mouseleave', -- .onMouseLeave.listen(<MouseEvent>);");
                newLine = newLine.replaceFirst(".addEventListener('mouseleave',",".onMouseLeave.listen(");
            }

            if( line.contains(new RegExp("^function [^{]+{"))) {
                final String className = line.replaceAllMapped(new RegExp("^function ([^\\(]+)\\(.*"),
                    (final Match m) => "${m[1]}");

                contents.writeln("class $className {\n");

                String params = line.replaceAllMapped(new RegExp("^function [^\\(]+(([^\\)]+)).*"),
                    (final Match m) => "${m[1]}");
                params = params.replaceFirst("(","");

                final List<String> ptemp = new List<String>();
                params.split(',').forEach((final String element) {
                    ptemp.add("this.${element.trim()}");
                    contents.writeln("    final ${element.trim()};");
                });

                contents.writeln();
                contents.writeln("    $className(${ptemp.join(",")});");
                continue;
            }

            newLine = newLine.replaceAll("this.","");

            contents.writeln(newLine);
        }

        jsToConvert.writeAsStringSync(contents.toString().replaceAll(new RegExp("\n{2,}"),"\n\n"));
    }

    void _writeIndexHtml(final Config config, final List<_LinkInfo> links) {
        Validate.notNull(config);
        Validate.notNull(links);

        final File srcIndexHtml = new File("${config.indextemplate}");
        final File targetIndexHtml = new File("${config.samplesdir}/index.html");
        if(targetIndexHtml.existsSync()) {
            targetIndexHtml.delete();
        }

        final String contents = srcIndexHtml.readAsStringSync();
        final StringBuffer buffer = new StringBuffer();
        links.forEach((final _LinkInfo linkinfo) {
            final String script = linkinfo.hasScript ? '<span class="script">[ with main.dart ]</span>' : '';
            final String link = linkinfo.link.replaceFirst("${config.samplesdir}/","");

            buffer.writeln('            <li><a href="${link}">${link}</a>$script</li>');
        });

        targetIndexHtml.writeAsString(contents.replaceFirst("{samples}",buffer.toString()));
    }

    void _addDartMain(final File indexFile) {
        Validate.notNull(indexFile);
        Validate.isTrue(indexFile.existsSync());

        final List<String> lines = indexFile.readAsLinesSync();
        final StringBuffer contents = new StringBuffer();

        lines.forEach((final String line) {
            if(line.contains("<script")) {
                final String newline = "    <!-- ${line.trim()} -->";
                contents.writeln(newline);

            } else if(line.contains("</body>")) {
                contents.writeln('    <!-- start Autogenerated with gensamples.dart -->');
                contents.writeln('    <script type="application/dart" src="main.dart"></script>');
                contents.writeln('    <script type="text/javascript" src="packages/browser/dart.js"></script>');
                contents.writeln('    <!-- end Autogenerated with gensamples.dart -->');
                contents.writeln(line);
            }
            else {
                contents.writeln(line);
            }
        });

        indexFile.writeAsStringSync(contents.toString());
    }

    void _changeImportStatement(final File scssFile,final String sampleName) {
        Validate.notNull(scssFile);
        Validate.isTrue(scssFile.existsSync());

        final List<String> lines = scssFile.readAsLinesSync();
        final StringBuffer contents = new StringBuffer();

        lines.forEach((final String line) {
            if(line.contains(new RegExp("@import [\"']{1}\\\.{2}"))) {
                final String newline = line.replaceAllMapped(new RegExp("@import ([\"']){1}\\\.{2}/"),
                (final Match m) => "@import ${m[1]}packages/wsk_material/sass/");

                contents.writeln(newline);

            } else if(line.contains(new RegExp("@import [\"']{1}"))) {
                final String newline = line.replaceAllMapped(new RegExp("@import ([\"']){1}"),
                    (final Match m) => "@import ${m[1]}packages/wsk_material/sass/$sampleName/");

                contents.writeln(newline);
            }
            else {
                contents.writeln(line);
            }
        });

        scssFile.writeAsStringSync(contents.toString());
    }

       /// Goes through the files
    void _iterateThroughDirSync(final String dir, void callback(final File file)) {
        _logger.info("Scanning: $dir");

        // its OK if the path starts with packages but not if the path contains packages (avoid recursion)
        final RegExp regexp = new RegExp("^/*packages/*");

        final Directory directory = new Directory(dir);
        if (directory.existsSync()) {
            directory.listSync(recursive: true).where((final FileSystemEntity entity) {
                _logger.fine("Entity: ${entity}");

                bool isUsableFile = (entity != null && FileSystemEntity.isFileSync(entity.path) &&
                    ( entity.path.endsWith(".dart") || entity.path.endsWith(".DART")) || entity.path.endsWith(".html") );

                if(!isUsableFile) {
                    return false;
                }
                if(entity.path.contains("packages")) {
                    // return only true if the path starts!!!!! with packages
                    return entity.path.contains(regexp);
                }

                return true;

            }).any((final File file) {
                //_logger.fine("  Found: ${file}");
                callback(file);
            });
        }
    }

    void _showUsage() {
        print("Usage: gensamples [options]");
        _parser.getUsage().split("\n").forEach((final String line) {
            print("    $line");
        });

        print("");
    }

    void _printSettings(final Map<String,String> settings) {
        Validate.notEmpty(settings);

        int getMaxKeyLength() {
            int length = 0;
            settings.keys.forEach((final String key) => length = max(length,key.length));
            return length;
        }

        final int maxKeyLeght = getMaxKeyLength();

        String prepareKey(final String key) {
            return "${key[0].toUpperCase()}${key.substring(1)}:".padRight(maxKeyLeght + 1);
        }

        print("Settings:");
        settings.forEach((final String key,final String value) {
            print("    ${prepareKey(key)} $value");
        });
    }

    static ArgParser _createOptions() {
        final ArgParser parser = new ArgParser()

            ..addFlag(_ARG_HELP,            abbr: 'h', negatable: false, help: "Shows this message")
            ..addFlag(_ARG_SETTINGS,        abbr: 's', negatable: false, help: "Prints settings")
            ..addFlag(_ARG_GENERATE,        abbr: 'g', negatable: false, help: "Generate samples")
            ..addFlag(_ARG_MK_BACKUP,       abbr: 'b', negatable: false, help: "Make backup")

            ..addOption(_ARG_LOGLEVEL,      abbr: 'v', help: "[ info | debug | warning ]")
            ;

        return parser;
    }

    void _configLogging(final String loglevel) {
        Validate.notBlank(loglevel);

        hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

        // now control the logging.
        // Turn off all logging first
        switch(loglevel) {
            case "fine":
            case "debug":
                Logger.root.level = Level.FINE;
                break;

            case "warning":
                Logger.root.level = Level.SEVERE;
                break;

            default:
                Logger.root.level = Level.INFO;
        }

        Logger.root.onRecord.listen(new LogPrintHandler(messageFormat: "%m"));
    }
}

/**
 * Defines default-configurations.
 * Most of these configs can be overwritten by commandline args.
 */
class Config {
    final Logger _logger = new Logger("gensamples.Config");

    static const String _KEY_SASS_DIR       = "sassdir";
    static const String _KEY_SAMPLES_DIR    = "example";
    static const String _KEY_LOGLEVEL       = "loglevel";
    static const String _KEY_MK_BACKUP      = "mkbackup";
    static const String _KEY_MAIN_TEMPLATE  = "maintemplate";
    static const String _KEY_INDEX_TEMPLATE = "indextemplate";

    final ArgResults _argResults;
    final Map<String,dynamic> _settings = new Map<String,dynamic>();

    Config(this._argResults) {

        _settings[_KEY_SASS_DIR]        = 'lib/sass';
        _settings[_KEY_SAMPLES_DIR]     = 'example';
        _settings[_KEY_LOGLEVEL]        = 'info';
        _settings[_KEY_MK_BACKUP]       = false;
        _settings[_KEY_MAIN_TEMPLATE]   = "bin/main.tmpl.dart";
        _settings[_KEY_INDEX_TEMPLATE]  = "bin/index.tmpl.html";

        _overwriteSettingsWithArgResults();
    }

    List<String> get dirstoscan => _argResults.rest;

    String get loglevel => _settings[_KEY_LOGLEVEL];

    String get sassdir => _settings[_KEY_SASS_DIR];

    String get samplesdir => _settings[_KEY_SAMPLES_DIR];

    bool get mkbackup => _settings[_KEY_MK_BACKUP];

    String get maintemplate => _settings[_KEY_MAIN_TEMPLATE];

    String get indextemplate => _settings[_KEY_INDEX_TEMPLATE];

    Map<String,String> get settings {
        final Map<String,String> settings = new Map<String,String>();

        settings["SASS-Dir"]        = sassdir;
        settings["Samples-Dir"]     = samplesdir;
        settings["loglevel"]        = loglevel;
        settings["make backup"]     = mkbackup ? "yes" : "no";
        settings["Main-Template"]   = maintemplate;
        settings["Index-Template"]  = indextemplate;

        if(dirstoscan.length > 0) {
            settings["Dirs to scan"] = dirstoscan.join(", ");
        }

        return settings;
    }

    // -- private -------------------------------------------------------------

    _overwriteSettingsWithArgResults() {

        /// Makes sure that path does not end with a /
        String checkPath(final String arg) {
            String path = arg;
            if(path.endsWith("/")) {
                path = path.replaceFirst(new RegExp("/\$"),"");
            }
            return path;
        }

        if(_argResults[Application._ARG_LOGLEVEL] != null) {
            _settings[_KEY_LOGLEVEL] = _argResults[Application._ARG_LOGLEVEL];
        }

        if(_argResults[Application._ARG_MK_BACKUP] != null) {
            _settings[_KEY_MK_BACKUP] = _argResults[Application._ARG_MK_BACKUP] as bool;
        }
    }
}

class _LinkInfo {
    final String link;
    final bool hasScript;
    _LinkInfo(this.link, this.hasScript);
}

void main(List<String> arguments) {
    final Application application = new Application();
    application.run( arguments );
}

