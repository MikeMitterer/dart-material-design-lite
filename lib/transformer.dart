library mdl.transformer;

import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:barback/barback.dart';

/**
 * This transformer removes unnecessary "style-files and style-folders" like
 * lib/assets/themes. It also removes lib/_templates
 *
 * For the "styleguide-sample" this reduces the package size by around 50%!
 */
class MDLCleanupTransformer extends Transformer implements LazyTransformer {
    // final BarbackSettings _settings;

    // A constructor named "asPlugin" is required. It can be empty, but
    // it must be present. It is how pub determines that you want this
    // class to be publicly available as a loadable transformer plugin.
    MDLCleanupTransformer.asPlugin(/* this._settings*/ );

    Future<bool> isPrimary(final AssetId id) async {
        //print("Path: ${id.path}");
        if(id.path.startsWith("lib${path.separator}_templates${path.separator}")) {
            return true;

        } else if(id.path.startsWith("lib${path.separator}assets${path.separator}themes${path.separator}")) {
            return true;

        } else if(id.path.startsWith("lib${path.separator}assets${path.separator}")) {
            // final String file = path.basename(id.path);
            final String extension = path.extension(id.path).toLowerCase();
            return (extension == ".scss" || extension == ".md" || extension == ".html" || extension == ".txt");
        }
        return false;
    }

    Future apply(final Transform transform) async {
        // print("Apply-Path: ${transform.primaryInput.id.path}");
        // Skip the transform in debug mode. (pub serve / pub build --mode=<mode>)
        // if (_settings.mode.name == 'debug') return;

        //final AssetId id = transform.primaryInput.id;
        return transform.consumePrimary();
    }

    @override
    void declareOutputs(final DeclaringTransform transform) {  }
}