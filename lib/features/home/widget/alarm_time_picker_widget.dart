// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart';
import 'package:uikit/theme/app_theme.dart';
import 'package:uikit/widget/card.dart';

import '../../../core/util/extension/app_context_extension.dart';
import '../../../core/util/logger/logger.dart';
import '../../alarm/services/alarm_service.dart';

class AlarmTimePickerWidget extends StatefulWidget {
  const AlarmTimePickerWidget({super.key, required this.alarmService});
  final AlarmService alarmService;

  @override
  State<AlarmTimePickerWidget> createState() => _AlarmTimePickerWidgetState();
}

class _AlarmTimePickerWidgetState extends State<AlarmTimePickerWidget> with LoggerMixin {
  TZDateTime? _tzDateTime;
  TimeOfDay? _selectedTime;

  late final StreamSubscription<TZDateTime?>? _streamSubscription;

  @override
  void initState() {
    _streamSubscription = widget.alarmService.alarmStreamController.listen((data) {
      if (mounted) {
        setState(() {
          _tzDateTime = data;
          _selectedTime = data != null ? TimeOfDay(hour: data.hour, minute: data.minute) : null;
        });

        logger.debug('update UI ');
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _tzDateTime = widget.alarmService.getAlarmTime();

    if (_tzDateTime != null) {
      _selectedTime = TimeOfDay(hour: _tzDateTime!.hour, minute: _tzDateTime!.minute);
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setTime() async {
    if (context.mounted) {
      const bool forceIOS = bool.fromEnvironment('FORCE_IOS', defaultValue: false);
      final bool isIOS = forceIOS || Theme.of(context).platform == TargetPlatform.iOS;
      final TimeOfDay? time = isIOS
          ? await showCupertinoModalPopup<TimeOfDay>(
              context: context,
              builder: (context) {
                TimeOfDay tempTime = _selectedTime ?? TimeOfDay.now();
                return Container(
                  height: 300,
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          onPressed: () => Navigator.of(context).pop(tempTime),
                          child: Text(context.l10n.save),
                        ),
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: DateTime(2000, 1, 1, tempTime.hour, tempTime.minute),
                          onDateTimeChanged: (dateTime) {
                            tempTime = TimeOfDay.fromDateTime(dateTime);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : await showTimePicker(context: context, initialTime: _selectedTime ?? TimeOfDay.now());

      if (time != null) {
        setState(() {
          _selectedTime = time;
        });

        if (mounted) {
          await widget.alarmService.setAlarm(
            title: context.l10n.alarmNotificationTitle,
            body: context.l10n.alarmNotificationBody,
            hour: time.hour,
            minute: time.minute,
          );
        }

        logger.debug('setalarm');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${context.l10n.alarmSetForPrefix} '
                '${time.hour.toString().padLeft(2, '0')}:'
                '${time.minute.toString().padLeft(2, '0')}',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    return AdaptiveCard(
      padding: const .symmetric(horizontal: 16),
      borderRadius: const .all(.circular(24)),
      backgroundColor: theme.colors.primary,
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Icon(Icons.notifications, color: theme.colors.onPrimary),
            TextButton(
              onPressed: () => _setTime(),
              child: Text(
                _selectedTime == null
                    ? context.l10n.alarmSetButton
                    : '${_selectedTime!.hour}:${_selectedTime!.minute}',
                style: theme.typography.h6.copyWith(color: theme.colors.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
