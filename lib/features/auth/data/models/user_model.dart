import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({required super.uid, required super.email, super.displayName, super.photoUrl});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(uid: user.uid, email: user.email ?? '', displayName: user.displayName, photoUrl: user.photoURL);
  }

  AppUser toEntity() {
    return AppUser(uid: uid, email: email, displayName: displayName, photoUrl: photoUrl);
  }
}
