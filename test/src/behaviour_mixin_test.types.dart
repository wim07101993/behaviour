part of 'behaviour_mixin_test.dart';

class _MockOnCatch extends Mock implements _OnCatch {}

class _BareBehaviourMixinImpl with BehaviourMixin {}

class _BehaviourMixinImpl with BehaviourMixin {
  _BehaviourMixinImpl({
    this.monitor,
    FutureOr<Exception> Function(
      Exception e,
      StackTrace stackTrace,
      BehaviourTrack? track,
    )? onCatchException,
    FutureOr<Exception> Function(
      Object e,
      StackTrace stackTrace,
      BehaviourTrack? track,
    )? onCatchError,
  })  : _onCatchException = onCatchException,
        _onCatchError = onCatchError;

  @override
  BehaviourMonitor? monitor;

  final FutureOr<Exception> Function(Exception, StackTrace, BehaviourTrack?)?
      _onCatchException;

  final FutureOr<Exception> Function(Object, StackTrace, BehaviourTrack?)?
      _onCatchError;

  @override
  FutureOr<Exception> onCatchException(
    Exception e,
    StackTrace stackTrace,
    BehaviourTrack? track,
  ) {
    final fakeCatch = _onCatchException;
    return fakeCatch != null
        ? fakeCatch(e, stackTrace, track)
        : super.onCatchException(e, stackTrace, track);
  }

  @override
  FutureOr<Exception> onCatchError(
    Object e,
    StackTrace stackTrace,
    BehaviourTrack? track,
  ) {
    final fakeCatch = _onCatchError;
    return fakeCatch != null
        ? fakeCatch(e, stackTrace, track)
        : super.onCatchError(e, stackTrace, track);
  }
}

class _OnCatch {
  FutureOr<Exception> onCatch(
    Object e,
    StackTrace stackTrace,
    BehaviourTrack? track,
  ) {
    throw UnimplementedError();
  }
}
