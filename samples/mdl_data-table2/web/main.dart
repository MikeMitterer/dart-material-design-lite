import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl_data_table_sample2/devicestatus.dart';

main() {
    configLogging();

    registerMdl();
    registerComponentsForDataTableII();

    componentFactory().run().then((_) {
//        final DeviceStatusElement devicestatus = DeviceStatusElement.widget(dom.querySelector("device-status"));
//        devicestatus.addItem(new DeviceStatus("Status I",25.720735,-94.570312,false));
//        devicestatus.addItem(new DeviceStatus("Status II",23.241346,-93.867187,false));
//        devicestatus.addItem(new DeviceStatus("Status III",24.246965,91.054687,true));
//        devicestatus.addItem(new DeviceStatus("Status IV",25.720735,-88.154297,false));
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}