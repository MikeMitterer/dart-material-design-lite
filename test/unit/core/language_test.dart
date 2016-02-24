import 'package:test/test.dart';

// import 'package:logging/logging.dart';

import '../config.dart';

class _Name {
    String firstname;
    String lastname;

    _Name(this.firstname, this.lastname);
}

main() async {
    // final Logger _logger = new Logger("test.Language");
    
    configLogging();

    group('Language', () {
        setUp(() { });

        test('> Assignment', () {
            final _Name name = null;

            name?.firstname = "Mike";
            expect(name,isNull);

        }); // end of 'Assignment' test

    });
    // End of 'Language' group
}

// - Helper --------------------------------------------------------------------------------------
