import 'dart:async';

import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Exception());
  });

  group('ExceptionOrExtensions', () {
    group('when', () {
      test('should invoke the ifException when [Failed]', () {
        // act
        final exception = Exception(faker.lorem.sentence());
        final failed = Failed(exception);

        // assert
        failed.when(
          (e) => expect(e, exception),
          (value) => throw AssertionError('Should have invoked success.'),
        );
      });

      test('should invoke the ifSuccess when [Success]', () {
        // act
        final value = faker.lorem.sentence();
        final success = Success(value);

        // assert
        success.when(
          (exception) => throw AssertionError('Should have invoked exception.'),
          (v) => expect(v, value),
        );
      });
    });

    group('startNextWhenSuccess', () {
      test('should return first failure if not success', () {
        // arrange
        final failed = Failed(Exception(faker.lorem.sentence()));

        // act
        final result = failed.startNextWhenSuccess((value) {
          return Failed(Exception(faker.lorem.word()));
        });

        // assert
        expect(result, failed);
      });

      test('should invoke next if current results to success', () {
        // arrange
        final success = Success(faker.lorem.sentence());
        final secondSuccess = Success(faker.lorem.word());

        // act
        final result = success.startNextWhenSuccess((value) {
          expect(value, success.value);
          return secondSuccess;
        });

        // assert
        expect(result, secondSuccess);
      });
    });
  });

  group('FutureExceptionOrExtensions', () {
    group('thenWhen', () {
      test('should invoke the ifException when [Failed]', () async {
        // act
        final exception = Exception(faker.lorem.sentence());
        final failed = Failed(exception);
        final future = Future.value(failed);

        // assert
        await future.thenWhen(
          (e) => expect(e, exception),
          (value) => throw AssertionError('Should have invoked success.'),
        );
      });

      test('should invoke the ifSuccess when [Success]', () async {
        // act
        final value = faker.lorem.sentence();
        final success = Success(value);
        final future = Future.value(success);

        // assert
        await future.thenWhen(
          (exception) => throw AssertionError('Should have invoked exception.'),
          (v) => expect(v, value),
        );
      });
    });

    group('startNextWhenSuccess', () {
      test('should return first failure if not success', () async {
        // arrange
        final failed = Failed(Exception(faker.lorem.sentence()));
        final future = Future.value(failed);

        // act
        final result = await future.thenStartNextWhenSuccess((value) {
          return Failed(Exception(faker.lorem.word()));
        });

        // assert
        expect(result, failed);
      });

      test('should invoke next if current results to success', () async {
        // arrange
        final success = Success(faker.lorem.sentence());
        final future = Future.value(success);
        final secondSuccess = Success(faker.lorem.word());

        // act
        final result = await future.thenStartNextWhenSuccess((value) {
          expect(value, success.value);
          return secondSuccess;
        });

        // assert
        expect(result, secondSuccess);
      });
    });
  });

  group('FutureOrExceptionOrExtensions', () {
    group('thenWhen', () {
      test('should invoke the ifException when [Failed]', () async {
        // act
        final exception = Exception(faker.lorem.sentence());
        final failed = Failed(exception);

        // assert
        await failed.thenWhen(
          (e) => expect(e, exception),
          (value) => throw AssertionError('Should have invoked success.'),
        );
      });

      test('should invoke the ifSuccess when [Success]', () async {
        // act
        final value = faker.lorem.sentence();
        final success = Success(value);

        // assert
        await success.thenWhen(
          (exception) => throw AssertionError('Should have invoked exception.'),
          (v) => expect(v, value),
        );
      });

      test('should invoke the ifException when [Failed future]', () async {
        // act
        final exception = Exception(faker.lorem.sentence());
        final FutureOr<ExceptionOr> failed = Future.value(Failed(exception));

        // assert
        await failed.thenWhen(
          (e) => expect(e, exception),
          (value) => throw AssertionError('Should have invoked success.'),
        );
      });

      test('should invoke the ifSuccess when [Success future]', () async {
        // act
        final value = faker.lorem.sentence();
        final FutureOr<ExceptionOr> success = Future.value(Success(value));

        // assert
        await success.thenWhen(
          (exception) => throw AssertionError('Should have invoked exception.'),
          (v) => expect(v, value),
        );
      });
    });

    group('startNextWhenSuccess', () {
      test('should return first failure if not success', () async {
        // arrange
        final failed = Failed(Exception(faker.lorem.sentence()));

        // act
        final result = await failed.thenStartNextWhenSuccess((value) {
          return Failed(Exception(faker.lorem.word()));
        });

        // assert
        expect(result, failed);
      });

      test('should invoke next if current results to success', () async {
        // arrange
        final success = Success(faker.lorem.sentence());
        final secondSuccess = Success(faker.lorem.word());

        // act
        final result = await success.thenStartNextWhenSuccess((value) {
          expect(value, success.value);
          return secondSuccess;
        });

        // assert
        expect(result, secondSuccess);
      });
    });
  });
}
