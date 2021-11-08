import 'dart:async';

import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'behaviour_mixin_test.dart';

part 'behaviour_test.types.dart';

void main() {
  late String fakeDescription;

  late MockAction mockAction;
  late MockBehaviourMonitor mockMonitor;

  late Behaviour behaviour;

  setUpAll(() {
    registerFallbackValue(BehaviourImpl(
      action: MockAction().action,
      description: '',
    ));
  });

  setUp(() {
    fakeDescription = faker.lorem.sentence();
    mockAction = MockAction();
    mockMonitor = MockBehaviourMonitor();

    behaviour = BehaviourImpl(
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
      final input = faker.lorem.sentence();
      final value = faker.lorem.sentence();
      final mockTrack = MockBehaviourTrack();
      when(() => mockAction.action(any(), any())).thenAnswer((i) {
        return Future.value(value);
      });
      when(() => mockMonitor.createBehaviourTrack(any())).thenReturn(mockTrack);

      // act
      await behaviour(input);

      // assert
      verify(() => mockAction.action(input, mockTrack));
    });

    test('should catch everything', () async {
      // arrange
      when(() => mockAction.action(any(), any())).thenAnswer((i) async {
        throw faker.lorem.sentence();
      });

      // act
      await behaviour(Object());
    });

    test('should return success if successful', () async {
      // arrange
      final value = faker.lorem.sentence();
      when(() => mockAction.action(any(), any())).thenAnswer((i) {
        return Future.value(value);
      });

      // act
      final result = await behaviour(faker.lorem.sentence());

      // assert
      expect(result, Success(value));
    });
  });
}
