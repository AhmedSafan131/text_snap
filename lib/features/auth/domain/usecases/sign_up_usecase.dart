import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return await repository.signUpWithEmail(email: email, password: password, displayName: displayName);
  }
}
