import 'dart:async';

extension FutureOrExtensions<T> on FutureOr<T> {
  FutureOr<TOut> whenFutureOrValue<TOut>(
    FutureOr<TOut> Function(Future<T> future) future,
    FutureOr<TOut> Function(T value) value,
  ) {
    return switch (this) {
      Future<T>() => future(this as Future<T>),
      T() => value(this as T),
    };
  }
}
