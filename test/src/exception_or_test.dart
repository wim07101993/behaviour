import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

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

    group('operator ==', () {
      test('should return true if the values are equals (Success)', () {
        // act
        final value = faker.lorem.sentence();

        // assert
        expect(Success(value) == Success(value), isTrue);
      });

      test('should return true if the values are equals (Failed)', () {
        // act
        final exception = Exception(faker.lorem.sentence());

        // assert
        expect(Failed(exception) == Failed(exception), isTrue);
      });

      test('should return false if the values are different (Success)', () {
        // arrange
        final first = Success(faker.lorem.word());
        final second = Success(faker.lorem.sentence());

        // assert
        expect(first == second, isFalse);
      });

      test('should return false if the values are different (Failed)', () {
        // arrange
        final first = Failed(Exception(faker.lorem.sentence()));
        final second = Failed(Exception(faker.lorem.word()));

        // assert
        expect(first == second, isFalse);
      });
    });

    group('hashCode', () {
      test('should be the same for the same values (Success)', () {
        // arrange
        final value = faker.lorem.sentence();

        // assert
        expect(Success(value).hashCode, Success(value).hashCode);
      });

      test('should be the same for the same values (Failed)', () {
        // arrange
        final exception = Exception(faker.lorem.sentence());

        // assert
        expect(Failed(exception).hashCode, Failed(exception).hashCode);
      });

      test('should be different for different values (Success)', () {
        // arrange
        final first = Success(faker.lorem.sentence());
        final second = Success(faker.lorem.word());

        // assert
        expect(first.hashCode, isNot(second.hashCode));
      });

      test('should be different for different values (Failed)', () {
        // arrange
        final first = Failed(Exception(faker.lorem.sentence()));
        final second = Failed(Exception(faker.lorem.word()));

        // assert
        expect(first.hashCode, isNot(second.hashCode));
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
  });
}
