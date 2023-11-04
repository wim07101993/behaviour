part of 'behaviour_without_input_test.dart';

class _MockAction<TOut> extends Mock implements _Action<TOut> {}

class _BehaviourWithoutInputImpl<TOut> extends BehaviourWithoutInput<TOut> {
  _BehaviourWithoutInputImpl({
    required FutureOr<TOut> Function(BehaviourTrack? track) action,
    required this.description,
    super.monitor,
  }) : _action = action;

  final FutureOr<TOut> Function(BehaviourTrack? track) _action;

  @override
  FutureOr<TOut> action(BehaviourTrack? track) {
    return _action(track);
  }

  @override
  final String description;
}

class _Action<TOut> {
  FutureOr<TOut> action(BehaviourTrack? track) {
    throw UnimplementedError();
  }
}

class _DummyType {
  _DummyType(this.value);

  final int value;
}
