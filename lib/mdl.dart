library mdl;

import "package:mdl/mdlcomponets.dart";
import "package:mdl/mdlremote.dart";
import "package:mdl/mdltemplatecomponents.dart";

export "package:mdl/mdlcore.dart";
export "package:mdl/mdlcomponets.dart";
export "package:mdl/mdlremote.dart";
export "package:mdl/mdltemplatecomponents.dart";

void registerMdl() {

    registerAllMdlRemoteComponents();
    registerAllMdlTemplateComponents();
    registerAllMdlComponents();
}