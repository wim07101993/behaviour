import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

void main() {
  group(ExceptionOr, () {
    group('startNextWhenSuccess', () {
      test('should return first failure if not success', () async {
        // arrange
        final failed = Failed(Exception(faker.lorem.sentence()));

        // act
        final result = failed.startNextWhenSuccess(() {
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
        final result = success.startNextWhenSuccess(() {
          return secondSuccess;
        });

        // assert
        expect(result, secondSuccess);
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
    group('thenWhen', () {
      test('should invoke the ifException if failed', () async {
        // act
        final exception = Exception(faker.lorem.sentence());
        final failed = Future.value(Failed(exception));

        // assert
        await failed.thenWhen(
          (e) => expect(e, exception),
          (value) => throw AssertionError('Should have invoked success.'),
        );
      });

      test('should invoke the ifSuccess', () async {
        // act
        final value = faker.lorem.sentence();
        final success = Future.value(Success(value));

        // assert
        await success.thenWhen(
          (exception) => throw AssertionError('Should have invoked exception.'),
          (v) => expect(v, value),
        );
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
