import 'dart:io';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/repository/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

final class AvatarNotifier extends ChangeNotifier with LoggerMixin {
  final AuthRepository _authRepository;

  AvatarNotifier({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final ImagePicker _picker = ImagePicker();

  File? _localAvatar;
  String? _remoteAvatarUrl;
  bool _isLoading = false;

  File? get localAvatar => _localAvatar;
  String? get remoteAvatarUrl => _remoteAvatarUrl;
  bool get isLoading => _isLoading;

  Future<void> loadAvatar() async {
    try {
      final url = await _authRepository.getAvatarUrl();
      _remoteAvatarUrl = url;
      notifyListeners();
    } on Object catch (e, st) {
      logger.error('error loading avatar', error: e, stackTrace: st);
    }
  }

  Future<void> pickAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final file = File(image.path);

      _localAvatar = file;
      _isLoading = true;
      notifyListeners();

      await _authRepository.setAvatarUrl(file);

      await Future.delayed(const Duration(milliseconds: 300));

      String? url;
      for (int i = 0; i < 3; i++) {
        url = await _authRepository.getAvatarUrl();
        if (url != null) break;
        await Future.delayed(const Duration(milliseconds: 200));
      }

      _remoteAvatarUrl = url;
      _localAvatar = null;
      _isLoading = false;
      notifyListeners();
    } on Object catch (e, st) {
      _isLoading = false;
      _localAvatar = null;
      notifyListeners();
      logger.error('error picking avatar', error: e, stackTrace: st);
    }
  }
}
