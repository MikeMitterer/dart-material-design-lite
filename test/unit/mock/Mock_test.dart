//@TestOn("content-shell")
import 'dart:async';
import 'package:test/test.dart';

import 'package:di/di.dart' as di;
import 'package:mdl/mdlmock.dart' as mdlmock;

// import 'package:logging/logging.dart';

import '../config.dart';

typedef String TestCallback(final String name);

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

main() async {
    // final Logger _logger = new Logger("test.Mock");
    
    configLogging();

    group('Injection', () {
        setUp(() {
            mdlmock.setUpInjector();
            mdlmock.module((final di.Module module) {

                module.bind(SimpleService);
            });
        });

        test('> Simple injection', () async {
            final callback = expectAsync1((final String name) => name.toUpperCase());

            mdlmock.inject((final SimpleService service) async {
                expect(service, isNotNull);

                final String result = await service.connectToServer(callback);
                expect(result,"SIMPLE");
            });
            
        }); // end of 'Simple injection' test


    });
    // End of 'Injection' group

    group('Mock', () {
        setUp(() {
            mdlmock.setUpInjector();
            mdlmock.module((final di.Module module) {

                module.bind(SimpleService,toImplementation: MockedService);
            });
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
