part of 'behaviour_base_test.dart';

class BehaviourBaseImpl extends BehaviourBase {
  BehaviourBaseImpl(BehaviourMonitor monitor) : super(monitor: monitor);

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
