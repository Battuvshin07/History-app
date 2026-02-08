// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
// import 'providers/app_provider.dart';

// void main() {
//   runApp(const MongolHistoryApp());
// }

// class MongolHistoryApp extends StatelessWidget {
//   const MongolHistoryApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AppProvider()),
//       ],
//       child: MaterialApp(
//         title: 'Монголын Түүх',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           useMaterial3: true,
//         ),
//         home: const HomeScreen(),
//       ),
//     );
//   }
// }
