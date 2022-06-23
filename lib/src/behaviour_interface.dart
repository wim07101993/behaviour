import 'package:behaviour/behaviour.dart';

/// A [BehaviourInterface] is a type which only has one function, it's
/// behaviour. It is comparable with a global function which must be
/// instantiated before it can be used.
///
/// When implementing the behaviour, [TIn] is the type of the input parameter
/// and [TOut] is the type of the return value of the function. If no input
/// parameter is needed take a look at a [BehaviourWithoutInput].
///
/// A behaviour returns when called an [Future<ExceptionOr<TSuccess>>] value.
/// This can either be a [Failed] or a [Success]. To query which one it is
/// call the [thenWhen] method on the [Future].
abstract class BehaviourInterface<TIn, TOut> {
  /// [call] executes the action of the behaviour. If the action is successful,
  /// the return value is wrapped in a [Success] else the exception is wrapped
  /// in a [Failed].
  Future<ExceptionOr<TOut>> call(TIn input);

  /// [action] contains the actual logic of the behaviour.
  ///
  /// This method can throw exceptions. Call the [call] method if you want to
  /// catch these exceptions with an [ExceptionOr]
  ///
  /// [track] can be used for monitoring. The [BehaviourTrack.start],
  /// [BehaviourTrack.end], [BehaviourTrack.stopWithException] and
  /// [BehaviourTrack.stopWithError] are called from the super class.
  Future<TOut> action(TIn input, BehaviourTrack? track);
}
