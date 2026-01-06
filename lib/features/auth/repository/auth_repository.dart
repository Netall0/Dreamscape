import 'dart:io';
import 'dart:ui' as ui;

import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/repository/i_auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class AuthRepository with LoggerMixin implements IAuthRepository {
  late final SupabaseClient _supabase;
  late final String _userId;

  AuthRepository() {
    _supabase = Supabase.instance.client;
    _userId =
        _supabase.auth.currentUser?.id ??
        'eb2debd7-bbdc-429d-978b-64a2b0b99906'; //TODO: remove
  }

  @override
  Stream<User?> getAuthStateChanges() {
    try {
      return _supabase.auth.onAuthStateChange.map((data) => data.session?.user);
    } on Object catch (e, st) {
      logger.error('error getting current user', stackTrace: st, error: e);
      rethrow;
    }
  }

  @override
  User? getCurrentUser() {
    try {
      return _supabase.auth.currentUser;
    } on Object catch (e, st) {
      logger.error('error getting current user', stackTrace: st, error: e);
      rethrow;
    }
  }

  @override
  Future<String?> getAvatarUrl() async {
    try {
      final path = 'upload/$_userId';

      try {
        await _supabase.storage.from('avatars').download(path);
      } catch (e) {
        logger.info('avatar file does not exist: $e');
        return null;
      }

      final url = _supabase.storage.from('avatars').getPublicUrl(path);
      logger.info('avatar url: $url');
      final imageUrl = Uri.parse(url)
          .replace(
            queryParameters: {
              't': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          )
          .toString();
      return imageUrl;
    } on Object catch (e, st) {
      logger.error('error in getting avatar url', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> setAvatarUrl(File file) async {
    try {
      final imageBytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: 512,
        targetHeight: 512,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert image');
      }

      final compressedBytes = byteData.buffer.asUint8List();
      final path = 'upload/$_userId';

      await _supabase.storage
          .from('avatars')
          .uploadBinary(
            path,
            compressedBytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/png',
            ),
          );

      try {
        await _supabase.storage.from('avatars').download(path);
        logger.info('avatar uploaded successfully');
      } catch (e) {
        logger.error('avatar upload verification failed: $e');
        throw Exception('File upload verification failed');
      }
    } on Object catch (e, st) {
      logger.error('error in uploading avatar', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(password: password, email: email);
      logger.info('sign in successful');
    } on Object catch (e, st) {
      logger.error('failed in sign in ', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    logger.info('sign out successful');
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signUp(password: password, email: email);
      logger.info('sign up successful');
    } on Object catch (e, st) {
      logger.error('failed in sign Up', error: e, stackTrace: st);
      rethrow;
    }
  }
}
