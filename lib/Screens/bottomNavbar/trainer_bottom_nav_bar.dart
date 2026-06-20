import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

// Import your trainer screens
import 'package:vallavanapp/Screens/homePage/trainer_home_screen.dart';
import 'package:vallavanapp/Screens/trainerClasses/trainer_classes_list_screen.dart';
import 'package:vallavanapp/Screens/trainerMembershipDash/trainer_membership_student_dash.dart';
import 'package:vallavanapp/Screens/trainerRevenueDashboard/trainer_revenue_screen.dart';
import 'package:vallavanapp/Screens/trainer_Analytics/trainer_analytics_screen.dart';

class TrainerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TrainerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.video_library),
        label: 'Classes',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Students',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.analytics),
        label: 'Analytics',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        label: 'Earnings',
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
        // Navigate to Trainer Home Screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TrainerHomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        // Navigate to Live Classes Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrainerLiveClassesScreen()),
        );
        break;
      case 2:
        // Navigate to Members Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrainerMembershipDashboard()),
        );
        break;
      case 3:
        // Navigate to Analytics/Reports Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrainerAnalyticsDashboard()),
        );
        break;
      case 4:
        // Navigate to Earnings Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrainerRevenueDashboard()),
        );
        break;
    }
  }
}