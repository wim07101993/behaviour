import 'dart:async';

import 'package:behaviour/behaviour.dart';
import 'package:test/test.dart';

import '../mocks.dart';

part 'behaviour_base_test.types.dart';

void main() {
  group('constructor', () {
    test('should set fields', () {
      // arrange
      final mockMonitor = MockBehaviourMonitor();

      // act
      final behaviour = _BehaviourBaseImpl(mockMonitor);

      // assert
      expect(behaviour.monitor, mockMonitor);
    });
  });
}
