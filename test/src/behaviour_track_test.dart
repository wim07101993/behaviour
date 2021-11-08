import 'package:behaviour/behaviour.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import '../mocks.dart';

part 'behaviour_track_test.types.dart';

void main() {
  late BehaviourMixin mockBehaviour;
  late BehaviourTrack track;

  setUp(() {
    mockBehaviour = MockBehaviourBase();
    track = _BehaviourTrackImpl(mockBehaviour);
  });

  group('constructor', () {
    test('should set fields', () {
      // assert
      expect(track.behaviour, mockBehaviour);
    });
  });
}
