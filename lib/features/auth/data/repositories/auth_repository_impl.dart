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

  Future<Either<Failure, T>> _onCall<T>(Future<T> Function() operation) async {
    try {
      return Right(await operation());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getErrorMessage(e.code)));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmail({required String email, required String password}) {
    return _onCall(() async {
      final user = await remoteDataSource.signInWithEmail(email: email, password: password);
      return user.toEntity();
    });
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmail({required String email, required String password}) {
    return _onCall(() async {
      final user = await remoteDataSource.signUpWithEmail(email: email, password: password);
      return user.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> signOut() {
    return _onCall(() => remoteDataSource.signOut());
  }

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() {
    return _onCall(() async {
      final user = await remoteDataSource.getCurrentUser();
      return user?.toEntity();
    });
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((user) => user?.toEntity());
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'Wrong password or wrong email';
      case 'user-not-found':
        return 'Wrong email';
      case 'wrong-password':
        return 'Wrong password';
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
