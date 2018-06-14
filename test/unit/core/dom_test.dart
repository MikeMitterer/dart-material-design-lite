@TestOn("chrome")
library test.unit.core.utils;

import 'package:test/test.dart';
import 'dart:html' as dom;

main() {
    final dom.DivElement div = new dom.DivElement();

       test('> isDomElement', () async {
            expect(div,isNotNull);
        });
}
