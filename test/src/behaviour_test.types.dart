part of 'behaviour_test.dart';

class _MockAction<TIn, TOut> extends Mock implements _Action<TIn, TOut> {}

class _BehaviourImpl<TIn, TOut> extends Behaviour<TIn, TOut> {
  _BehaviourImpl({
    required FutureOr<TOut> Function(TIn input, BehaviourTrack? track) action,
    required this.description,
    super.monitor,
  }) : _action = action;

  final FutureOr<TOut> Function(TIn input, BehaviourTrack? track) _action;

  @override
  FutureOr<TOut> action(TIn input, BehaviourTrack? track) {
    return _action(input, track);
  }

  @override
  final String description;
}

class _Action<TIn, TOut> {
  FutureOr<TOut> action(TIn input, BehaviourTrack? track) {
    throw UnimplementedError();
  }
}

class _DummyType {
  _DummyType(this.value);

  final int value;
}
