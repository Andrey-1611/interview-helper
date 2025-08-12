import 'package:firebase_auth/firebase_auth.dart';
import 'package:interview_master/app/global_services/user/models/my_user.dart';
import 'package:mocktail/mocktail.dart';


const String testEmail = 'test@test.com';
const String testUid = '1234';
const String testName = 'test';
const String testPassword = 'test1234';
final testUser = MyUser(name: testName, email: testEmail);


class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}
