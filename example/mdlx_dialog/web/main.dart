import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

import "package:mdl_dialog_sample/customdialog1.dart";
import "package:mdl_dialog_sample/customdialog2.dart";

main() {
    final Logger _logger = new Logger('dialog.Main');

    configLogging();

    registerMdl();

    componentFactory().run().then((_) {

        final MaterialButton btnAlertDialog = MaterialButton.widget(dom.querySelector("#alertdialog"));
        final MaterialButton btnConfirmDialog = MaterialButton.widget(dom.querySelector("#confirmdialog"));
        final MaterialButton btnCustomDialog1 = MaterialButton.widget(dom.querySelector("#customdialog1"));
        final MaterialButton btnCustomDialog2 = MaterialButton.widget(dom.querySelector("#customdialog2"));

        final MaterialAlertDialog alertDialog = new MaterialAlertDialog();
        final MdlConfirmDialog confirmDialog = new MdlConfirmDialog();
        final CustomDialog1 customDialog1 = new CustomDialog1();
        final CustomDialog2 customDialog2 = new CustomDialog2();

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

        btnCustomDialog1.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog1(title: "Mango #${mangoCounter} (Fruit)",
                yesButton: "I buy it!", noButton: "Not now").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                mangoCounter++;
            });
        });

        btnCustomDialog2.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog2(title: "Form-Sample").show().then((final MdlDialogStatus status) {

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