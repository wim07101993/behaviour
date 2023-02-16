import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class _FunctionWrapper<TInput> {
  void call(TInput input);
}

class MockFunction<T> extends Mock implements _FunctionWrapper<T> {}

class MockExceptionOr<T> extends Mock implements ExceptionOr<T> {}

void main() {
  setUpAll(() {
    registerFallbackValue(Exception());
  });

  group(ExceptionOr, () {
    group('startNextWhenSuccess', () {
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

      test('should return first failure if not success', () {
        // arrange
        final failed = Failed(Exception(faker.lorem.sentence()));

        // act
        final result = failed.startNextWhenSuccess((value) {
          throw AssertionError(
            'Failed is no success. This action should not have been called',
          );
        });

        // assert
        expect(result, failed);
      });
    });

    group('whenSuccess', () {
      test('should execute ifSuccess when the exceptionOr is a success', () {
        // arrange
        final fakeValue = faker.lorem.sentence();
        final function = MockFunction<String>();
        final ExceptionOr<String> exceptionOr = Success(fakeValue);

        // act
        exceptionOr.whenSuccess(function);

        // assert
        verify(() => function.call(fakeValue));
      });

      test('should not execute ifSuccess when the exceptionOr is a failed', () {
        // arrange
        final function = MockFunction<String>();
        final ExceptionOr<String> exceptionOr = Failed(
          Exception(faker.lorem.sentence()),
        );

        // act
        exceptionOr.whenSuccess(function);

        // assert
        verifyNever(() => function.call(any()));
      });
    });

    group('whenFailed', () {
      test('should execute ifFailed when the exceptionOr is a failed', () {
        // arrange
        final fakeException = Exception(faker.lorem.sentence());
        final function = MockFunction<Exception>();
        final ExceptionOr<String> exceptionOr = Failed(fakeException);

        // act
        exceptionOr.whenFailed(function);

        // assert
        verify(() => function.call(fakeException));
      });

      test('should not execute ifFailed when the exceptionOr is a success', () {
        // arrange
        final function = MockFunction<Exception>();
        final ExceptionOr<String> exceptionOr = Success(faker.lorem.sentence());

        // act
        exceptionOr.whenFailed(function);

        // assert
        verifyNever(() => function.call(any()));
      });
    });
  });

  group(Failed, () {
    late Exception exception;

    setUp(() {
      exception = Exception(faker.lorem.sentence());
    });

    group('constructor', () {
      test('should set the fields', () {
        // act
        final failed = Failed(exception);

        // assert
        expect(failed.reason, exception);
      });
    });

    group('when', () {
      test('should invoke the ifException', () {
        // act
        final failed = Failed(exception);

        // assert
        failed.when(
          (e) => expect(e, exception),
          (value) => throw AssertionError('Should have invoked success.'),
        );
      });
    });

    group('operator ==', () {
      test('should return true if the values are equals', () {
        // assert
        expect(Failed(exception) == Failed(exception), isTrue);
      });

      test('should return false if the values are different', () {
        // arrange
        final other = Failed(Exception(faker.lorem.word()));

        // assert
        expect(Failed(exception) == other, isFalse);
      });
    });

    group('hashCode', () {
      test('should be the same for the same values', () {
        // assert
        expect(Failed(exception).hashCode, Failed(exception).hashCode);
      });

      test('should be different for different values', () {
        // assert
        final other = Failed(Exception(faker.lorem.word()));

        expect(Failed(exception).hashCode, isNot(other.hashCode));
      });
    });
  });

  group(Success, () {
    late String value;

    setUp(() {
      value = faker.lorem.sentence();
    });

    group('constructor', () {
      test('should set the fields', () {
        // act
        final success = Success(value);

        // assert
        expect(success.value, value);
      });
    });

    group('when', () {
      test('should invoke the ifSuccess', () {
        // act
        final success = Success(value);

        // assert
        success.when(
          (exception) => throw AssertionError('Should have invoked exception.'),
          (v) => expect(v, value),
        );
      });
    });

    group('operator ==', () {
      test('should return true if the values are equals', () {
        // assert
        expect(Success(value) == Success(value), isTrue);
      });

      test('should return false if the values are different', () {
        // assert
        expect(Success(value) == Success(faker.lorem.word()), isFalse);
      });
    });

    group('hashCode', () {
      test('should be the same for the same values', () {
        // assert
        expect(Success(value).hashCode, Success(value).hashCode);
      });

      test('should be different for different values', () {
        // assert
        final other = Success(faker.lorem.word());

        expect(Success(value).hashCode, isNot(other.hashCode));
      });
    });
  });

  group('FutureExceptionOrExtensions', () {
    late Exception fakeException;
    late ExceptionOr<String> mockExceptionOr;

    setUp(() {
      fakeException = Exception(faker.lorem.sentence());
      mockExceptionOr = MockExceptionOr();

      when(() => mockExceptionOr.whenFailed(any())).thenReturn(mockExceptionOr);
      when(() => mockExceptionOr.whenSuccess(any()))
          .thenReturn(mockExceptionOr);
      when(() => mockExceptionOr.when(any(), any())).thenAnswer((i) {
        // ignore: avoid_dynamic_calls
        return i.positionalArguments[0](fakeException);
      });
    });

    group('thenWhen', () {
      test('should invoke the ifException when failed', () async {
        // arrange
        final exception = Exception(faker.lorem.sentence());
        final failed = Failed(exception);
        final future = Future.value(failed);
        final fakeReturnValue = faker.lorem.sentence();

        // act
        final returnValue = await future.thenWhen(
          (e) => fakeReturnValue,
          (value) => throw AssertionError('Should have invoked success.'),
        );

        // assert
        expect(returnValue, fakeReturnValue);
      });

      test('should invoke the ifSuccess when success', () async {
        // act
        final value = faker.lorem.sentence();
        final success = Success(value);
        final future = Future.value(success);
        final fakeReturnValue = faker.lorem.sentence();

        // act
        final returnValue = await future.thenWhen(
          (exception) => throw AssertionError('Should have invoked exception.'),
          (v) => fakeReturnValue,
        );

        // assert
        expect(returnValue, fakeReturnValue);
      });
    });

    group('thenWhenSuccess', () {
      test('should invoke the whenSuccess of the exceptionOr', () async {
        // arrange
        final future = Future.value(mockExceptionOr);
        String successHandler(String value) => faker.lorem.sentence();

        // act
        final returnValue = await future.thenWhenSuccess(successHandler);

        // assert
        expect(returnValue, mockExceptionOr);
        verify(() => mockExceptionOr.whenSuccess(successHandler));
      });
    });

    group('thenWhenFailed', () {
      test('should invoke the whenFailed of the exceptionOr', () async {
        // arrange
        final future = Future.value(mockExceptionOr);
        String exceptionHandler(Exception value) => faker.lorem.sentence();

        // act
        final returnValue = await future.thenWhenFailed(exceptionHandler);

        // assert
        expect(returnValue, mockExceptionOr);
        verify(() => mockExceptionOr.whenFailed(exceptionHandler));
      });
    });

    group('thenStartNextWhenSuccess', () {
      test('should return first failure if not success', () async {
        // arrange
        final failed = Failed(Exception(faker.lorem.sentence()));
        final future = Future.value(failed);

        // act
        final result = await future.thenStartNextWhenSuccess((value) {
          return Future.value(Failed(Exception(faker.lorem.word())));
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
          return Future.value(secondSuccess);
        });

        // assert
        expect(result, secondSuccess);
      });
    });
  });
}
