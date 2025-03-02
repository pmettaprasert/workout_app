import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  AuthViewModel(this._authRepository) {
    _initialize();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _initialize() async {
    try {
      _user = await _authRepository.signInAnonymously();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Public method to re-trigger anonymous sign-in if needed.
  Future<void> signInAnonymously() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authRepository.signInAnonymously();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
