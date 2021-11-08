import 'behaviour_mixin.dart';

/// A track by which a [BehaviourMixin] can be monitored.
///
/// Monitors the start, end and stop (crash) of a behaviour. To indicate the
/// behaviour execution has started invoke [start], when it ends successfully,
/// invoke [end]. If the execution crashes stops unsuccessfully because of an
/// exception, invoke [stopWithException]. If the execution stops unsuccessfully
/// due to any other reason, invoke [stopWithError].
///
/// If more attributes are available for monitoring/logging/... they can be set
/// using the [addAttribute] method.
abstract class BehaviourTrack {
  const BehaviourTrack(this.behaviour);

  /// The behaviour for which this track is created.
  final BehaviourMixin behaviour;

  /// Starts the track. Indicates that the behaviour has started its
  /// functionality.
  void start();

  /// Ends the track. Indicates that the behaviour has finished its
  /// functionality successfully.
  void end();

  /// Ends the track. Indicates that the behaviour stopped unexpectedly with
  /// as cause an exception.
  void stopWithException(Exception exception, StackTrace stackTrace);

  /// Ends the track. Indicates that the behaviour stopped unexpectedly with an
  /// unknown error.
  void stopWithError(Object error, StackTrace stackTrace);

  /// Adds an attribute as a key-value-pair.
  void addAttribute(String key, Object value);
}

/// Factory class for [BehaviourTrack].
abstract class BehaviourMonitor {
  /// Creates a track to monitor the activity of a behaviour from.
  BehaviourTrack? createBehaviourTrack(BehaviourMixin behaviour);
}
