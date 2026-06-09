import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../services/notification_service.dart';
import '../../firebase_options.dart';
import '../auth/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final startTime = DateTime.now();
    
    print("SplashScreen: Initializing services...");
    
    // Initialize Notifications
    try {
      final notificationService = Provider.of<NotificationService?>(context, listen: false);
      if (notificationService != null) {
        await notificationService.init().timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      print("Notification Init Error: $e");
    }

    // Initialize Firebase
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      print("Firebase Init Error: $e");
    }

    // Ensure splash screen shows for at least 3 seconds
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed.inMilliseconds < 3000) {
      await Future.delayed(Duration(milliseconds: 3000 - elapsed.inMilliseconds));
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.splashGradient,
          ),
        ),
        child: Stack(
          children: [
            // Floating Clouds
            _buildCloud(top: 80, left: 30, size: 60, opacity: 0.3, delay: 0),
            _buildCloud(top: 120, right: 40, size: 50, opacity: 0.2, delay: 1000),
            _buildCloud(bottom: 120, left: 50, size: 55, opacity: 0.25, delay: 500),

            // Sparkles
            _buildSparkle(top: 160, right: 30, size: 30, delay: 300),
            _buildSparkle(bottom: 200, left: 40, size: 24, delay: 800),
            _buildSparkle(top: 220, left: 80, size: 28, delay: 1200),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: Tween(begin: 0.95, end: 1.05).animate(
                      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                    ),
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "👶",
                          style: TextStyle(fontSize: 80),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Minik Adımlar",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Birlikte öğrenelim, birlikte büyüyelim",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bouncing Dots
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      final delay = index * 0.2;
                      final value = Curves.easeInOut.transform(
                        ((_bounceController.value + delay) % 1.0),
                      );
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        transform: Matrix4.translationValues(0, -10 * value, 0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud({double? top, double? bottom, double? left, double? right, required double size, required double opacity, required int delay}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: FadeTransition(
        opacity: Tween(begin: 0.6, end: 1.0).animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
        ),
        child: Icon(
          Icons.cloud,
          size: size,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }

  Widget _buildSparkle({double? top, double? bottom, double? left, double? right, required double size, required int delay}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: ScaleTransition(
        scale: Tween(begin: 0.8, end: 1.2).animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
        ),
        child: Icon(
          Icons.auto_awesome,
          size: size,
          color: Colors.yellow.shade100,
        ),
      ),
    );
  }
}
