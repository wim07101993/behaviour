import 'package:behaviour/behaviour.dart';

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
  String get description => tag;

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
  /// with the caught object, stackTrace and track as parameters. The result
  /// of this [onCatch] method is then wrapped within a [Failed] and is returned.
  FutureOr<ExceptionOr<TOut>> executeAction<TOut>(Action<TOut> action) {
    final track = monitor?.createBehaviourTrack(this);
    try {
      track?.start();
      final futureOr = action(track);
      if (futureOr is ExceptionOr<TOut>) {
        track?.end();
        return futureOr;
      }
      return _catchFutureError(futureOr, track);
    } catch (error, stackTrace) {
      return _catch(error, stackTrace, track);
    }
  }

  Future<ExceptionOr<TOut>> _catchFutureError<TOut>(
    Future<ExceptionOr<TOut>> future,
    BehaviourTrack? track,
  ) async {
    try {
      return await future;
    } catch (error, stackTrace) {
      return _catch(error, stackTrace, track);
    }
  }

  FutureOr<ExceptionOr<TOut>> _catch<TOut>(
    Object error,
    StackTrace stackTrace,
    BehaviourTrack? track,
  ) {
    final futureOrException = error is Exception
        ? onCatchException(error, stackTrace, track)
        : onCatchError(error, stackTrace, track);

    return futureOrException.whenFutureOrValue(
      (future) => future.then((exception) => Failed(exception)),
      (exception) => Failed(exception),
    );
  }

  /// Is invoked when an exception is caught by the try-catch block in
  /// [executeAction].
  ///
  /// [exception] and [stackTrace] are passed directly from the catch parameters.
  /// [track] is the track with which the current action is being monitored.
  ///
  /// When overriding this method, the track should be stopped manually or the
  /// super method should be called to invoke it.
  FutureOr<Exception> onCatchException(
    Exception exception,
    StackTrace stackTrace,
    BehaviourTrack? track,
  ) {
    track?.stopWithException(exception, stackTrace);
    return exception;
  }

  /// Is invoked when something which is not an exception is caught by the
  /// try-catch block in [executeAction].
  ///
  /// [error] and [stackTrace] are passed directly from the catch parameters.
  /// [track] is the track with which the current action is being monitored.
  ///
  /// When overriding this method, the track should be stopped manually or the
  /// super method should be called to invoke it.
  FutureOr<Exception> onCatchError(
    Object error,
    StackTrace stackTrace,
    BehaviourTrack? track,
  ) {
    track?.stopWithError(error, stackTrace);
    if (error is Exception) {
      return error;
    } else {
      return Exception('Unknown exception: $error');
    }
  }
}
