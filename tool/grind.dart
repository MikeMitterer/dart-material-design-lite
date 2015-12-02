library gensamples;

import 'dart:io';
import 'dart:convert';

import 'package:grinder/grinder.dart';
import 'package:mdl/src/grinder/grinder.dart' as mdl;


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
initSamples() => mdl.createSampleList();

@Task()
showConfig() {
    mdl.config.settings.forEach((final String key,final String value) {
        log("${key.padRight(28)}: $value");
    });
}

@Task("Initializes the sample-array")
@Depends(initSamples)
mergeMaster() {
    final mdl.MergeMaster mergemaster = new mdl.MergeMaster();

    mdl.samples.where((final mdl.Sample sample) => (sample.type == mdl.Type.Core || sample.type == mdl.Type.Ignore))
        .forEach( (final mdl.Sample sample) {

        log("Name: ${sample.name.padRight(15)} ${sample.type}");

        mergemaster.copyOrigFiles(sample);
    });

    mergemaster.copyOrigExtraFiles();
    mergemaster.genMaterialCSS();
    mergemaster.copyDemoCSS();

    mdl.Utils.genMaterialCSS();
}


@Task()
@Depends(initSamples, genCss)
genThemes() {
    final mdl.ThemeGenerator generator = new mdl.ThemeGenerator();
    generator.generate();
}

@Task()
@Depends(initSamples)
genCss() {
    log("${mdl.Utils.genMaterialCSS()} created!");
    log("${mdl.Utils.genSplashScreenCSS()} created!");
    log("${mdl.Utils.genFontsCSS()} created!");

    mdl.Utils.genPredefLayoutsCSS().forEach((final String file) => log("${file} created!"));
}
