// import 'dart:async';

// import 'package:flutter/material.dart';

// import '../../../core/service/ai/controller/ai_controller.dart';
// import '../../../core/service/ai/scope/ai_scope.dart';
// import '../../initialization/widget/depend_scope.dart';
// import '../model/stats_model.dart';

// class AnalyzeStatsScreen extends StatefulWidget {
//   const AnalyzeStatsScreen({super.key, required this.sleepHistory});

//   final List<StatsModel> sleepHistory;

//   @override
//   State<AnalyzeStatsScreen> createState() => _AnalyzeStatsScreenState();
// }

// class _AnalyzeStatsScreenState extends State<AnalyzeStatsScreen> {
//   late final StreamSubscription sub;
//   late final AiSleepController _controller;

//   @override
//   void initState() {
//     _controller = AiScope.of(context);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     sub.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: ListenableBuilder(
//       listenable: _controller,
//       builder: (context, _) => SingleChildScrollView(
//         child: Column(crossAxisAlignment: .start, children: [

//             ],

//             ),
//       ),
//     ),
//   );
// }

// class TypingDots extends StatefulWidget {
//   const TypingDots({super.key});

//   @override
//   State<TypingDots> createState() => _TypingDotsState();
// }

// class _TypingDotsState extends State<TypingDots> with SingleTickerProviderStateMixin {
//   late final AnimationController _conrtoller;

//   @override
//   void initState() {
//     _conrtoller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _conrtoller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: List.generate(3, (index) {

//       return AnimatedBuilder(animation: _conrtoller, builder: (context, child) {
//         return });


//     }));
//   }
// }
