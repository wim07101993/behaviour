import 'dart:async';

import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

part 'behaviour_mixin_test.types.dart';

void main() {
  late MockBehaviourMonitor mockMonitor;

  late BehaviourMixin behaviour;

  setUpAll(() {
    registerFallbackValue(_BehaviourMixinImpl(
      onCatchException: (e, stacktrace, track) => Exception(),
    ));
    registerFallbackValue(Exception());
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    mockMonitor = MockBehaviourMonitor();

    behaviour = _BehaviourMixinImpl(
      monitor: mockMonitor,
    );
  });

  group('monitor', () {
    test('should default to null', () {
      // act
      behaviour = _BareBehaviourMixinImpl();

      // assert
      expect(behaviour.monitor, isNull);
    });
  });

  group('description', () {
    test('should return the tag', () {
      // act
      final description = behaviour.description;

      // assert
      expect(description, '_BehaviourMixinImpl');
    });
  });

  group('tag', () {
    test('should return the type name', () {
      // act
      final tag = behaviour.tag;

      // assert
      expect(tag, '_BehaviourMixinImpl');
    });
  });

  group('executeAction', () {
    late MockBehaviourTrack mockTrack;

    setUp(() {
      mockTrack = MockBehaviourTrack();

      when(() => mockMonitor.createBehaviourTrack(any())).thenReturn(mockTrack);
    });

    test('should work without monitor', () async {
      // arrange
      behaviour = _BehaviourMixinImpl();

      // assert
      await behaviour.executeAction((track) {
        return Future.value(const Success(null));
      });
    });

    test('should create a track if monitor is present', () async {
      // act
      await behaviour.executeAction((track) {
        expect(track, mockTrack);
        return Future.value(const Success(null));
      });
    });

    test('should start and end the track', () async {
      // act
      await behaviour.executeAction((track) => const Success(Object()));

      // assert
      verifyInOrder([
        () => mockTrack.start(),
        () => mockTrack.end(),
      ]);
      verifyNever(() => mockTrack.stopWithError(any(), any()));
      verifyNever(() => mockTrack.stopWithException(any(), any()));
    });

    test('should execute and return result of action', () async {
      // arrange
      final expected = faker.randomGenerator.element<ExceptionOr<String>>([
        Failed(Exception()),
        Success(faker.lorem.word()),
      ]);

      // act
      final result = await behaviour.executeAction((track) => expected);

      // assert
      expect(result, expected);
    });

    test(
        'should stop track with exception and return failed if an exception happens in action',
        () async {
      // arrange
      final exception = Exception();

      // act
      final result = await behaviour.executeAction((track) => throw exception);

      // assert
      expect(result, isA<Failed>());
      result.when(
        (e) => expect(e, exception),
        (value) => throw AssertionError('The result should be a failed.'),
      );
      verify(() => mockTrack.stopWithException(exception, any()));
    });

    test(
        'should stop track with error if an unknown error happens in the action',
        () async {
      // arrange
      final error = faker.lorem.sentence();

      // act
      final result = await behaviour.executeAction((track) => throw error);

      // assert
      expect(result, isA<Failed>());
      verify(() => mockTrack.stopWithError(any(), any()));
    });

    test('should return failed if an unknown error happens in the action',
        () async {
      // arrange
      final error = faker.lorem.sentence();
      final mockOnCatch = _MockOnCatch();
      final exception = Exception();
      when(() => mockOnCatch.onCatch(any(), any(), any())).thenAnswer((_) {
        return exception;
      });
      behaviour = _BehaviourMixinImpl(onCatchError: mockOnCatch.onCatch);

      // act
      final result = await behaviour.executeAction((track) => throw error);

      // assert
      expect(result, isA<Failed>());
      result.when(
        (e) => expect(e, exception),
        (value) => throw AssertionError('The result should be a failed.'),
      );
    });
  });

  group('onCatchException', () {
    test('should return the input exception if e was an exception', () async {
      // arrange
      behaviour = _BehaviourMixinImpl();
      final exception = Exception(faker.lorem.sentence());

      // act
      final resultException = await behaviour.onCatchException(
        exception,
        StackTrace.current,
        mockMonitor.createBehaviourTrack(behaviour),
      );

      // assert
      expect(resultException, exception);
    });
  });

  group('onCatchError', () {
    test('should return a default exception if e was no exception', () async {
      // arrange
      behaviour = _BehaviourMixinImpl();
      final noException = faker.lorem.sentence();

      // act
      final resultException = await behaviour.onCatchError(
        noException,
        StackTrace.current,
        mockMonitor.createBehaviourTrack(behaviour),
      );

      // assert
      expect(resultException.toString(), contains(noException));
    });
  });
}
