// import 'package:flutter/material.dart';
// import 'package:uikit/theme/app_theme.dart';

// import '../../../core/util/extension/app_context_extension.dart';

// class NewsScreen extends StatefulWidget {
//   const NewsScreen({super.key});

//   @override
//   State<NewsScreen> createState() => _NewsScreenState();
// }

// class _NewsScreenState extends State<NewsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final AppTheme theme = context.appTheme;
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           const SliverAppBar(title: Text('Articles')),
//           SliverGrid.builder(
//             itemCount: 3,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//             itemBuilder: (context, index) {

//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
