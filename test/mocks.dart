import 'package:behaviour/behaviour.dart';
import 'package:mocktail/mocktail.dart';

class MockBehaviourBase<TIn, TOut> extends Mock implements BehaviourBase {}

class MockBehaviourMonitor extends Mock implements BehaviourMonitor {}

class MockBehaviourTrack extends Mock implements BehaviourTrack {}
