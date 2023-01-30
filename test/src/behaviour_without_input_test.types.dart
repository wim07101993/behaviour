part of 'behaviour_without_input_test.dart';

class _MockAction<TOut> extends Mock implements _Action<TOut> {}

class _BehaviourWithoutInputImpl<TOut> extends BehaviourWithoutInput<TOut> {
  _BehaviourWithoutInputImpl({
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
}

class _Action<TOut> {
  Future<TOut> action(BehaviourTrack? track) {
    throw UnimplementedError();
  }
}
