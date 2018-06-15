@TestOn("chrome")
import 'dart:async';
import 'package:test/test.dart';

import 'package:dryice/dryice.dart';
import 'package:mdl/mdlmock.dart' as mdlmock;

// import 'package:logging/logging.dart';

import '../config.dart';
import 'Mock_test.reflectable.dart';

typedef String TestCallback(final String name);

@inject
class SimpleService {
    String get name => "simple";

    Future<String> connectToServer(final TestCallback callback) {
        return new Future<String>.delayed(new Duration(milliseconds: 500),() => callback(name));
    }
}

@inject
class MockedService extends SimpleService{

    @override
    Future<String> connectToServer(final TestCallback callback) {
        return new Future<String>.delayed(new Duration(milliseconds: 500),() {
            return "mocked-" + callback(name);
        });
    }
}

@inject
class AnotherMockedService extends SimpleService {
    @override
    Future<String> connectToServer(final TestCallback callback) {
        return new Future<String>.delayed(new Duration(milliseconds: 500),() {
            return callback("mocked2-${name}");
        });
    }
}

class MockModule extends Module {
    configure() {
        register(SimpleService);
    }
}

class MockModule2 extends Module {
    configure() {
        register(SimpleService).to(MockedService);
    }
}

main() async {
    // final Logger _logger = new Logger("test.Mock");
    
    // configLogging();
    initializeReflectable();
    
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
            // Nr of calls - see below
            final callback = expectAsync1((final String name) => name.toUpperCase(),count: 2);

            final SimpleService service = mdlmock.injector().get(SimpleService);
            expect(service, isNotNull);
            expect(service is MockedService, isTrue);

            // Call 1
            final String result = await service.connectToServer(callback);
            expect(result,"mocked-SIMPLE");
            
            mdlmock.inject(<Type>[SimpleService].toSet(),(final Map<Type,dynamic> injected) async {
                expect(injected[SimpleService], isNotNull);
                expect(injected[SimpleService] is MockedService, isTrue);

                final SimpleService service = injected[SimpleService];

                // Call 2
                final String result = await service.connectToServer(callback);
                
                expect(result,"mocked-SIMPLE");

            });

        }); // end of 'Mocked injection' test
    }); // End of '' group
}

// - Helper --------------------------------------------------------------------------------------
