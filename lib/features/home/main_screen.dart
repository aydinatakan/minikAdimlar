import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'home_screen.dart';
import 'modules_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onSeeAllModules: () => _onItemTapped(1)),
          const ModulesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            backgroundColor: Colors.white,
            indicatorColor: AppColors.primary.withOpacity(0.1),
            height: 80,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.cottage_outlined),
                selectedIcon: Icon(Icons.cottage, color: AppColors.primary),
                label: 'Ana Sayfa',
              ),
              NavigationDestination(
                icon: Icon(Icons.toys_outlined),
                selectedIcon: Icon(Icons.toys, color: AppColors.primary),
                label: 'Modüller',
              ),
              NavigationDestination(
                icon: Icon(Icons.face_outlined),
                selectedIcon: Icon(Icons.face, color: AppColors.primary),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
