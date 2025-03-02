import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInAnonymously() async {
    try {
      if (_firebaseAuth.currentUser != null) {

        return _firebaseAuth.currentUser;
      }
      final result = await _firebaseAuth.signInAnonymously();
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;
}
