part of 'behaviour_base_test.dart';

class _BehaviourBaseImpl extends BehaviourBase {
  _BehaviourBaseImpl(BehaviourMonitor monitor) : super(monitor: monitor);

  @override
  String get description => '';

  @override
  FutureOr<Exception> onCatch(
    Object e,
    StackTrace stacktrace,
    BehaviourTrack? track,
  ) {
    return Exception();
  }
}
