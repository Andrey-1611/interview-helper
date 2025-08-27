import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/*Future<void> saveUser(UserData user) async {
    try {
      await _usersCollection().doc(user.id).set(user.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }*/

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}



void main() {

  setUp(() {});


  group('firestore', () {
    test('save user', () async {

    });
  });
}
