import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../../core/database/database.dart';
import '../../../core/util/extension/time_of_day_extension.dart';

enum SleepQuality {
  bad('bad', Icon(Icons.sentiment_very_dissatisfied)),
  normal('normal', Icon(Icons.sentiment_neutral)),
  good('good', Icon(Icons.sentiment_very_satisfied));

  const SleepQuality(this.name, this.icon);
  final String name;
  final Icon icon;
}

extension SleepQualityExtension on String {
  static SleepQuality fromName(String name) => SleepQuality.values.firstWhere(
    (element) => element.name == name,
    orElse: () => SleepQuality.normal,
  );
}

final class StatsModel {
  StatsModel({
    this.id,
    required this.sleepDate,
    required this.sleepQuality,
    required this.sleepTime,
    required this.bedTime,
    required this.riseTime,
    required this.sleepNotes,
  });

  factory StatsModel.fromDriftRow(SleepInfoTableData row) => StatsModel(
    id: row.id,
    sleepDate: row.sleepData != null ? DateTime.fromMillisecondsSinceEpoch(row.sleepData!) : null,
    sleepQuality: SleepQuality.values.firstWhere(
      (element) => element.name == row.sleepQuality,
      orElse: () => SleepQuality.normal,
    ),
    bedTime: (row.bedTime ?? 0).toTimeOfDayToMiutes(),
    riseTime: (row.riseTime ?? 0).toTimeOfDayToMiutes(),
    sleepNotes: row.notes ?? '',
    sleepTime: (row.sleepDurationMinutes ?? 0).toTimeOfDayToMiutes(),
  );
  final int? id;
  final DateTime? sleepDate;
  final SleepQuality sleepQuality;
  final TimeOfDay bedTime;
  final TimeOfDay riseTime;
  final TimeOfDay sleepTime;
  final String sleepNotes;

  static int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  SleepInfoTableCompanion toSleepInfoTableCompanion(StatsModel sleepModel) =>
      SleepInfoTableCompanion(
        id: id != null ? Value(sleepModel.id!) : const Value.absent(),
        sleepData: Value(sleepModel.sleepDate?.millisecondsSinceEpoch),
        sleepQuality: Value(sleepModel.sleepQuality.name),
        sleepDurationMinutes: Value(_timeOfDayToMinutes(sleepModel.sleepTime)),
        bedTime: Value(_timeOfDayToMinutes(sleepModel.bedTime)),
        riseTime: Value(_timeOfDayToMinutes(sleepModel.riseTime)),
        notes: Value(sleepModel.sleepNotes),
      );

  StatsModel copyWith({
    int? id,
    SleepQuality? sleepQuality,
    DateTime? sleepData,
    TimeOfDay? sleepTime,
    TimeOfDay? bedTime,
    TimeOfDay? riseTime,
    String? sleepNotes,
  }) => StatsModel(
    id: id ?? this.id,
    sleepDate: sleepData ?? this.sleepDate,
    sleepQuality: sleepQuality ?? this.sleepQuality,
    sleepTime: sleepTime ?? this.sleepTime,
    bedTime: bedTime ?? this.bedTime,
    riseTime: riseTime ?? this.riseTime,
    sleepNotes: sleepNotes ?? this.sleepNotes,
  );
}
