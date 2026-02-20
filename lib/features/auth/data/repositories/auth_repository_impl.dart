import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AppUser>> signInWithEmail({required String email, required String password}) async {
    try {
      final user = await remoteDataSource.signInWithEmail(email: email, password: password);
      return Right(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getErrorMessage(e.code)));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmail(email: email, password: password, displayName: displayName);
      return Right(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getErrorMessage(e.code)));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to sign out'));
    }
  }

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user == null) return const Right(null);
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to get current user'));
    }
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((user) => user?.toEntity());
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}
