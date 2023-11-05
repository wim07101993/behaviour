import 'dart:developer';

import 'package:behaviour/behaviour.dart';

class CreateCustomer extends Behaviour<CreateCustomerParams, void> {
  @override
  Future<void> action(CreateCustomerParams input, BehaviourTrack? track) {
    log('TODO create customer: ${input.name} - ${input.phoneNumber}');
    return Future.value();
  }

  @override
  FutureOr<Exception> onCatchError(
    Object e,
    StackTrace stackTrace,
    BehaviourTrack? track,
  ) {
    return Exception('An unknown error occurred: $e');
  }
}

class CreateCustomerParams {
  const CreateCustomerParams({
    required this.name,
    required this.phoneNumber,
  });

  final String name;
  final String phoneNumber;
}

Future<void> main() async {
  final createCustomer = CreateCustomer();
  await createCustomer(
    const CreateCustomerParams(
      name: 'Wim',
      phoneNumber: '+32 xxx xx xx xx',
    ),
  );
}
