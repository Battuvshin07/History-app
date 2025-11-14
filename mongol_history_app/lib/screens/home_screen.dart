import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'persons_screen.dart';
import 'events_screen.dart';
import 'maps_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Монголын Түүх'),
            centerTitle: true,
            elevation: 2,
          ),
          body: IndexedStack(
            index: appProvider.selectedIndex,
            children: const [
              PersonsScreen(),
              EventsScreen(),
              MapsScreen(),
              QuizScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appProvider.selectedIndex,
            onTap: (index) {
              appProvider.setSelectedIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Хүмүүс',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Үйл явдал',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Газрын зураг',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz),
                label: 'Quiz',
              ),
            ],
          ),
        );
      },
    );
  }
}
