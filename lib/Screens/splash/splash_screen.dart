import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vallavanapp/Screens/authService/auth_service.dart';
import 'package:vallavanapp/Screens/homePage/student_home_screen.dart';
import 'package:vallavanapp/Screens/homePage/trainer_home_screen.dart';
import 'package:vallavanapp/Screens/roleSelection/role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    Timer(const Duration(seconds: 4), () async {
      await _checkLogin();
    });
  }

  Future<void> _checkLogin() async {
    final role = await AuthService().autoLogin();

    if (role == "trainer") {
      Get.offAll(() => const TrainerHomeScreen());
    } else if (role == "student") {
      Get.offAll(() => const StudentHomeScreen());
    } else {
      Get.offAll(() => const RoleSelectionScreen());
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
      backgroundColor: const Color(0xFF020617),

      body: Stack(
        children: [
          /// TOP LEFT GLOW
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.35),
                    blurRadius: 120,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM RIGHT GLOW
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.08),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.35),
                    blurRadius: 120,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          /// PARTICLES
          ...List.generate(
            25,
            (index) => Positioned(
              top: (index * 32).toDouble(),
              left: (index * 14).toDouble(),
              child: Container(
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          /// MAIN CONTENT
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// LOGO
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.45),
                              blurRadius: 80,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/images/splash_logo.png",
                          width: 220,
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// APP NAME
                      const Text(
                        "Vallavan Fitness",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// SUBTITLE
                      Text(
                        "AI Powered Fitness Ecosystem",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.60),
                          fontSize: 15,
                          letterSpacing: 0.5,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 36),

                      /// LOADING ANIMATION
                      LoadingAnimationWidget.waveDots(
                        color: const Color(0xFF3B82F6),
                        size: 46,
                      ),

                      const SizedBox(height: 18),

                      /// LOADING TEXT
                      Text(
                        "Preparing your experience...",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 13,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
