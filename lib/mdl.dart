library mdl;

import "package:mdl/mdlcomponets.dart";
import "package:mdl/mdlapplication.dart";
import "package:mdl/mdltemplate.dart";

export "package:mdl/mdlcore.dart";
export "package:mdl/mdlcomponets.dart";
export "package:mdl/mdlapplication.dart";
export "package:mdl/mdltemplate.dart";
export "package:mdl/mdldialog.dart";

void registerMdl() {

    registerMdlTemplateComponents();
    registerApplicationComponents();
    registerMdlComponents();

}