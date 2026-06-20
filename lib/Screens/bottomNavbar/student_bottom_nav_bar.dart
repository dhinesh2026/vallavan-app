import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vallavanapp/Screens/dataProgress/data_progress_screen.dart';
import 'dart:ui';

// Import your screens
import 'package:vallavanapp/Screens/homePage/student_home_screen.dart';
import 'package:vallavanapp/Screens/hubActivity/hub_activity_screen.dart';
import 'package:vallavanapp/Screens/liveClass/live_classes_screen.dart';
import 'package:vallavanapp/Screens/nutritionFuel/nutrition_fuel_screen.dart';

class StudentBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const StudentBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Coach',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.video_library),
        label: 'Live',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        label: 'Activity',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.restaurant),
        label: 'Fuel',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.trending_up),
        label: 'Progress',
      ),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              onTap(index);
              _navigateToScreen(context, index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.cyan,
            unselectedItemColor: Colors.white54,
            selectedLabelStyle: GoogleFonts.poppins(fontSize: 10.sp),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10.sp),
            items: items,
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Navigate to Coach/Home Screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        // Navigate to Live Classes Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LiveClassesScreen()),
        );
        break;
      case 2:
        // Navigate to Activity Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ActivityScreen()),
        );
        break;
      case 3:
        // Navigate to Fuel/Nutrition Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NutritionScreen()),
        );
        break;
      case 4:
        // Navigate to Progress Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProgressScreen()),
        );
        break;
    }
  }
}