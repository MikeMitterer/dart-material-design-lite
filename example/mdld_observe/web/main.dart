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

@MdlComponentModel
class _Name {
    final String first;
    final String last;
    _Name(this.first, this.last);

    @override
    String toString() {
        return "$first $last";
    }
}

class _Natural extends _Language {
    _Natural(final String name) : super(name,"natural");
}

@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ObservableList<_Language>  languages = new ObservableList<_Language>();
    final ObservableProperty<String> time = new ObservableProperty<String>("",interval: new Duration(seconds: 1));
    final ObservableProperty<String> records = new ObservableProperty<String>("");
    final ObservableProperty<_Name>  nameObject = new ObservableProperty<_Name>(null);
    final ObservableProperty<bool>   isNameNull = new ObservableProperty<bool>(true);

    final List<_Name> _names = new List<_Name>();

    Application() {
        records.observes(() => (languages.isNotEmpty ? languages.length.toString() : "<empty>"));
        time.observes(() => _getTime());

        languages.add(new _Natural("English"));
        languages.add(new _Natural("German"));
        languages.add(new _Natural("Italian"));
        languages.add(new _Natural("French"));
        languages.add(new _Natural("Spanish"));

        _names.add(new _Name("Bill","Gates"));
        _names.add(new _Name("Steven","Jobs"));
        _names.add(new _Name("Larry","Page"));
        _names.add(null);

    }

    @override
    void run() {

        new Timer(new Duration(seconds: 2),() {
            for(int index = 0;index < 10;index++) {
                languages.add(new _Natural("Sample - $index"));
            }
        });

        int counter = 0;
        new Timer.periodic(new Duration(milliseconds: 1000),(final Timer timer) {
            nameObject.value = _names[counter % 4]; // 0,1,2,...
            isNameNull.value = nameObject.value == null;
            counter++;
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

    //- private -----------------------------------------------------------------------------------

    String _getTime() {
      final DateTime now = new DateTime.now();
      return "${now.hour.toString().padLeft(2,"0")}:${now.minute.toString().padLeft(2,"0")}:${now.second.toString().padLeft(2,"0")}";
    }
}

main() {
    final Logger _logger = new Logger('main.MaterialRepeat');

    configLogging();

    registerMdl();

    componentFactory().rootContext(Application).run(enableVisualDebugging: true)
        .then((final MaterialApplication application) {
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