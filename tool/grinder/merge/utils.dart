part of mdl.tool.grinder.merger;

Directory _jsComponent(final String name) {
    return _component(config.MDLJS2_PATH, name);
}

Directory _dartComponent(final String name) {
    return _component(config.MDLDART_PATH, name);
}

Directory _component(final String basepath, final String name) {
    return new Directory(path.join(basepath, name));
}



