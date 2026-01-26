import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/util/logger/logger.dart';
import 'i_auth_repository.dart';

final class AuthRepository with LoggerMixin implements IAuthRepository {

  AuthRepository() {
    _supabase = Supabase.instance.client;
    _userId =
        _supabase.auth.currentUser?.id ??
        'eb2debd7-bbdc-429d-978b-64a2b0b99906'; //TODO: remove
  }
  late final SupabaseClient _supabase;
  late final String _userId;

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

      final String url = _supabase.storage.from('avatars').getPublicUrl(path);
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
      final Uint8List imageBytes = await file.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: 512,
        targetHeight: 512,
      );
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert image');
      }

      final Uint8List compressedBytes = byteData.buffer.asUint8List();
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

  @override
  Future<String?> getUserName() async {
    return _supabase.auth.currentUser?.userMetadata?['name'].toString();
  }

  @override
  Future<void> setUserName(String newUserName) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(data: {'name': newUserName}),
      );
    } on Object catch (e, st) {
      logger.error('error in setting user name', error: e, stackTrace: st);
      rethrow;
    }
  }
}
