library mdl.tool.grinder.merger;

import 'dart:io';
import 'package:path/path.dart' as path;

import 'config.dart' as config;
import 'utils.dart';

part 'merge/MergeCommand.dart';
part 'merge/utils.dart';

final List<MergeCommand> _commands = <MergeCommand>[

    new MergeSCSSFiles(_jsComponent("mdl-animation"),_dartComponent("mdl-animation")),
    new MergeSCSSFiles(_jsComponent("mdl-auto-init"),_dartComponent("mdl-auto-init")),
    new MergeSCSSFiles(_jsComponent("mdl-base"),_dartComponent("mdl-base")),
    new MergeSCSSFiles(_jsComponent("mdl-button"),_dartComponent("mdl-button")),
    new MergeSCSSFiles(_jsComponent("mdl-card"),_dartComponent("mdl-card")),
    new MergeSCSSFiles(_jsComponent("mdl-checkbox"),_dartComponent("mdl-checkbox")),
    new MergeSCSSFiles(_jsComponent("mdl-drawer"),_dartComponent("mdl-drawer")),
    new MergeSCSSFiles(_jsComponent("mdl-elevation"),_dartComponent("mdl-elevation")),
    new MergeSCSSFiles(_jsComponent("mdl-fab"),_dartComponent("mdl-fab")),
    new MergeSCSSFiles(_jsComponent("mdl-form-field"),_dartComponent("mdl-form-field")),
    new MergeSCSSFiles(_jsComponent("mdl-icon-toggle"),_dartComponent("mdl-icon-toggle")),
    new MergeSCSSFiles(_jsComponent("mdl-list"),_dartComponent("mdl-list")),
    new MergeSCSSFiles(_jsComponent("mdl-radio"),_dartComponent("mdl-radio")),
    new MergeSCSSFiles(_jsComponent("mdl-ripple"),_dartComponent("mdl-ripple")),
    new MergeSCSSFiles(_jsComponent("mdl-snackbar"),_dartComponent("mdl-snackbar")),
    new MergeSCSSFiles(_jsComponent("mdl-textfield"),_dartComponent("mdl-textfield")),
    new MergeSCSSFiles(_jsComponent("mdl-theme"),_dartComponent("mdl-theme")),
    new MergeSCSSFiles(_jsComponent("mdl-typography"),_dartComponent("mdl-typography"))

];

class Merger2 {

    Merger2();


    void merge() {

        _commands.forEach((final MergeCommand command) => command.execute());

    }
}