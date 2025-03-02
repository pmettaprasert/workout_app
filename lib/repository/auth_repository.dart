import '../service/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository(this._authService);

  // Expose sign in anonymously
  Future<User?> signInAnonymously() async {
    return await _authService.signInAnonymously();
  }

  // Optionally, you can expose currentUser and other helper methods.
  User? get currentUser => _authService.currentUser;
}
