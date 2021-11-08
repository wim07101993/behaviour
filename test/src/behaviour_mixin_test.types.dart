part of 'behaviour_mixin_test.dart';

class _MockOnCatch extends Mock implements _OnCatch {}

class _BareBehaviourMixinImpl with BehaviourMixin {
  @override
  String get description => '';

  @override
  FutureOr<Exception> onCatch(
      Object e, StackTrace stacktrace, BehaviourTrack? track) {
    return Exception();
  }
}

class _BehaviourMixinImpl with BehaviourMixin {
  _BehaviourMixinImpl({
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
  BehaviourMonitor? monitor;

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

class _OnCatch {
  FutureOr<Exception> onCatch(
    Object e,
    StackTrace stacktrace,
    BehaviourTrack? track,
  ) {
    throw UnimplementedError();
  }
}
