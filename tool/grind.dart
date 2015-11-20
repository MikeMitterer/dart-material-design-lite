library gensamples;

import 'dart:io';
import 'dart:convert';

import 'package:grinder/grinder.dart';
import 'package:mdl/src/grinder/grinder.dart';


main(args) => grind(args);

@Task()
test() => new TestRunner().testAsync();

@DefaultTask()
@Depends(genCss)
build() {
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


@Task("Initializes the sample-array")
@Depends(initSamples)
mergeMaster() {
    final MergeMaster mergemaster = new MergeMaster();

    samples.where((final Sample sample) => (sample.type == Type.Core || sample.type == Type.Ignore))
        .forEach( (final Sample sample) {

        log("Name: ${sample.name.padRight(15)} ${sample.type}");

        mergemaster.copyOrigFiles(sample);
    });

    mergemaster.copyOrigExtraFiles();
    mergemaster.genMaterialCSS();
    mergemaster.copyDemoCSS();

    Utils.genMaterialCSS();
}


@Task()
@Depends(initSamples, genCss)
genThemes() {
    final ThemeGenerator generator = new ThemeGenerator();
    generator.generate();
}

@Task()
@Depends(initSamples)
genCss() {
    log("${Utils.genMaterialCSS()} created!");
    log("${Utils.genSplashScreenCSS()} created!");
    log("${Utils.genFontsCSS()} created!");
    Utils.genPredefLayoutsCSS().forEach((final String file) => log("${file} created!"));
}
