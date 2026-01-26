import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart';
import 'package:uikit/colors/color_constant.dart';
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

class _AlarmTimePickerWidgetState extends State<AlarmTimePickerWidget>
    with LoggerMixin {
  TZDateTime? _tzDateTime;
  TimeOfDay? _selectedTime;

  late final StreamSubscription<TZDateTime?>? _streamSubscription;

  @override
  void initState() {
    _streamSubscription = widget.alarmService.alarmStreamController.listen((
      data,
    ) {
      if (mounted) {
        setState(() {
          _tzDateTime = data;
          _selectedTime = data != null
              ? TimeOfDay(hour: data.hour, minute: data.minute)
              : null;
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
      _selectedTime = TimeOfDay(
        hour: _tzDateTime!.hour,
        minute: _tzDateTime!.minute,
      );
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });

      await widget.alarmService.setAlarm(
        title: 'title',
        body: 'body',
        hour: time.hour,
        minute: time.minute,
      );

      logger.debug('setalarm');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Будильник установлен на ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    return AdaptiveCard(
      padding: const .symmetric(horizontal: 16),
      borderRadius: const .all(.circular(24)),
      backgroundColor: ColorConstants.pastelIndigo,
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: .center,
          children: [
            const Icon(Icons.notifications),
            TextButton(
              onPressed: () => _setTime(),
              child: Text(
                _selectedTime == null
                    ? 'set your time'
                    : '${_selectedTime!.hour}:${_selectedTime!.minute}',
                // : 'set your time',
                style: theme.typography.h6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
