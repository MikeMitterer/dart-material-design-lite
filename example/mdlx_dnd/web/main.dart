import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';

@MdlComponentModel
class _Language {
    final String name;
    final String type;

    _Language(this.name, this.type);
}

class _Programming extends _Language {
    _Programming(final String name) : super(name,"programming");
}
class _Natural extends _Language {
    _Natural(final String name) : super(name,"natural");
}

@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final _logger = new Logger('dnd.Application');

    final ObservableList<_Language> languages = new ObservableList<_Language>();
    final ObservableList<_Language> natural = new ObservableList<_Language>();
    final ObservableList<_Language> programming = new ObservableList<_Language>();

    Application() {
        languages.add(new _Natural("English"));
        languages.add(new _Natural("German"));
        languages.add(new _Natural("Italian"));
        languages.add(new _Natural("French"));
        languages.add(new _Natural("Spanish"));

        languages.add(new _Programming("CPP"));
        languages.add(new _Programming("Dart"));
        languages.add(new _Programming("Java"));
    }

    @override
    void run() {

    }

    void addToProgrammingLanguages(final _Language language) {
        if(language.type == "programming") {
            if(!programming.contains(language)) {
                programming.add(language);
            }
        }
    }

    void addToNaturalLanguages(final _Language language) {
        if(language.type == "natural") {
            if(!natural.contains(language)) {
                natural.add(language);
            }
        }
    }

    void moveToTrash(final _Language language) {
        if(language.type == "programming" && programming.contains(language)) {
            programming.remove(language);

        } else if(language.type == "natural" && natural.contains(language)) {
            natural.remove(language);
        }
    }
}

main() {
    final Logger _logger = new Logger('dnd.Main');

    configLogging();

    registerMdl();
    registerMdlDND();

    componentFactory().rootContext(Application).run().then((final MaterialApplication application) {
        application.run();
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}