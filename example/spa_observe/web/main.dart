import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';


@MdlComponentModel
class _Language {
    final String name;
    final String type;
    _Language(this.name, this.type);
}

class _Natural extends _Language {
    _Natural(final String name) : super(name,"natural");
}

@MdlComponentModel @di.Injectable()
class AppController {
    final Logger _logger = new Logger('main.AppController');

    final ObservableList<_Language> languages = new ObservableList<_Language>();

    AppController() {
        languages.add(new _Natural("English"));
        languages.add(new _Natural("German"));
        languages.add(new _Natural("Italian"));
        languages.add(new _Natural("French"));
        languages.add(new _Natural("Spanish"));

        new Timer(new Duration(seconds: 2),() {
            for(int index = 0;index < 10;index++) {
                languages.add(new _Natural("Sample - $index"));
            }
        });
    }

    void remove(final String language) {
        _logger.info("Remove $language clicked!!!!!");

        final _Language lang = languages.firstWhere(
                (final _Language check) {

                    final bool result = (check.name.toLowerCase() == language.toLowerCase());
                    _logger.fine("Check: ${check.name} -> $language, Result: $result");

                    return result;
                });

        if(language == "German") {

            int index = languages.indexOf(lang);
            languages[index] = new _Natural("Austrian");

        } else {
            languages.remove(lang);
        }
    }
}

main() {
    final Logger _logger = new Logger('main.MaterialRepeat');

    configLogging();

    registerMdl();

    componentFactory().rootContext(AppController).run(enableVisualDebugging: true).then((_) {
        new AppController();

    });

}


void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}