import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class IAuthRepository {
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password);

  Future<void> setAvatarUrl(File file);
  Future<String?> getAvatarUrl();

  Future<String?> getUserName();
  Future<void> setUserName(String newUserName);

  Future<String?> getPhoneNumber();
  Future<void> setPhoneNumber(String phoneNumber);

  Future<void> signOut();

  User? getCurrentUser();
  Stream<User?> getAuthStateChanges();
}
