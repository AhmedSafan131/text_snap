import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, AppUser>> call({required String email, required String password}) async {
    return await repository.signInWithEmail(email: email, password: password);
  }
}
