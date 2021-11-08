part of 'behaviour_track_test.dart';

class _BehaviourTrackImpl extends BehaviourTrack {
  const _BehaviourTrackImpl(BehaviourMixin behaviour) : super(behaviour);

  @override
  void addAttribute(String key, Object value) {}

  @override
  void end() {}

  @override
  void start() {}

  @override
  void stopWithError(Object error, StackTrace stackTrace) {}

  @override
  void stopWithException(Exception exception, StackTrace stackTrace) {}
}
