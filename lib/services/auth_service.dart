import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth =FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();


  Future<String?> signIn({
    required String email,
    required String password,
}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);

    }
  }

  Future<String?> register({
    required String email,
    required String password,
})async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
      );
      await result.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    }on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case'user-not-found':
        return 'No User Found With This Email';
      case'wrong-password':
        return 'Wrong-Password';
      case'email-already-in-use':
        return 'An Account Already Exists With This Email';
      case'invalid-email':
        return 'The Email Address is Invalid';
      case'weak-password':
        return 'The Password Is Too Weak';
      case'operation-not-allowed':
        return 'Operation not Allowed. Please Contact Support';
      case'user-disabled':
        return 'This User Account Has Been disabled';
      default:
          return 'An Error Occurred. Please Try Again';
    }
  }

}