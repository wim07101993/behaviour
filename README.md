# Behaviour

[![codecov](https://codecov.io/gh/wim07101993/behaviour/branch/master/graph/badge.svg?token=2QPYSSZT03)](https://codecov.io/gh/wim07101993/behaviour)

Behaviours are classes of which the instances are used as functions.

## Why?

When writing code it is best to keep concerns separated and code testable. A
behaviour helps with this. It is comparable with a global function which must be
instantiated before it can be used. Because it is like a global function it only
has one concern: executing one piece of logic, one behaviour. Because it still
is a class, it can be injected where needed and/or mocked in testing.

A behaviour itself will never throw an exception. All exceptions/errors are
caught and returned in a `ExceptionOr<TSuccess>` format which is either a
`Failed` or a `Success`. The `Failed` contains the exception and the `Success`
contains the return value if any.

## Getting started

## With input

`Behaviour<TIn, TOut>`

The standard behaviour receives an input parameter of type `TIn` and returns a
`TOut`. If no output parameter is required it can be made `void`. A behaviour
returns when called an `Future<ExceptionOr<TSuccess>>` value. For more details
about that look at the [Return value](#Return-value).

```dart
class CreateCustomer extends Behaviour<CreateCustomerParams, void> {
  @override
  Future<void> action(CreateCustomerParams input, BehaviourTrack? track) {
    // TODO logic to create a customer
    return Future.value();
  }
}

class CreateCustomerParams {
  const CreateCustomerParams({
    required this.name,
    required this.address,
    required this.phoneNumber,
  });

  final String name;
  final String address;
  final String phoneNumber;
}
```

## Without input

`BehaviourWithoutInput<TOut>`

This behaviour does not receive an input parameter and returns a `TOut`. If no
output parameter is required it can be made `void`. A behaviour returns when
called an `ExceptionOr<TSuccess>` value. For more details about that look at
the [Return value](#Return-value).

```dart 
class GetProfileData extends BehaviourWithoutInput<ProfileData> {
  @override
  Future<ProfileData> action(BehaviourTrack? track) {
    return Future.value(ProfileData(
      name: 'Wim',
      birthday: DateTime(1993, 10, 07),
    ));
  }
}

class ProfileData {
  const ProfileData({
    required this.name,
    required this.birthday,
  });

  final String name;
  final DateTime birthday;
}
```

## Return value

The return value of a behaviour is always an `ExceptionOr<TSuccess>` value. This
is an abstract class with two implementers: `Failed<TSuccess>`
and `Success<TSuccess>` with each an `exception` and `value` property
respectively. To determine what the received value is, the `when` method is
provided (and `thenWhen` for async methods).

```dart
Future<void> main() {
  await getProfileData().thenWhen(
    (exception) => log('Exception: $exception'),
    (value) => log('value: $value'),
  );
}
```

## Behaviour monitor

To monitor what the behaviour is doing a `BehaviourMonitor` exits. This is a 
factory class which creates a `BehaviourTrack`. During the call of a behaviour,
the different methods of this track are called. 
- `start` when the action is executed
- `end` when the action has successfully been completed.
- `stopWithException` when an exception happens.
- `stopWithError` when anything else is caught.

This monitor can be used to do logging/analytics/...