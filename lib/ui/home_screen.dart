import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/ui/dashboard_screen.dart';
import 'package:bodygravity/ui/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white900,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
        currentIndex: index,
        onTap: (newValue) {
          setState(() {
            index = newValue;
          });
        },
        selectedItemColor: AppColors.primary900,
        unselectedItemColor: AppColors.blueGray300,
      ),
      body: index == 0 ? const DashboardScreen() : const ProfileScreen(),
    );
  }
}
