library gensamples;

import 'dart:io';
import 'dart:convert';

import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as Path;
import 'package:validate/validate.dart';

part 'package:mdl/grinder/samples.dart';
part 'package:mdl/grinder/config.dart';
part 'package:mdl/grinder/application.dart';

part 'package:mdl/grinder/MergeMaster.dart';
part 'package:mdl/grinder/SampleGenerator.dart';
part 'package:mdl/grinder/ThemeGenerator.dart';
part 'package:mdl/grinder/JSConverter.dart';
part 'package:mdl/grinder/Styleguide.dart';
part 'package:mdl/grinder/Utils.dart';

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
        log("Name: ${sample.name.padRight(25)} ${sample.type}");
    });
}

@Task()
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

        return sample.type == Type.Core || sample.type == Type.Dart || sample.type == Type.SPA;

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

        return sample.type == Type.Core || sample.type == Type.Dart || sample.type == Type.SPA;

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

