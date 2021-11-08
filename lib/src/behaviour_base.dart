import 'package:behaviour/src/behaviour_monitor.dart';

import 'behaviour_mixin.dart';

/// A base class for a behaviour. It implements some abstract properties of a
/// [BehaviourMixin] and injects them through the constructor (like the monitor).
abstract class BehaviourBase with BehaviourMixin {
  /// Super does not need to be called by it's implementers. It only sets the
  /// [monitor] by which the behaviour can be monitored.
  BehaviourBase({this.monitor});

  @override
  final BehaviourMonitor? monitor;
}
