part of mdl.unit.test;

testDataAttribute() {
    final Logger _logger = new Logger("test.DataAttribute");

    group('DataAttribute', () {
        setUp(() { });

        test('> asBool', () {
            expect(DataAttribute.forValue(null).asBool(), isFalse);
            expect(DataAttribute.forValue("true").asBool(), isTrue);
            expect(DataAttribute.forValue("false").asBool(), isFalse);
            expect(DataAttribute.forValue("").asBool(), isFalse);
            expect(DataAttribute.forValue("").asBool(handleEmptyStringAs: true), isTrue);
        }); // end of 'asBool' test


    });
    // end 'DataAttribute' group
}

// - Helper --------------------------------------------------------------------------------------
