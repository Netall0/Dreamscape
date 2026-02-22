// ---- GENERATED CODE - DO NOT MODIFY BY HAND ----     
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// A plugin to handle permissions in a cross-platform way.
abstract class Permit {
  static const _channel = MethodChannel('permit.plugin/permissions');

  /// Opens the app settings page.
  ///
  /// Returns [true] if the app settings page could be opened, otherwise [false].
  static Future<bool> openSettings() async {
    try {
      await _channel.invokeMethod<bool>('open_settings');
      return true;
    } on PlatformException {
      return false;
    }
  }

  /// Permission to access the device's activity (recognition).
  /// 
  /// Android:
  /// - Manifest permission: android.permission.ACTIVITY_RECOGNITION
  /// - Required to access physical activity data such as step count and movement recognition
  /// 
  /// Returns [PermissionStatus.notApplicable] for platforms other than (android)
  static const activityRecognition = Permission._('activity_recognition', _channel, platforms: {'android'});

 
}

/// Represents a specific permission that can be requested or checked.
class Permission {
  final String name;
  final MethodChannel _channel;
  final Set<String> platforms;

  // ignore: unused_element_parameter
  const Permission._(this.name, this._channel, {this.platforms = const {}});

  bool get _isPlatformSupported {
    return platforms.contains(Platform.operatingSystem);
  }

  Future<PermissionStatus> get status async {
    if (!_isPlatformSupported) {
      return PermissionStatus.notApplicable;
    }
    final int statusValue = await _channel.invokeMethod<int>(
          'check_permission_status',
          {'permission': name},
        ) ??
        0;
    return PermissionStatus.fromValue(statusValue);
  }

  Future<PermissionStatus> request() async {
    if (!_isPlatformSupported) {
      return PermissionStatus.notApplicable;
    }
    final int statusValue = await _channel.invokeMethod<int>(
          'request_permission',
          {'permission': name},
        ) ??
        0;
    return PermissionStatus.fromValue(statusValue);
  }

  Future<bool> get shouldShowRequestRationale async {
    if (!Platform.isAndroid) return false;
    return await _channel.invokeMethod<bool>(
          'should_show_rationale',
          {'permission': name},
        ) ??
        false;
  }
}

/// Defines the different states a permission can be in.
enum PermissionStatus {
  /// Permission is denied or has not been requested yet.
  denied(0),
  /// Permission is granted.
  granted(1),
  /// User is not allowed to use the requested feature.  *Only supported on iOS.*
  restricted(2),
  /// User has authorized this application for limited access.  *Only supported on iOS (iOS14+).*
  limited(3),
  /// Permission is permanently denied, the permission dialog will not be shown when requesting this permission.
  permanentlyDenied(4),
  /// Permission is provisionally granted.   *Only supported on iOS.*
  provisional(5),
  /// Platform does not support this permission.
  notApplicable(6);

  final int value;

  const PermissionStatus(this.value);

  factory PermissionStatus.fromValue(int value) => values[value];

  bool get isDenied => this == PermissionStatus.denied;

  bool get isGranted => this == PermissionStatus.granted;

  bool get isRestricted => this == PermissionStatus.restricted;

  bool get isLimited => this == PermissionStatus.limited;

  bool get isPermanentlyDenied => this == PermissionStatus.permanentlyDenied;

  bool get isProvisional => this == PermissionStatus.provisional;

  bool get isNotApplicable => this == PermissionStatus.notApplicable;
}


