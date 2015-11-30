part of mdl.unit.test;

class TestDataAction extends DataAction<String> {
     static const ActionName NAME = const ActionName("unit.test.TestDataAction");
     const TestDataAction(final String id) : super(NAME,id);
}

class TestSignal extends Action {
    static const ActionName NAME = const ActionName("unit.test.TestSignal");
    const TestSignal() : super(ActionType.Signal,NAME);
}

testActionBus() {
    // final Logger _logger = new Logger("test.ActionBus");

    group('ActionBus', () {

        group('> SendSignal', () {
            final ActionBus actionbus = new ActionBus();

            setUp(() {

            });

            test('> fire Simple Action', () {
                expect(actionbus, isNotNull);

                final Function onSignalTest = expectAsync( (final Action action ) {
                    //_logger.info("ActionTest: ${action.name}");

                    expect(action.type,ActionType.Signal);
                    expect(action.hasData,isFalse);
                });

                actionbus.on(TestSignal.NAME).listen(onSignalTest);

                actionbus.fire(const TestSignal());
            });

            test('> fire Action with Data', () {
                expect(actionbus, isNotNull);

                /// Hier komm angular-signal-test an (Keine Daten!!!!!)
                final Function onDataActionTest = expectAsync( (final DataAction<String> action ) {
                    //_logger.info("ActionTest: ${action.name}");

                    expect(action.type,ActionType.Data);
                    expect(action.hasData,isTrue);
                    expect(action.data,"Test");
                });

                actionbus.on(TestDataAction.NAME).listen(onDataActionTest);

                actionbus.fire(const TestDataAction("Test"));
            });

        }); // End of 'SendSignal' group

    });
    // end 'ActionBus' group
}

//------------------------------------------------------------------------------------------------
// Helper
//------------------------------------------------------------------------------------------------
