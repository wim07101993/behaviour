import 'dart:async';

import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

part 'behaviour_without_input_test.types.dart';

void main() {
  late String fakeDescription;

  late _MockAction mockAction;
  late MockBehaviourMonitor mockMonitor;

  late _BehaviourWithoutInputImpl behaviour;

  setUpAll(() {
    registerFallbackValue(
      _BehaviourWithoutInputImpl(
        action: _MockAction().action,
        description: '',
      ),
    );
  });

  setUp(() {
    fakeDescription = faker.lorem.sentence();
    mockAction = _MockAction();
    mockMonitor = MockBehaviourMonitor();

    behaviour = _BehaviourWithoutInputImpl(
      action: mockAction.action,
      monitor: mockMonitor,
      description: fakeDescription,
    );
  });

  group('constructor', () {
    test('should set the fields', () {
      // assert
      expect(behaviour.monitor, mockMonitor);
    });
  });

  group('call', () {
    test('should call the action', () async {
      // arrange
      final value = faker.lorem.sentence();
      final mockTrack = MockBehaviourTrack();
      when(() => mockAction.action(any())).thenAnswer((i) {
        return Future.value(value);
      });
      when(() => mockMonitor.createBehaviourTrack(any())).thenReturn(mockTrack);

      // act
      await behaviour();

      // assert
      verify(() => mockAction.action(mockTrack));
    });

    test('should catch everything', () async {
      // arrange
      when(() => mockAction.action(any())).thenAnswer((i) async {
        throw faker.lorem.sentence();
      });

      // act
      await behaviour();
    });

    test('should return success if successful', () async {
      // arrange
      final value = faker.lorem.sentence();
      when(() => mockAction.action(any())).thenAnswer((i) {
        return Future.value(value);
      });

      // act
      final result = await behaviour();

      // assert
      expect(result, Success<dynamic>(value));
    });

    test('should make use of the [FutureOr] functionality when success',
        () async {
      // arrange
      final value = _DummyType(1);
      when(() => mockAction.action(any())).thenAnswer((i) => value);

      // act
      final result = behaviour();

      // assert
      expect(result, isA<Success>());
      final resultValue = (result as Success).value;
      expect(identical(resultValue, value), isTrue);
    });
  });
}
