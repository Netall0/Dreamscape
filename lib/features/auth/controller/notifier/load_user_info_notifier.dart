import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/logger/logger.dart';
import '../../repository/auth_repository.dart';

final class LoadInfoNotifier extends ChangeNotifier with LoggerMixin {

  LoadInfoNotifier({required AuthRepository authRepository})
    : _authRepository = authRepository;
  final AuthRepository _authRepository;

  final ImagePicker _picker = ImagePicker();

  String? _userName;
  String? get userName => _userName;

  File? _localAvatar;
  String? _remoteAvatarUrl;
  bool _isLoading = false;

  File? get localAvatar => _localAvatar;
  String? get remoteAvatarUrl => _remoteAvatarUrl;
  bool get isLoading => _isLoading;

  Future<void> loadUserInfo() async {
    try {
      final String? url = await _authRepository.getAvatarUrl();
      final String? name = await _authRepository.getUserName();

      _userName = name;
      _remoteAvatarUrl = url;
      notifyListeners();
    } on Object catch (e, st) {
      logger.error('error loading avatar', error: e, stackTrace: st);
    }
  }

  Future<void> setUserName(String newUserName) async {
    try {
      await _authRepository.setUserName(newUserName);

      _userName = newUserName;
      notifyListeners();
    } on Object catch (e) {
      logger.error('error changing username', error: e);
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
      for (var i = 0; i < 3; i++) {
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
