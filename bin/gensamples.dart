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

                    final Link packages = new Link("${sample.path}/packages");
                    final File targetPackages = new File("../../packages");

                    if(srcDemo.existsSync()) {
                        srcDemo.copySync(targetDemo.path);

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
                    }


                });
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

    static const String _KEY_SASS_DIR     = "sassdir";
    static const String _KEY_SAMPLES_DIR  = "example";
    static const String _KEY_LOGLEVEL     = "loglevel";
    static const String _KEY_MK_BACKUP    = "mkbackup";

    final ArgResults _argResults;
    final Map<String,dynamic> _settings = new Map<String,dynamic>();

    Config(this._argResults) {

        _settings[_KEY_SASS_DIR]      = 'lib/sass';
        _settings[_KEY_SAMPLES_DIR]   = 'example';
        _settings[_KEY_LOGLEVEL]      = 'info';
        _settings[_KEY_MK_BACKUP]     = false;

        _overwriteSettingsWithArgResults();
    }

    List<String> get dirstoscan => _argResults.rest;

    String get loglevel => _settings[_KEY_LOGLEVEL];

    String get sassdir => _settings[_KEY_SASS_DIR];

    String get samplesdir => _settings[_KEY_SAMPLES_DIR];

    bool get mkbackup => _settings[_KEY_MK_BACKUP];

    Map<String,String> get settings {
        final Map<String,String> settings = new Map<String,String>();

        settings["SASS-Dir"]        = sassdir;
        settings["Samples-Dir"]     = samplesdir;
        settings["loglevel"]        = loglevel;
        settings["make backup"]     = mkbackup ? "yes" : "no";

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

void main(List<String> arguments) {
    final Application application = new Application();
    application.run( arguments );
}

