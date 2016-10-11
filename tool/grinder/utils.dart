library mdl.tool.grinder.utils;

import 'dart:io';
import 'package:path/path.dart' as path;

typedef void FileMerger(final File src, final File target);

void defaultFileMerger(final File src, final File target) {
    src.copySync(target.path);
}

void echoMerger(final File src, final File target) {
    print("    copy ${src.path} -> ${target.path}");
}

void copySubdirs(final Directory sourceDir, final Directory targetDir,
    { final List<String> validExtensions: const <String>[ ".scss"],
    FileMerger filemerger: defaultFileMerger }) {

    if (!sourceDir.existsSync()) {
        throw new Exception(
            'Source directory "${sourceDir.path}" does not exist, nothing to copy'
        );
    }

    if (!targetDir.existsSync()) {
        targetDir.createSync(recursive: true);
    }

    sourceDir.listSync()
        .where((final FileSystemEntity entity) {

        if(FileSystemEntity.isDirectorySync(entity.path)) {
            return true;
        }

        if(FileSystemEntity.isLinkSync(entity.path)) {
            return false;
        }

        return validExtensions.contains(path.extension(entity.path));

        })
        .forEach((final FileSystemEntity entity) {

            if (FileSystemEntity.isDirectorySync(entity.path)) {

                //final File src = new File(entity.path);
                final File target = new File(entity.path.replaceFirst(sourceDir.path, ""));

                copySubdirs(
                    new Directory("${entity.path}"), new Directory("${targetDir.path}${target.path}"),
                    validExtensions: validExtensions, filemerger: filemerger
                );
            }
            else {
                final File src = new File(entity.path);
                final File target = new File("${targetDir.path}${entity.path.replaceFirst(sourceDir.path, "")}");
//                if (!target.existsSync()) {
//                    target.createSync(recursive: true);
//                }

                filemerger(src,target);
            }
    });
}