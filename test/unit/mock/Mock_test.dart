@TestOn("content-shell")
import 'dart:async';
import 'package:test/test.dart';

import 'package:dice/dice.dart' as di;
import 'package:mdl/mdlmock.dart' as mdlmock;

// import 'package:logging/logging.dart';

import '../config.dart';

typedef String TestCallback(final String name);

@di.injectable
class SimpleService {
    String get name => "simple";

    Future<String> connectToServer(final TestCallback callback) {
        return new Future<String>.delayed(new Duration(milliseconds: 500),() => callback(name));
    }
}

class MockedService extends SimpleService{

    @override
    Future<String> connectToServer(final TestCallback callback) {
        return new Future<String>.delayed(new Duration(milliseconds: 500),() {
            return "mocked-" + callback(name);
        });
    }
}

class AnotherMockedService extends SimpleService {
    @override
    Future<String> connectToServer(final TestCallback callback) {
        return new Future<String>.delayed(new Duration(milliseconds: 500),() {
            return callback("mocked2-${name}");
        });
    }
}

class MockModule extends di.Module {
    configure() {
        register(SimpleService);
    }
}

class MockModule2 extends di.Module {
    configure() {
        register(SimpleService).toType(MockedService);
    }
}

main() async {
    // final Logger _logger = new Logger("test.Mock");
    
    configLogging();

    group('Injection', () {
        setUp(() {
            mdlmock.setUpInjector();
            mdlmock.module(new MockModule());
        });

        test('> Simple injection', () async {
            final callback = expectAsync1((final String name) => name.toUpperCase());

            final SimpleService  service = mdlmock.injector().getInstance(SimpleService);
            expect(service, isNotNull);

            final String result = await service.connectToServer(callback);
            expect(result,"SIMPLE");

//            mdlmock.inject((final SimpleService service) async {
//                expect(service, isNotNull);
//
//                final String result = await service.connectToServer(callback);
//                expect(result,"SIMPLE");
//            });
            
        }); // end of 'Simple injection' test


    });
    // End of 'Injection' group

    group('Registration', () {
        setUp(() {
            mdlmock.setUpInjector();
        });

        test('> Simple via register', () async {
            mdlmock.injector().register(SimpleService).toType(AnotherMockedService);

            final callback = expectAsync1((final String name) => name.toUpperCase());

            final SimpleService  service = mdlmock.injector().getInstance(SimpleService);
            expect(service, isNotNull);

            final String result = await service.connectToServer(callback);
            expect(result,startsWith("MOCKED2-"));

            expect(0, equals(0));

        }); // end of 'Simple via register' test

    }); // End of '' group

    group('Mock', () {
        setUp(() {
            mdlmock.setUpInjector();
            mdlmock.module(new MockModule2());
        });

        test('> Mocked injection', () async {
            final callback = expectAsync1((final String name) => name.toUpperCase());

            mdlmock.inject((final SimpleService service) async {
                expect(service, isNotNull);

                final String result = await service.connectToServer(callback);
                expect(result,"mocked-SIMPLE");
            });

        }); // end of 'Mocked injection' test
    }); // End of '' group
}

// - Helper --------------------------------------------------------------------------------------
