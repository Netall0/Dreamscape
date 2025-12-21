import 'package:dreamscape/core/services/alarm/alarm_service.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/extension/app_context_extension.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart';
import 'package:uikit/colors/color_constant.dart';
import 'package:uikit/widget/card.dart';

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _tzDateTime = DependScope.of(
      context,
    ).platformDependContainer.alarmService.getAlarmTime();

    if (_tzDateTime != null) {
      _selectedTime = TimeOfDay(
        hour: _tzDateTime!.hour,
        minute: _tzDateTime!.minute,
      );
    }
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
    final theme = context.appTheme;
    return AdaptiveCard(
      margin: .symmetric(horizontal: 70),

      borderRadius: .all(.circular(24)),
      backgroundColor: ColorConstants.pastelIndigo,
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.notifications),
          TextButton(
            onPressed: () => _setTime(),
            child: Text(
              _selectedTime == null
                  ? 'set your time'
                  : '${_selectedTime!.hour}:${_selectedTime!.minute}',
              style: theme.typography.h6,
            ),
          ),
        ],
      ),
    );
  }
}
