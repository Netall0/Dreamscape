import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/home/model/sleep_model.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:dreamscape/features/stats/controller/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uikit/uikit.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with LoggerMixin {
  late final StatsController _statsController;
  @override
  void initState() {
    _statsController = DependScope.of(context).dependModel.statsController;

    super.initState();
    logger.debug('sleepModel is initialized');
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Stats', style: theme.typography.h1),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: .symmetric(horizontal: 16),
        child: StreamBuilder<List<SleepModel>>(
          stream: _statsController.sleepModelsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final sleepModels = snapshot.data ?? [];

            if (sleepModels.isEmpty) {
              return const Center(child: Text('No sleep models found'));
            }

            return Center(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final model = sleepModels[index];
                  return Card(
                    color: ColorConstants.midnightBlue,
                    child: ListTile(
                      title: Text(
                        'you sleep time was ${model.sleepTime.hour}:${model.sleepTime.minute}',
                        style: theme.typography.h4,
                      ),
                      subtitle: Text(
                        'you go to sleep at ${model.bedTime.hour} : ${model.bedTime.minute} and wake up at ${model.riseTime.hour} : ${model.riseTime.minute}',
                        style: theme.typography.h6,
                      ),
                    ),
                  );
                },
                itemCount: sleepModels.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
