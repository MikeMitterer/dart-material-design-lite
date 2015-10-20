import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

main() {
    final Logger _logger = new Logger('dialog.Main');

    configLogging();

    registerMdl();

    componentFactory().run().then((_) {
        final MaterialButton btnToast = MaterialButton.widget(dom.querySelector("#toast"));
        final MaterialButton btnWithAction = MaterialButton.widget(dom.querySelector("#withAction"));

        final MaterialSnackbar snackbar = new MaterialSnackbar();

        int counter = 0;

        void _makeSettings() {
            snackbar.position.left = MaterialCheckbox.widget(dom.querySelector("#checkbox-left")).checked;
            snackbar.position.top = MaterialCheckbox.widget(dom.querySelector("#checkbox-top")).checked;
            snackbar.position.right = MaterialCheckbox.widget(dom.querySelector("#checkbox-right")).checked;
            snackbar.position.bottom = MaterialCheckbox.widget(dom.querySelector("#checkbox-bottom")).checked;

            dom.querySelector("#container").classes.toggle("mdl-snackbar-container",
            MaterialCheckbox.widget(dom.querySelector("#checkbox-use-container")).checked);
        }

        btnToast.onClick.listen( (_) {
            _logger.info("Click on Toast");

            _makeSettings();
            snackbar("Snackbar message #${counter}").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
            counter++;
        });

        btnWithAction.onClick.listen( (_) {
            _logger.info("Click on withAction");

            _makeSettings();
            snackbar("Snackbar message #${counter}",confirmButton: "OK").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
            counter++;
        });


    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}