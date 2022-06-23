import 'package:behaviour/behaviour.dart';

/// A [BehaviourWithoutInput] is a type which only has one function, it's
/// behaviour. It is comparable with a global function which must be
/// instantiated before it can be used.
///
/// When implementing the behaviour, [TOut] is the type of the return value
/// of the function. If an input parameter is needed, take a look at a
/// [Behaviour].
///
/// A behaviour returns when called an [Future<ExceptionOr<TSuccess>>] value.
/// This can either be a [Failed] or a [Success]. To query which one it is
/// call the [thenWhen] method on the [Future].
abstract class BehaviourWithoutInput<TOut> extends BehaviourBase
    implements BehaviourWithoutInputInterface<TOut> {
  /// Super does not need to be called by it's implementers. It only sets the
  /// [monitor] by which the behaviour can be monitored.
  BehaviourWithoutInput({
    BehaviourMonitor? monitor,
  }) : super(monitor: monitor);

  /// [call] executes the action of the behaviour. If the action is successful,
  /// the return value is wrapped in a [Success] else the exception is wrapped
  /// in a [Failed].
  @override
  Future<ExceptionOr<TOut>> call() {
    return executeAction((track) async => Success(await action(track)));
  }

  /// [action] contains the actual logic of the behaviour.
  ///
  /// [track] can be used for monitoring. The [BehaviourTrack.start],
  /// [BehaviourTrack.end], [BehaviourTrack.stopWithException] and
  /// [BehaviourTrack.stopWithError] are called from the super class.
  @override
  Future<TOut> action(BehaviourTrack? track);
}
