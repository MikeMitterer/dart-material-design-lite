import "dart:html" as dom;
import 'package:di/di.dart' as di;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

import "package:mdl_dialog_sample/customdialog1.dart";
import "package:mdl_dialog_sample/customdialog2.dart";


@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('dialog.Application');

    int _mangoCounter = 0;

    final MaterialButton btnAlertDialog;
    final MaterialButton btnConfirmDialog;

    final MaterialButton btnCustomDialog1;
    final MaterialButton btnCustomDialog2;

    final MaterialAlertDialog alertDialog;
    final MdlConfirmDialog confirmDialog;
    final CustomDialog1 customDialog1;
    final CustomDialog2 customDialog2;

    Application() :

        btnAlertDialog = MaterialButton.widget(dom.querySelector("#alertdialog")),
        btnConfirmDialog = MaterialButton.widget(dom.querySelector("#confirmdialog")),

        btnCustomDialog1 = MaterialButton.widget(dom.querySelector("#customdialog1")),
        btnCustomDialog2 = MaterialButton.widget(dom.querySelector("#customdialog2")),

        alertDialog = new MaterialAlertDialog(),
        confirmDialog = new MdlConfirmDialog(),
        customDialog1 = new CustomDialog1(),
        customDialog2 = new CustomDialog2() {

        _bindEvents();
    }

    @override run() {
    }

    //- private --------------------------------------------------------------------------------------------------------

    void _bindEvents() {

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
            customDialog1(title: "Mango #${_mangoCounter} (Fruit)",
                yesButton: "I buy it!", noButton: "Not now").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                _mangoCounter++;
            });
        });

        btnCustomDialog2.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog2(title: "Form-Sample").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                if(status == MdlDialogStatus.OK) {
                    _logger.info("You entered: ${customDialog2.name.value}");
                }
            });
        });
    }

}

main() async {
    final Logger _logger = new Logger('dialog.Main');

    configLogging();

    registerMdl();

    final Application app = await componentFactory().rootContext(Application).run();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}