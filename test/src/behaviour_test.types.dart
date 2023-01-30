part of 'behaviour_test.dart';

class _MockAction<TIn, TOut> extends Mock implements _Action<TIn, TOut> {}

class _BehaviourImpl<TIn, TOut> extends Behaviour<TIn, TOut> {
  _BehaviourImpl({
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
}

class _Action<TIn, TOut> {
  Future<TOut> action(TIn input, BehaviourTrack? track) {
    throw UnimplementedError();
  }
}
