import 'package:behaviour/behaviour.dart';
import 'package:mocktail/mocktail.dart';

class MockBehaviourMonitor extends Mock implements BehaviourMonitor {}

class MockBehaviourBase<TIn, TOut> extends Mock implements BehaviourBase {}
