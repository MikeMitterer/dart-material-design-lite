library mdl;

import "package:mdl/mdlcomponets.dart";
import "package:mdl/mdldirective.dart";
import "package:mdl/mdlapplication.dart";
import "package:mdl/mdltemplate.dart";
import "package:mdl/mdlformatter.dart";

export "package:mdl/mdlcore.dart";
export "package:mdl/mdlcomponets.dart";
export "package:mdl/mdldirective.dart";
export "package:mdl/mdlapplication.dart";
export "package:mdl/mdltemplate.dart";
export "package:mdl/mdldialog.dart";
export "package:mdl/mdlobservable.dart";
export "package:mdl/mdlformatter.dart";
export "package:mdl/mdldnd.dart";

void registerMdl() {

    registerMdlTemplateComponents();
    registerApplicationComponents();
    registerMdlDirectiveComponents();
    registerMdlFormatterComponents();

    registerMdlComponents();
}