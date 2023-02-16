import 'dart:async';

/// Abstract class which implementers are either a [Failed] or a [Success].
///
/// Which one of the two implementers the actual instance is, can be found using
/// the [when] method. [TSuccess] is the type of the value if the implementation
/// is [Success]. The [Failed] also has this type parameter but can be ignored.
abstract class ExceptionOr<TSuccess> {
  /// Private constructor which prevents other implementations than the ones in
  /// this file.
  const ExceptionOr._();

  /// Executes [ifFailed] if the implementation is [Failed], executes
  /// [ifSuccess] if the implementation is [Success].
  TResult when<TResult>(
    TResult Function(Exception exception) ifFailed,
    TResult Function(TSuccess value) ifSuccess,
  );

  ExceptionOr<TSuccess> whenSuccess(
    void Function(TSuccess value) ifSuccess,
  ) {
    when((exception) {}, ifSuccess);
    return this;
  }

  ExceptionOr<TSuccess> whenFailed(
    void Function(Exception exception) ifFailed,
  ) {
    when(ifFailed, (value) {});
    return this;
  }

  /// Executes [next] only if the current implementation is [Success].
  ExceptionOr<TSecondSuccess> startNextWhenSuccess<TSecondSuccess>(
    ExceptionOr<TSecondSuccess> Function() next,
  ) {
    return when(
      (exception) => Failed(exception),
      (value) => next(),
    );
  }
}

/// Indicates a behaviour failed.
///
/// [TSuccess] can be ignored in this context.
class Failed<TSuccess> extends ExceptionOr<TSuccess> {
  /// Indicates a behaviour failed.
  ///
  /// [reason] is the reason why the behaviour failed.
  const Failed(this.reason) : super._();

  /// The reason why the behaviour failed.
  final Exception reason;

  /// [ifFailed] is executed since this is a [Failed].
  ///
  /// [ifSuccess] can be ignored.
  @override
  TResult when<TResult>(
    TResult Function(Exception exception) ifFailed,
    TResult Function(TSuccess value) ifSuccess,
  ) {
    return ifFailed(reason);
  }

  @override
  bool operator ==(Object other) => other is Failed && other.reason == reason;

  @override
  int get hashCode => reason.hashCode ^ runtimeType.hashCode;
}

/// Indicates a behaviour executed successfully.
///
/// [TSuccess] is the type of the value which the behaviour returns.
class Success<TSuccess> extends ExceptionOr<TSuccess> {
  /// Indicates a behaviour executed successfully.
  ///
  /// [value] is the value which the behaviour returned.
  const Success(this.value) : super._();

  /// The value which the behaviour returned.
  final TSuccess value;

  /// [ifSuccess] is executed since this is a [Success].
  ///
  /// [ifFailed] can be ignored.
  @override
  TResult when<TResult>(
    TResult Function(Exception exception) ifException,
    TResult Function(TSuccess value) ifSuccess,
  ) {
    return ifSuccess(value);
  }

  @override
  bool operator ==(Object other) => other is Success && other.value == value;

  @override
  int get hashCode => value.hashCode ^ runtimeType.hashCode;
}

extension FutureExceptionOrExtensions<T> on Future<ExceptionOr<T>> {
  /// Executes [ifFailed] if the future results in a [Failed], executes
  /// [ifSuccess] if the future results in a[Success].
  Future<TResult> thenWhen<TResult>(
    FutureOr<TResult> Function(Exception exception) ifFailed,
    FutureOr<TResult> Function(T value) ifSuccess,
  ) {
    return then((value) => value.when(ifFailed, ifSuccess));
  }

  /// Executes [ifSuccess] if the future results in a[Success].
  Future<ExceptionOr<T>> thenWhenSuccess<TResult>(
    FutureOr<TResult> Function(T value) ifSuccess,
  ) {
    return then((value) => value.whenSuccess(ifSuccess));
  }

  /// Executes [ifFailed] if the future results in a [Failed].
  Future<ExceptionOr<T>> thenWhenFailed<TResult>(
    FutureOr<TResult> Function(Exception exception) ifFailed,
  ) {
    return then((value) => value.whenFailed(ifFailed));
  }

  /// Executes [next] only if the current future results in a [Success].
  Future<ExceptionOr<TSecondSuccess>> thenStartNextWhenSuccess<TSecondSuccess>(
    Future<ExceptionOr<TSecondSuccess>> Function(T value) next,
  ) {
    return thenWhen(
      (exception) => Failed(exception),
      (value) => next(value),
    );
  }
}
