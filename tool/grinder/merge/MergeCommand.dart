part of mdl.tool.grinder.merger;

abstract class MergeCommand {
    final String _basename;
    final Directory _src;
    final Directory _target;

    MergeCommand(final Directory _src, this._target)
        : _basename = path.basename(_src.path),
            this._src = _src;

    execute();
}

class MergeSCSSFiles extends MergeCommand {
    MergeSCSSFiles(final Directory src, final Directory target) : super(src, target);

    @override
    execute() {
        try {
            _src.listSync().firstWhere((final FileSystemEntity entity) => path.extension(entity.path) == ".scss");

        } on StateError {
            print("No SCSS File in ${path.basename(_src.path)}!");
            return;
        }

        print("Merging ${path.basename(_src.path)}...");

        copySubdirs(_src, _target, filemerger: (final File src, final File target) {
            final String content = src.readAsStringSync();
            final String relativeTarget = target.path.replaceFirst(_target.path,"").replaceFirst("/","");

            String backlink = "../";

            // Number of subdirs
            if(path.split(relativeTarget).length == 2) {
                backlink = "../../";
            }
            print("  - ${_basename} - ${relativeTarget} -> ${backlink}");
            target.writeAsStringSync(

                content.replaceAllMapped(new RegExp('@import ("|\')mdl-'),
                    (final Match m) => "@import ${m[1]}${backlink}mdl-")

            );
            //print("    Changed '@import' in ${target.path}");
        });
    }
}