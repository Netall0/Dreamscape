import 'dart:async';
import 'package:dreamscape/core/l10n/app_localizations.g.dart';
import 'package:dreamscape/features/alarm/services/alarm_service.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart';
import 'package:uikit/widget/card.dart';

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

  void _setTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });

      final l10n = AppLocalizations.of(context)!;
      final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      
      await widget.alarmService.setAlarm(
        title: l10n.alarmTitle,
        body: l10n.alarmBody,
        hour: time.hour,
        minute: time.minute,
      );

      logger.debug('setalarm');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.alarmSet(timeString)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    return AdaptiveCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: BorderRadius.all(Radius.circular(24)),
      backgroundColor: theme.colors.cardBackground,
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, color: theme.colors.textPrimary),
            Flexible(
              child: TextButton(
                onPressed: () => _setTime(),
                child: Text(
                  _selectedTime == null
                      ? l10n.setYourTime
                      : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                  style: theme.typography.h6,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
