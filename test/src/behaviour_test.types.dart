part of 'behaviour_test.dart';

class MockAction<TIn, TOut> extends Mock implements Action<TIn, TOut> {}

class BehaviourImpl<TIn, TOut> extends Behaviour<TIn, TOut> {
  BehaviourImpl({
    required Future<TOut> Function(TIn input, BehaviourTrack? track) action,
    required this.description,
    BehaviourMonitor? monitor,
  })  : _action = action,
        super(monitor: monitor);

  final Future<TOut> Function(TIn input, BehaviourTrack? track) _action;

  @override
  Future<TOut> action(TIn input, BehaviourTrack? track) {
    return _action(input, track);
  }

  @override
  final String description;

  @override
  FutureOr<Exception> onCatch(
    Object e,
    StackTrace stacktrace,
    BehaviourTrack? track,
  ) {
    return Exception();
  }
}

class Action<TIn, TOut> {
  Future<TOut> action(TIn input, BehaviourTrack? track) {
    throw UnimplementedError();
  }
}
