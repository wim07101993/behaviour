import 'package:behaviour/behaviour.dart';

extension ExceptionOrExtensions<TSuccess> on ExceptionOr<TSuccess> {
  /// Executes [ifFailed] if the implementation is [Failed], executes
  /// [ifSuccess] if the implementation is [Success].
  TResult when<TResult>(
    TResult Function(Exception exception) ifFailed,
    TResult Function(TSuccess value) ifSuccess,
  ) {
    return switch (this) {
      Failed<TSuccess>(reason: final reason) => ifFailed(reason),
      Success<TSuccess>(value: final value) => ifSuccess(value),
    };
  }

  /// Executes [next] only if the current implementation is [Success].
  ExceptionOr<TSecondSuccess> startNextWhenSuccess<TSecondSuccess>(
    ExceptionOr<TSecondSuccess> Function(TSuccess value) next,
  ) {
    return switch (this) {
      Failed<TSuccess>(reason: final reason) => Failed(reason),
      Success<TSuccess>(value: final value) => next(value),
    };
  }
}

extension FutureExceptionOrExtensions<T> on Future<ExceptionOr<T>> {
  /// Executes [ifFailed] if the future results in a [Failed], executes
  /// [ifSuccess] if the future results in a[Success].
  Future<TResult> thenWhen<TResult>(
    FutureOr<TResult> Function(Exception exception) ifFailed,
    FutureOr<TResult> Function(T value) ifSuccess,
  ) {
    return then((value) {
      return switch (value) {
        Failed<T>(reason: final reason) => ifFailed(reason),
        Success<T>(value: final value) => ifSuccess(value),
      };
    });
  }

  /// Executes [next] only if the current future results in a [Success].
  Future<ExceptionOr<TSecondSuccess>> thenStartNextWhenSuccess<TSecondSuccess>(
    FutureOr<ExceptionOr<TSecondSuccess>> Function(T value) next,
  ) {
    return thenWhen((exception) => Failed(exception), next);
  }
}

extension FutureOrExceptionOrExtensions<T> on FutureOr<ExceptionOr<T>> {
  /// Executes [ifFailed] if the future results in a [Failed], executes
  /// [ifSuccess] if the future results in a[Success].
  FutureOr<TResult> thenWhen<TResult>(
    FutureOr<TResult> Function(Exception exception) ifFailed,
    FutureOr<TResult> Function(T value) ifSuccess,
  ) {
    return whenFutureOrValue(
      (future) => future.thenWhen(ifFailed, ifSuccess),
      (value) => value.when(ifFailed, ifSuccess),
    );
  }

  /// Executes [next] only if the current future results in a [Success].
  FutureOr<ExceptionOr<TSecondSuccess>>
      thenStartNextWhenSuccess<TSecondSuccess>(
    FutureOr<ExceptionOr<TSecondSuccess>> Function(T value) next,
  ) {
    return thenWhen((exception) => Failed(exception), next);
  }
}
