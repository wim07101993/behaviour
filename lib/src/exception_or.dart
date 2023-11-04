/// Abstract class which implementers are either a [Failed] or a [Success].
///
/// Which one of the two implementers the actual instance is, can be found using
/// the [when] method. [TSuccess] is the type of the value if the implementation
/// is [Success]. The [Failed] also has this type parameter but can be ignored.
sealed class ExceptionOr<TSuccess> {
  /// Private constructor which prevents other implementations than the ones in
  /// this file.
  const ExceptionOr._(this._value);

  final dynamic _value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (runtimeType != other.runtimeType || other is! ExceptionOr) {
      return false;
    }
    return _value == other._value;
  }

  @override
  int get hashCode => _value.hashCode ^ runtimeType.hashCode;
}

/// Indicates a behaviour failed.
///
/// [TSuccess] can be ignored in this context.
class Failed<TSuccess> extends ExceptionOr<TSuccess> {
  /// Indicates a behaviour failed.
  ///
  /// [reason] is the reason why the behaviour failed.
  const Failed(this.reason) : super._(reason);

  /// The reason why the behaviour failed.
  final Exception reason;
}

/// Indicates a behaviour executed successfully.
///
/// [TSuccess] is the type of the value which the behaviour returns.
class Success<TSuccess> extends ExceptionOr<TSuccess> {
  /// Indicates a behaviour executed successfully.
  ///
  /// [value] is the value which the behaviour returned.
  const Success(this.value) : super._(value);

  /// The value which the behaviour returned.
  final TSuccess value;
}
