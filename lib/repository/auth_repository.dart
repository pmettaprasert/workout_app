import '../service/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository(this._authService);

  Future<User?> signInAnonymously() async {
    return await _authService.signInAnonymously();
  }


  User? get currentUser => _authService.currentUser;
}
