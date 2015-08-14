import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ObservableProperty<double> pi = new ObservableProperty<double>(3.14159265359);
    final ObservableProperty<String> name = new ObservableProperty<String>("Mike");
    final ObservableProperty<bool> checkStatus = new ObservableProperty<bool>(false);

    final List<String> xmen;
    
    Application() : xmen = ['Angel/Archangel', 'Apocalypse', 'Bishop', 'Beast','Caliban','Colossus',
                            'Cyclops','Firestar','Emma Frost','Gambit','High Evolutionary','Dark Phoenix',
                            'Marvel Girl','Iceman','Juggernaut','Magneto','Minos','Mr. Sinister','Mystique',
                            'Nightcrawler','Professor X','Pyro','Psylocke','Rogue','Sabretooth','Shadowcat','Storm',
                            'Talker','Wolverine','X-23' ];

    @override
    void run() {
        final Math.Random rnd = new Math.Random();
        new Timer.periodic(new Duration(milliseconds: 500),(final Timer timer) {
            final int index = rnd.nextInt(xmen.length);
            name.value = xmen[index];

            checkStatus.value = index % 2;
        });
    }

    //- private -----------------------------------------------------------------------------------

}

main() async {
    final Logger _logger = new Logger('main.Formatter');

    configLogging();

    registerMdl();

    final MaterialApplication application = await componentFactory().
        rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}


void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}