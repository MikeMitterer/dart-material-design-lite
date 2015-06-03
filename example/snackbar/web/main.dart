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

        int mangoCounter = 0;

        void _makeSettings() {
            snackbar.position.left = MaterialCheckbox.widget(dom.querySelector("#checkbox-left")).checked;
            snackbar.position.top = MaterialCheckbox.widget(dom.querySelector("#checkbox-top")).checked;
            snackbar.position.right = MaterialCheckbox.widget(dom.querySelector("#checkbox-right")).checked;
            snackbar.position.bottom = MaterialCheckbox.widget(dom.querySelector("#checkbox-bottom")).checked;

            dom.querySelector("#container").classes.toggle("mdl-toast-container",
            MaterialCheckbox.widget(dom.querySelector("#checkbox-use-container")).checked);
        }

        btnToast.onClick.listen( (_) {
            _logger.info("Click on Toast");

            _makeSettings();
            snackbar("message").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
        });

        btnWithAction.onClick.listen( (_) {
            _logger.info("Click on withAction");

            _makeSettings();
            snackbar("message",confirmButton: "OK").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });

        });


    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}