library gensamples;

import 'dart:io';
import 'dart:convert';

import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as Path;
import 'package:validate/validate.dart';

part 'grinder/samples.dart';
part 'grinder/config.dart';

part 'grinder/MergeMaster.dart';
part 'grinder/SampleGenerator.dart';
part 'grinder/ThemeGenerator.dart';
part 'grinder/JSConverter.dart';
part 'grinder/Styleguide.dart';
part 'grinder/Utils.dart';

main(args) => grind(args);

@Task()
test() => new TestRunner().testAsync();

//@DefaultTask()
@Task()
@Depends(test)
build() {
  Pub.build();
}

@Task()
clean() => defaultClean();

@Task()
initSamples() => createSampleList();

@Task()
showConfig() {
    config.settings.forEach((final String key,final String value) {
        log("${key.padRight(28)}: $value");
    });
}

@Task()
@Depends(initSamples)
listSamples() {
    samples.forEach((final Sample sample) {
        log("Name: ${sample.name.padRight(22)} ${sample.type.toString().padRight(15)}\t Dir: ${sample.dirname}");
    });
}

@Task("Initializes the sample-array")
@Depends(initSamples)
mergeMaster() {
    final MergeMaster mergemaster = new MergeMaster();

    samples.where((final Sample sample) => sample.type == Type.Core).forEach((final Sample sample) {
        log("Name: ${sample.name.padRight(15)} ${sample.type}");

        mergemaster.copyOrigFiles(sample);
    });

    mergemaster.copyOrigExtraFiles();
    mergemaster.genMaterialCSS();
    mergemaster.copyDemoCSS();

    Utils.genMaterialCSS();
}

@Task()
@Depends(initSamples)
genSamples() {
    final SampleGenerator samplegenerator = new SampleGenerator();

    samples.where((final Sample sample) {

        return (sample.type == Type.Core || sample.type == Type.Dart || sample.type == Type.SPA);
        //return (sample.name == "animation" || sample.name == "badge" || sample.name == "dialog");
        //return (sample.name == "tabs");

    })
    .forEach((final Sample sample) {
        log("Name: ${sample.name.padRight(15)} ${sample.type},\t main.dart: ${sample.hasOwnDartMain},\t Own demo: ${sample.hasOwnDemoHtml}" );

        samplegenerator.generate(sample);
    });

    Utils.genMaterialCSS();
}

@Task()
@Depends(initSamples)
genStyleguide() {
    final Styleguide styleguide = new Styleguide();

    samples.where((final Sample sample) {

        return (sample.type == Type.Core || sample.type == Type.Dart || sample.type == Type.SPA || sample.type == Type.DartOld) &&
            sample.excludeFromStyleguide == false;

    })
    .forEach((final Sample sample) {
        log("Name: ${sample.name.padRight(15)} ${sample.type},\t main.dart: ${sample.hasOwnDartMain},\t Own demo: ${sample.hasOwnDemoHtml}" );

        styleguide.generate(sample);
    });
}

@Task()
@Depends(initSamples)
genThemes() {
    final ThemeGenerator generator = new ThemeGenerator();
    generator.generate();
}

@Task()
@Depends(initSamples)
genCss() => log("${Utils.genMaterialCSS()} created!");

