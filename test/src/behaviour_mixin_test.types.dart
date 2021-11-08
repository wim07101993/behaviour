part of 'behaviour_mixin_test.dart';

class MockOnCatch extends Mock implements OnCatch {}

class MockBehaviourTrack extends Mock implements BehaviourTrack {}

class BehaviourMixinImpl with BehaviourMixin {
  BehaviourMixinImpl({
    this.monitor,
    required this.description,
    required FutureOr<Exception> Function(
      Object e,
      StackTrace stacktrace,
      BehaviourTrack? track,
    )
        onCatch,
  }) : _onCatch = onCatch;

  @override
  final BehaviourMonitor? monitor;
  @override
  final String description;

  final FutureOr<Exception> Function(
    Object e,
    StackTrace stacktrace,
    BehaviourTrack? track,
  ) _onCatch;

  @override
  FutureOr<Exception> onCatch(
    Object e,
    StackTrace stacktrace,
    BehaviourTrack? track,
  ) {
    return _onCatch(e, stacktrace, track);
  }
}

class OnCatch {
  FutureOr<Exception> onCatch(
    Object e,
    StackTrace stacktrace,
    BehaviourTrack? track,
  ) {
    throw UnimplementedError();
  }
}
