import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

typedef void RemoveCallback(final Name name);

@MdlComponentModel
class HackintoshComponent {
    final Logger _logger = new Logger('main.HackintoshComponent');

    final String name;
    final int quantity;
    final double price;

    HackintoshComponent(this.name, this.quantity, this.price);
}

@MdlComponentModel @di.Injectable()
class Application implements MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ObservableList<HackintoshComponent> components = new ObservableList<HackintoshComponent>();
    final ObservableProperty<bool>   isListEmpty = new ObservableProperty<bool>(true);

    Application() {
        isListEmpty.observes(() => components.isEmpty);
        _addItems();
    }

    @override
    void run() {

    }

    check(final String componentName) {
        _logger.info("Clicked on ${componentName}");
    }

    //- private -----------------------------------------------------------------------------------

    void _addItems() {
        if(components.isNotEmpty) {
            return;
        }
        components.add(new HackintoshComponent("Gigabyte GA-Z97X-UD3H-BK",1,192.90));
        components.add(new HackintoshComponent("Core i7-4790K",1,352.89));
        components.add(new HackintoshComponent("Core i7-4790K",1,352.89));
        components.add(new HackintoshComponent("EVGA GT 740 SC",1,110.12));
        components.add(new HackintoshComponent("Crucial Ballistix Tactical ",2,102.46));
        components.add(new HackintoshComponent("Samsung 850 EVO 250GB",1,94.21));
        components.add(new HackintoshComponent("Corsair RM 650 Watt",1,135.99 ));
        components.add(new HackintoshComponent("Corsair Carbide 500R",1,123.99));
    }

    void _removeItems() {
        components.clear();
    }
}

main() {
    final Logger _logger = new Logger('main.MaterialRepeat');

    configLogging();

    registerMdl();

    componentFactory().rootContext(Application).run()
    .then( (final Application application) {

        final MaterialButton add = MaterialButton.widget(dom.querySelector("#addComponents"));
        add.onClick.listen((_) => application._addItems());

        final MaterialButton remove = MaterialButton.widget(dom.querySelector("#removeComponents"));
        remove.onClick.listen((_) => application._removeItems());

        application.isListEmpty.onChange.listen((final PropertyChangeEvent<bool> property) {
            add.enabled = property.value;
            remove.enabled = !property.value;
        });

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