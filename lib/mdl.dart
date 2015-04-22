library mdl;

//import "package:mdl/mdlcore.dart";
import "package:mdl/mdlcomponets.dart";
import "package:mdl/mdlremote.dart";

export "package:mdl/mdlcore.dart";
export "package:mdl/mdlcomponets.dart";

void registerMdl() {

    registerAllMdlRemoteComponents();
    registerAllMdlComponents();

}