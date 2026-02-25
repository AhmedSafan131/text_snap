import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({required String email, required String password});

  Future<UserModel> signUpWithEmail({required String email, required String password});

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user == null) {
      throw AuthException('Sign in failed');
    }
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<UserModel> signUpWithEmail({required String email, required String password}) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    if (userCredential.user == null) {
      throw AuthException('Sign up failed');
    }

    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }
}
