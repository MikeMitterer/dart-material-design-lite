import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

import "package:mdl_dialog_sample/customdialog.dart";

main() {
    final Logger _logger = new Logger('dialog.Main');

    configLogging();

    registerMdl();

    upgradeAllRegistered().then((_) {
        final MaterialButton btnAlertDialog = MaterialButton.widget(dom.querySelector("#alertdialog"));
        final MaterialButton btnConfirmDialog = MaterialButton.widget(dom.querySelector("#confirmdialog"));
        final MaterialButton btnCustomDialog = MaterialButton.widget(dom.querySelector("#customdialog"));

        final MaterialAlertDialog alertDialog = new MaterialAlertDialog();
        final MdlConfirmDialog confirmDialog = new MdlConfirmDialog();
        final CustomDialog customDialog = new CustomDialog();

        int mangoCounter = 0;

        btnAlertDialog.onClick.listen((_) {
            _logger.info("Click on AlertButton");
            alertDialog("Testmessage").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
        });

        btnConfirmDialog.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            confirmDialog("Testmessage").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
        });

        btnCustomDialog.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog(title: "Mango #${mangoCounter} (Fruit)",
                yesButton: "I buy it!", noButton: "Not now").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                mangoCounter++;
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