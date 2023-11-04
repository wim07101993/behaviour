import 'package:behaviour/behaviour.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

void main() {
  group('whenFutureOrValue', () {
    test('should execute value when value', () async {
      // arrange
      final expected = faker.lorem.sentence();

      // assert
      await expected.whenFutureOrValue(
        (future) => throw AssertionError(
          'This is no future, value should have been executed',
        ),
        (value) => expect(value == expected, isTrue),
      );
    });

    test('should execute future when future', () async {
      // arrange
      final expected = faker.lorem.sentence();

      // assert
      await Future.value(expected).whenFutureOrValue(
        (future) => future.then((value) => expect(value == expected, isTrue)),
        (value) => throw AssertionError(
          'This is no future, value should have been executed',
        ),
      );
    });
  });
}
