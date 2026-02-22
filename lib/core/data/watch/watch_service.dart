import 'dart:convert';
import 'dart:io' show Platform;

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HealthAuthFailureReason {
  healthConnectNotAvailable,
  activityRecognitionDenied,
  activityRecognitionPermanentlyDenied,
  healthPermissionDenied,
}

final class HealthAuthResult {
  const HealthAuthResult._(this.granted, this.reason);

  final bool granted;
  final HealthAuthFailureReason? reason;

  static const HealthAuthResult success = HealthAuthResult._(true, null);

  static HealthAuthResult failure(HealthAuthFailureReason reason) =>
      HealthAuthResult._(false, reason);
}

final class WatchService {
  static const String _dailyHealthHistoryKey = 'watch_daily_health_history_v1';

  final Health _health = Health();

  final List<HealthDataType> _types = [
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
  ];

  final List<HealthDataType> _testWriteTypes = [
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
  ];

  Future<HealthAuthResult> requestAuthorization({bool allowWriteForTests = false}) async {
    await _health.configure();

    if (Platform.isAndroid) {
      final bool isHealthConnectAvailable = await _health.isHealthConnectAvailable();
      if (!isHealthConnectAvailable) {
        await _health.installHealthConnect();
        return HealthAuthResult.failure(
          HealthAuthFailureReason.healthConnectNotAvailable,
        );
      }

      final PermissionStatus status = await Permission.activityRecognition.request();

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return HealthAuthResult.failure(
          HealthAuthFailureReason.activityRecognitionPermanentlyDenied,
        );
      }

      if (status.isDenied) {
        return HealthAuthResult.failure(
          HealthAuthFailureReason.activityRecognitionDenied,
        );
      }
    }

    final List<HealthDataAccess> permission = _types
        .map((_) => allowWriteForTests ? HealthDataAccess.READ_WRITE : HealthDataAccess.READ)
        .toList();
    final bool granted =
        await _health.requestAuthorization(_types, permissions: permission);
    if (!granted) {
      return HealthAuthResult.failure(
        HealthAuthFailureReason.healthPermissionDenied,
      );
    }
    return HealthAuthResult.success;
  }

  Future<Map<String, dynamic>> fetchTodayData() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
      types: _types,
      startTime: startOfDay,
      endTime: now,
    );

    final List<HealthDataPoint> deduped = Health().removeDuplicates(data); //TODO refactor

    final int steps = deduped
        .where((p) => p.type == HealthDataType.STEPS)
        .fold<int>(0, (sum, p) => sum + (p.value as NumericHealthValue).numericValue.toInt());

    final double calories = deduped
        .where((p) => p.type == HealthDataType.ACTIVE_ENERGY_BURNED)
        .fold<double>(0, (sum, p) => sum + (p.value as NumericHealthValue).numericValue.toDouble());

    final List<double> heartRates = deduped
        .where((p) => p.type == HealthDataType.HEART_RATE)
        .map((p) => (p.value as NumericHealthValue).numericValue.toDouble())
        .toList();

    final double avgHeartRate = heartRates.isNotEmpty
        ? heartRates.reduce((a, b) => a + b) / heartRates.length
        : 0.0;

    final int sleepMinutes = deduped
        .where((p) => p.type == HealthDataType.SLEEP_ASLEEP)
        .fold<int>(0, (sum, p) => sum + p.dateTo.difference(p.dateFrom).inMinutes);

    return {
      'steps': steps,
      'calories': calories.round(),
      'avgHeartRate': avgHeartRate.round(),
      'sleepHours': (sleepMinutes / 60).toStringAsFixed(1),
    };
  }


  bool isDataEmpty(Map<String, dynamic> data) {
    final int steps = (data['steps'] as int?) ?? 0;
    final int calories = (data['calories'] as int?) ?? 0;
    final int avgHeartRate = (data['avgHeartRate'] as int?) ?? 0;
    final double sleepHours = double.tryParse('${data['sleepHours'] ?? 0}') ?? 0.0;
    return steps == 0 && calories == 0 && avgHeartRate == 0 && sleepHours == 0.0;
  }

  Future<void> saveDailySnapshot(
    Map<String, dynamic> data, {
    DateTime? day,
  }) async {
    final Map<String, dynamic> normalized = _normalizeData(data);
    if (isDataEmpty(normalized)) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String rawHistory = prefs.getString(_dailyHealthHistoryKey) ?? '{}';
    final Map<String, dynamic> history =
        (jsonDecode(rawHistory) as Map<String, dynamic>?) ?? <String, dynamic>{};

    history[_dayKey(day ?? DateTime.now())] = normalized;
    await prefs.setString(_dailyHealthHistoryKey, jsonEncode(history));
  }

  Future<Map<String, dynamic>> loadDailySnapshot({DateTime? day}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String rawHistory = prefs.getString(_dailyHealthHistoryKey) ?? '{}';
    final Map<String, dynamic> history =
        (jsonDecode(rawHistory) as Map<String, dynamic>?) ?? <String, dynamic>{};
    final Object? snapshot = history[_dayKey(day ?? DateTime.now())];
    if (snapshot is Map<String, dynamic>) {
      return _normalizeData(snapshot);
    }
    if (snapshot is Map) {
      return _normalizeData(Map<String, dynamic>.from(snapshot));
    }
    return <String, dynamic>{};
  }

  // TESTING ONLY
  Future<void> insertTestData() async {
    final bool granted = await _health.requestAuthorization(
      _testWriteTypes,
      permissions: _testWriteTypes.map((_) => HealthDataAccess.READ_WRITE).toList(),
    );
    if (!granted) {
      throw StateError('Health write permission denied');
    }

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    DateTime sleepStart = now.subtract(const Duration(hours: 3));
    if (sleepStart.isBefore(startOfDay)) {
      sleepStart = startOfDay.add(const Duration(minutes: 5));
    }
    final DateTime sleepEnd = sleepStart.add(const Duration(hours: 2));

    await _health.writeHealthData(
      value: 0,
      type: HealthDataType.SLEEP_ASLEEP,
      startTime: sleepStart,
      endTime: sleepEnd.isAfter(now) ? now : sleepEnd,
    );
    await _health.writeHealthData(
      value: 8500,
      type: HealthDataType.STEPS,
      startTime: now.subtract(const Duration(hours: 8)),
      endTime: now.subtract(const Duration(hours: 1)),
    );
    await _health.writeHealthData(
      value: 72,
      type: HealthDataType.HEART_RATE,
      startTime: now.subtract(const Duration(hours: 2)),
      endTime: now.subtract(const Duration(hours: 2)).add(const Duration(minutes: 1)),
    );
  }

  String _dayKey(DateTime date) {
    final String year = date.year.toString().padLeft(4, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Map<String, dynamic> _normalizeData(Map<String, dynamic> data) {
    final int steps = (data['steps'] as num?)?.toInt() ?? int.tryParse('${data['steps'] ?? 0}') ?? 0;
    final int calories =
        (data['calories'] as num?)?.toInt() ?? int.tryParse('${data['calories'] ?? 0}') ?? 0;
    final int avgHeartRate = (data['avgHeartRate'] as num?)?.toInt() ??
        int.tryParse('${data['avgHeartRate'] ?? 0}') ??
        0;
    final double sleepHours = (data['sleepHours'] as num?)?.toDouble() ??
        double.tryParse('${data['sleepHours'] ?? 0}') ??
        0.0;

    return <String, dynamic>{
      'steps': steps,
      'calories': calories,
      'avgHeartRate': avgHeartRate,
      'sleepHours': sleepHours.toStringAsFixed(1),
    };
  }
}
