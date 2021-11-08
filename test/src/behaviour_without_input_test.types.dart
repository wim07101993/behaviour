part of 'behaviour_without_input_test.dart';

class MockAction<TOut> extends Mock implements Action<TOut> {}

class BehaviourWithoutInputImpl<TOut> extends BehaviourWithoutInput<TOut> {
  BehaviourWithoutInputImpl({
    required Future<TOut> Function(BehaviourTrack? track) action,
    required this.description,
    BehaviourMonitor? monitor,
  })  : _action = action,
        super(monitor: monitor);

  final Future<TOut> Function(BehaviourTrack? track) _action;

  @override
  Future<TOut> action(BehaviourTrack? track) {
    return _action(track);
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

class Action<TOut> {
  Future<TOut> action(BehaviourTrack? track) {
    throw UnimplementedError();
  }
}
