library mdlremote;

import 'dart:html' as html;
import 'dart:math' as Math;
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:browser_detect/browser_detect.dart';
import 'package:route_hierarchical/client.dart';

import 'package:wsk_material/wskcore.dart';
import 'package:wsk_material/wskcomponets.dart';

part "src/remote/ViewFactory.dart";
part "src/remote/MaterialContent.dart";
part "src/remote/MaterialContoller.dart";

void registerAllWskRemoteComponents() {

    registerMaterialContent();

}
