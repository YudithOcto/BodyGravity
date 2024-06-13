import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/constants.dart';
import 'package:bodygravity/common/extension.dart';
import 'package:bodygravity/data/local/storage_service.dart';
import 'package:bodygravity/di/di_container.dart';
import 'package:bodygravity/ui/auth/login_screen.dart';
import 'package:bodygravity/ui/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final storageService = locator<StorageService>();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    String? token = await storageService.getData(Constants.bearerToken);
    if (!mounted) return;
    if (token.isNotNullOrEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.yellow500, AppColors.green600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animation,
                child: const Icon(
                  Icons.sports_gymnastics,
                  color: Colors.white,
                  size: 100.0,
                ),
              ),
              const SizedBox(height: 20.0),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
