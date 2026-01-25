import 'dart:io';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/repository/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

final class LoadInfoNotifier extends ChangeNotifier with LoggerMixin {
  final AuthRepository _authRepository;

  LoadInfoNotifier({required AuthRepository authRepository}) : _authRepository = authRepository;

  final ImagePicker _picker = ImagePicker();

  String? _userName;
  String? get userName => _userName;

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  File? _localAvatar;
  String? _remoteAvatarUrl;
  bool _isLoading = false;

  File? get localAvatar => _localAvatar;
  String? get remoteAvatarUrl => _remoteAvatarUrl;
  bool get isLoading => _isLoading;

  Future<void> loadUserInfo() async {
    try {
      final url = await _authRepository.getAvatarUrl();
      final name = await _authRepository.getUserName();
      final phone = await _authRepository.getPhoneNumber();

      _userName = name;
      _remoteAvatarUrl = url;
      _phoneNumber = phone;
      notifyListeners();
    } on Object catch (e, st) {
      logger.error('error loading user info', error: e, stackTrace: st);
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

  Future<void> setPhoneNumber(String newPhoneNumber) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authRepository.setPhoneNumber(newPhoneNumber);

      _phoneNumber = newPhoneNumber;
      _isLoading = false;
      notifyListeners();
    } on Object catch (e) {
      _isLoading = false;
      notifyListeners();
      logger.error('error changing phone number', error: e);
      rethrow;
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

      await Future<void>.delayed(const Duration(milliseconds: 300));

      String? url;
      for (int i = 0; i < 3; i++) {
        url = await _authRepository.getAvatarUrl();
        if (url != null) break;
        await Future<void>.delayed(const Duration(milliseconds: 200));
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
