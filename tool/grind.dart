library gensamples;

import 'package:grinder/grinder.dart';
import 'package:mdl/src/grinder/grinder.dart' as mdl;


main(args) => grind(args);

@Task()
@Depends(genCss, genThemes, test)
build() {
}

@Task()
@Depends(analyze)
test() {
    new TestRunner().testAsync(files: "test/unit");
    new TestRunner().testAsync(files: "test/visual");

    // Alle test mit @TestOn("content-shell") im header
    new TestRunner().test(files: "test/unit",platformSelector: "content-shell");
    new TestRunner().test(files: "test/visual",platformSelector: "content-shell");
}

@Task()
analyze() {
    final List<String> libs = [
        "lib/mdl.dart",
        "lib/mdlanimation.dart",
        "lib/mdlapplication.dart",
        "lib/mdlcomponents.dart",
        "lib/mdlcore.dart",
        "lib/mdldemo.dart",
        "lib/mdldialog.dart",
        "lib/mdldirective.dart",
        "lib/mdldnd.dart",
        "lib/mdlflux.dart",
        "lib/mdlform.dart",
        "lib/mdlformatter.dart",
        "lib/mdlmock.dart",
        "lib/mdlobservable.dart",
        "lib/mdltemplate.dart",
        "lib/mdlutils.dart",
        "lib/transformer.dart",
        "lib/src/grinder/grinder.dart"
    ];

    libs.forEach((final String lib) => Analyzer.analyze(lib));
    Analyzer.analyze("test");
}

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
    pushThemesToGitHub();
}

@Task()
@Depends(initSamples)
genCss() {
    log("${mdl.Utils.genMaterialCSS()} created!");
    log("${mdl.Utils.genSplashScreenCSS()} created!");
    log("${mdl.Utils.genFontsCSS()} created!");

    mdl.Utils.genPredefLayoutsCSS().forEach((final String file) => log("${file} created!"));
}

@Task()
pushThemesToGitHub() {
    run("tool/scripts/push-theme-to-github.sh");
}

@Task()
clean() => defaultClean();