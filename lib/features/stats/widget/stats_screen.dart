import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/home/model/sleep_model.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with LoggerMixin {
  late Future<List<SleepModel>> _sleepModels;

  @override
  void initState() {
    _sleepModels = DependScope.of(
      context,
    ).dependModel.homeSleepRepository.getSleepModel();
    super.initState();
    logger.debug('sleepModel is initialized');
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _sleepModels,
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data![index].sleepTime.toString()),
                subtitle: Text(
                  "you sleep at ${snapshot.data![index].bedTime} and wake up at ${snapshot.data![index].riseTime}",
                ),
              ),
              itemCount: snapshot.data!.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: theme.typography.h6,
              ),
            );
          } else if (snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'No sleep data available',
                style: theme.typography.h6,
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
