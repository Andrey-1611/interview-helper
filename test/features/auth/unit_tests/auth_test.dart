import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/app/global_services/user/models/my_user.dart';
import 'auth_test_data.dart';
import 'auth_test_setup.dart';

void main() {
  late AuthTestSetup setup;

  setUp(() {
    setup = AuthTestSetup();
    setup.setUp();
  });

  group('Auth', () {
    test('sign in', () async {
      final MyUser result = await setup.dataSource.signIn(testUser, testPassword);
      expect(result.email, testUser.email);
    });

    test('sign up', () async {
      final MyUser result = await setup.dataSource.signUp(testUser, testPassword);
      expect(result.email, testUser.email);
    });
  });
}
