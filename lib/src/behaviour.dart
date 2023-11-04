import 'dart:async';

import 'package:behaviour/behaviour.dart';

/// A [Behaviour] is a type which only has one function, it's behaviour. It is
/// comparable with a global function which must be instantiated before it can
/// be used.
///
/// When implementing the behaviour, [TIn] is the type of the input parameter
/// and [TOut] is the type of the return value of the function. If no input
/// parameter is needed take a look at a [BehaviourWithoutInput].
///
/// A behaviour returns when called an [Future<ExceptionOr<TSuccess>>] value.
/// This can either be a [Failed] or a [Success]. To query which one it is
/// call the [thenWhen] method on the [Future].
abstract class Behaviour<TIn, TOut> extends BehaviourBase
    implements BehaviourInterface<TIn, TOut> {
  /// Super does not need to be called by it's implementers. It only sets the
  /// [monitor] by which the behaviour can be monitored.
  Behaviour({super.monitor});

  /// [call] executes the action of the behaviour. If the action is successful,
  /// the return value is wrapped in a [Success] else the exception is wrapped
  /// in a [Failed].
  @override
  FutureOr<ExceptionOr<TOut>> call(TIn input) {
    return executeAction((track) {
      return action(input, track).whenFutureOrValue(
        (future) => future.then((result) => Success(result)),
        (result) => Success(result),
      );
    });
  }

  /// [action] contains the actual logic of the behaviour.
  ///
  /// [track] can be used for monitoring. The [BehaviourTrack.start],
  /// [BehaviourTrack.end], [BehaviourTrack.stopWithException] and
  /// [BehaviourTrack.stopWithError] are called from the super class.
  @override
  FutureOr<TOut> action(TIn input, BehaviourTrack? track);
}
