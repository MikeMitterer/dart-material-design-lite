import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

@MdlComponentModel
class HackintoshComponent {
    final Logger _logger = new Logger('main.HackintoshComponent');

    final String id;
    final String name;
    final int quantity;
    final double price;

    HackintoshComponent(this.id,this.name, this.quantity, this.price);
}

@MdlComponentModel @di.Injectable()
class Application implements MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ObservableList<HackintoshComponent> components = new ObservableList<HackintoshComponent>();
    final ObservableProperty<bool>   isListEmpty = new ObservableProperty<bool>(true);
    final ObservableProperty<double> total = new ObservableProperty<double>(0.0);

    Application() {
        isListEmpty.observes(() => components.isEmpty);
        _addItems();
    }

    @override
    void run() {
        _addListeners();
    }

    check(final String componentName) {
        _logger.info("Clicked on ${componentName}");
    }

    //- private -----------------------------------------------------------------------------------

    void _addItems() {
        if(components.isNotEmpty) {
            return;
        }
        components.add(new HackintoshComponent("1","Gigabyte GA-Z97X-UD3H-BK",1,192.90));
        components.add(new HackintoshComponent("2","Core i7-4790K",1,352.89));
        components.add(new HackintoshComponent("3","EVGA GT 740 SC",1,110.12));
        components.add(new HackintoshComponent("4","Crucial Ballistix Tactical ",2,102.46));
        components.add(new HackintoshComponent("5","Samsung 850 EVO 250GB",1,94.21));
        components.add(new HackintoshComponent("6","Corsair RM 650 Watt",1,135.99 ));
        components.add(new HackintoshComponent("7","Corsair Carbide 500R",1,123.99));
    }

    void _removeItems() {
        components.clear();
    }

    void _addListeners() {
        final MaterialDivDataTable table = MaterialDivDataTable.widget(dom.querySelector(".mdl-data-tableex"));
        if(table == null) {
            return;
        }

        table.onChange.listen((_) {
            final List<MaterialDivDataTableRow> rows = table.selectedRows;
            _logger.info("DataTable changed! ${rows.length} items are selected...");

            total.value = 0;
            rows.forEach((final MaterialDivDataTableRow row) {
                final String id = row.hub.dataset["id"];
                _logger.info("   Row with ID: ${id}");
                total.value = total.value + _getComponent(id).price;
            });
        });
    }

    HackintoshComponent _getComponent(final String id) {
        return components.firstWhere((final HackintoshComponent component) => component.id == id);
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
            application.total.value = 0.0;
            final MaterialDivDataTable table = MaterialDivDataTable.widget(dom.querySelector(".mdl-data-tableex"));
            table.select = false;
        });

        application.run();

    });

}



void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}