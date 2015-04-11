library mdlremote;

import 'dart:html' as html;
import 'dart:math' as Math;
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:browser_detect/browser_detect.dart';
import 'package:route_hierarchical/client.dart';

import 'package:mdl/mdlcore.dart';
import 'package:mdl/mdlcomponets.dart';

part "src/remote/ViewFactory.dart";
part "src/remote/MaterialContent.dart";
part "src/remote/MaterialContoller.dart";

void registerAllMdlRemoteComponents() {

    registerMaterialContent();

}
