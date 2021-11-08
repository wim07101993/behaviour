import 'dart:async';

import 'behaviour_monitor.dart';
import 'exception_or.dart';

/// An alias for a function which returns a
/// [FutureOr<ExceptionOr<TOut>>]. A [track] parameter is passed with which
/// additional information can be monitored if needed.
typedef Action<TOut> = FutureOr<ExceptionOr<TOut>> Function(
  BehaviourTrack? track,
);

/// Contains the logic behind a behaviour. It has an
/// [executeAction] method which can execute an action within a try-catch block.
mixin BehaviourMixin {
  /// A factory which generates the tracks with which executions of the action
  /// are monitored.
  BehaviourMonitor? get monitor => null;

  /// Describes what the action does in the form of:
  /// doing work.
  String get description;

  /// A tag by which the behaviour can be found in e.g. logging.
  ///
  /// By default the tag is the name of the type.
  String get tag => runtimeType.toString();

  /// Executes an action within a try catch block.
  ///
  /// It creates a track by which the action can be monitored. The start, end,
  /// stopWithException and stopWithError methods are all called automatically
  /// and when an something is caught, an 'exception' or 'error' attribute
  /// is added to the track.
  ///
  /// When something is caught in the try catch, the [onCatch] method is called
  /// with the caught object, stacktrace and track as parameters. The result
  /// of this [onCatch] method is then wrapped within a [Failed] and is returned.
  Future<ExceptionOr<TOut>> executeAction<TOut>(Action<TOut> action) async {
    final track = monitor?.createBehaviourTrack(this);
    try {
      track?.start();
      final either = await action(track);
      track?.end();
      return either;
    } on Exception catch (exception, stackTrace) {
      track?.stopWithException(exception, stackTrace);
      return Failed(await onCatch(exception, stackTrace, track));
    } catch (error, stackTrace) {
      track?.stopWithError(error, stackTrace);
      return Failed(await onCatch(error, stackTrace, track));
    }
  }

  /// Is invoked when something is caught by the try-catch block in
  /// [executeAction].
  ///
  /// [e] and [stackTrace] are passed directly from the catch parameters.
  /// [track] is the track with which the curren action is being monitored.
  FutureOr<Exception> onCatch(
    Object e,
    StackTrace stacktrace,
    BehaviourTrack? track,
  );
}
