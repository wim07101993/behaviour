import 'dart:async';
import 'dart:developer';

import 'package:behaviour/behaviour.dart';

class GetProfileData extends BehaviourWithoutInput<ProfileData> {
  @override
  Future<ProfileData> action(BehaviourTrack? track) {
    return Future.value(ProfileData(
      name: 'Wim',
      birthday: DateTime(1993, 10, 07),
    ));
  }

  @override
  String get description => 'getting profile data';

  @override
  FutureOr<Exception> onCatch(
    Object e,
    StackTrace stacktrace,
    BehaviourTrack? track,
  ) {
    return Exception('An unknown error occurred: $e');
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

Future<void> main() async {
  final getProfileData = GetProfileData();
  await getProfileData().thenWhen(
    (exception) => log('Exception: $exception'),
    (value) => log('value: $value'),
  );
}
