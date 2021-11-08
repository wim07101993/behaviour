import 'dart:async';

import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'behaviour_mixin_test.dart';

part 'behaviour_without_input_test.types.dart';

void main() {
  late String fakeDescription;

  late MockAction mockAction;
  late MockBehaviourMonitor mockMonitor;

  late BehaviourWithoutInputImpl behaviour;

  setUpAll(() {
    registerFallbackValue(BehaviourWithoutInputImpl(
      action: MockAction().action,
      description: '',
    ));
  });

  setUp(() {
    fakeDescription = faker.lorem.sentence();
    mockAction = MockAction();
    mockMonitor = MockBehaviourMonitor();

    behaviour = BehaviourWithoutInputImpl(
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
      expect(result, Success(value));
    });
  });
}
