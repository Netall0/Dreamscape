import 'package:dreamscape/core/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uikit/uikit.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> with LoggerMixin {
  late ValueNotifier<int> dividerNotifier;

  @override
  void initState() {
    super.initState();
    dividerNotifier = ValueNotifier<int>(0);
  }

  void onPress(int index) {
    dividerNotifier.value = index;
    logInfo(index.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final layout = LayoutInherited.of(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: CustomScrollView(
        slivers: [
          //APPBAR
          SliverAppBar(
            backgroundColor: Colors.transparent,
            titleSpacing: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 12, left: 16, right: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discover', style: theme.typography.h3),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search, size: 28),
                  ),
                ],
              ),
            ),
            expandedHeight: AppSizes.screenHeightOfContext(context) * 0.15,
            centerTitle: false,
          ),

          //DIVIDER FOR CARD
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
              child: ValueListenableBuilder(
                valueListenable: dividerNotifier,
                builder: (context, value, child) {
                  return Row(
                    children: List.generate(4, (i) {
                      return [
                        Expanded(
                          child: InkWell(
                            onTap: () => onPress(i),
                            child: Divider(
                              color: value == i ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                        if (i != 3) const SizedBox(width: 4),
                      ];
                    }).expand((w) => w).toList(),
                  );
                },
              ),
            ),
          ),

          //Card
          SliverToBoxAdapter(
            child: ValueListenableBuilder(
              valueListenable: dividerNotifier,
              builder: (context, value, child) {
                return Row(
                  children: List.generate(4, (i) {
                    return [
                      Expanded(
                        child: InkWell(
                          onTap: () => onPress(i),
                          child: AdaptiveCard(
                            backgroundColor: value == i
                                ? Colors.red
                                : Colors.green,
                            child: Text(i.toString()),
                          ),
                        ),
                      ),
                      if (i != 3) const SizedBox(width: 4),
                    ];
                  }).expand((w) => w).toList(),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSizes.screenHeightOfContext(context) * 0.05,
            ),
          ),

          //RECOMMENDED
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSizes.screenHeightOfContext(context) * 0.1,
              child: Padding(
                padding: .all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('recommended', style: theme.typography.h6),
                    Text(
                      'see all',
                      style: theme.typography.h6.copyWith(
                        color: theme.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSizes.screenHeightOfContext(context) * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: AppSizes.screenHeightOfContext(context) * 0.3,
                      child: AdaptiveCard(
                        padding: layout.padding,
                        margin: layout.padding,
                        backgroundColor: theme.colors.primary,
                        child: Text('sas'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          //RECENT
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSizes.screenHeightOfContext(context) * 0.1,
              child: Padding(
                padding: .all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('recommended', style: theme.typography.h6),
                    Text(
                      'see all',
                      style: theme.typography.h6.copyWith(
                        color: theme.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: layout.columns,
                crossAxisSpacing: layout.spacing,
                mainAxisSpacing: layout.spacing,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    AdaptiveCard(child: Center(child: Text('sas'))),
                childCount: 6, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
