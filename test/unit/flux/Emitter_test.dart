import 'package:test/test.dart';

import 'package:mdl/mdlflux.dart';
// import 'package:logging/logging.dart';

import '../config.dart';

class MyEmitter extends Emitter {

    void changeSomething() {
        emitChange();
    }
}

main() async {
    // final Logger _logger = new Logger("test.Emitter");
    
    configLogging();

    final MyEmitter emitter = new MyEmitter();

    group('Emitter', () {
        setUp(() { });

        test('> onChange', () {

            emitter.onChange.listen( expectAsync( (final DataStoreChangedEvent event) {
                expect(event,isNotNull);
                expect(event.data,new isInstanceOf<UpdateView>());
            }));

            emitter.changeSomething();

        }); // end of 'onChange' test


    });
    // End of 'Emitter' group
}

// - Helper --------------------------------------------------------------------------------------
