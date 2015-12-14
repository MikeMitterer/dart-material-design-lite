library mdl;

import "package:mdl/mdlcomponents.dart";
import "package:mdl/mdldirective.dart";
import "package:mdl/mdlapplication.dart";
import "package:mdl/mdltemplate.dart";
import "package:mdl/mdlformatter.dart";
import "package:mdl/mdldialog.dart";
import "package:mdl/mdlform.dart";

export "package:mdl/mdlcore.dart";
export "package:mdl/mdlcomponents.dart";
export "package:mdl/mdldirective.dart";
export "package:mdl/mdlapplication.dart";
export "package:mdl/mdltemplate.dart";
export "package:mdl/mdldialog.dart";
export "package:mdl/mdlform.dart";
export "package:mdl/mdlobservable.dart";
export "package:mdl/mdlformatter.dart";
export "package:mdl/mdldnd.dart";
export "package:mdl/mdlflux.dart";

void registerMdl() {

    registerMdlTemplateComponents();
    registerApplicationComponents();
    registerMdlDirectiveComponents();
    registerMdlFormatterComponents();
    registerMdlDialogComponents();
    registerMdlFormComponents();

    registerMdlComponents();
}