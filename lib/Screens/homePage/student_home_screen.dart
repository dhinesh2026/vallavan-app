import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vallavanapp/Screens/bottomNavbar/student_bottom_nav_bar.dart';
import 'dart:math';

class StudentHomeScreen extends StatefulWidget {
  final String userName;
  const StudentHomeScreen({super.key, this.userName = "Sivaraj"});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  int _selectedIndex = 0;

  // User data
  final String userName = "Dhinesh";
  final int calories = 1240;
  final int steps = 8432;
  final double water = 1.5;
  final double sleep = 6.5;
  final int caloriesGoal = 2450;
  final int stepsGoal = 10000;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Coach tab
        break;
      case 1:
        // Live tab
        break;
      case 2:
        // Hub tab
        break;
      case 3:
        // Fuel tab
        break;
      case 4:
        // Data tab
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Animated Background with Line Design
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  Colors.cyan.shade900.withOpacity(0.3),
                  Colors.deepPurple.shade900.withOpacity(0.5),
                  Colors.black,
                ],
                stops: const [0.2, 0.5, 1.0],
              ),
            ),
          ),

          // Line Design Background - Horizontal Lines
          ...List.generate(15, (index) {
            return Positioned(
              top: (index * 60).toDouble().h,
              left: 0,
              right: 0,
              child: Container(
                height: 1.h,
                width: double.infinity,
                color: Colors.cyan.withOpacity(0.08),
              ),
            );
          }),

          // Line Design Background - Vertical Lines
          ...List.generate(8, (index) {
            return Positioned(
              left: (index * 50).toDouble().w,
              top: 0,
              bottom: 0,
              child: Container(
                width: 1.w,
                height: double.infinity,
                color: Colors.cyan.withOpacity(0.08),
              ),
            );
          }),

          // Animated Floating Orbs
          ...List.generate(4, (index) {
            return Positioned(
              top: 100.h + (index * 200),
              right: -50.w + (index * 80),
              child: TweenAnimationBuilder(
                duration: Duration(seconds: 8 + index),
                tween: Tween<double>(begin: 0, end: 2 * pi),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(sin(value) * 30, cos(value * 0.7) * 30),
                    child: Container(
                      width: 200.w,
                      height: 200.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.cyan.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Static Top Bar with Menu, Title, and Icons
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.cyan.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu Icon
                      Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.menu,
                                color: Colors.cyan,
                                size: 22.sp,
                              ),
                            ),
                          );
                        },
                      ),

                      // App Title - Vallavan Fitness
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.cyan, Colors.cyanAccent],
                        ).createShader(bounds),
                        child: Text(
                          'Vallavan Fitness',
                          style: GoogleFonts.orbitron(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),

                      // Right Side Icons (Profile + Notification)
                      Row(
                        children: [
                          // Notification Icon
                          GestureDetector(
                            onTap: () {
                              // Navigate to notifications screen
                            },
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.1),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.notifications_none,
                                    color: Colors.cyan,
                                    size: 20.sp,
                                  ),
                                ),
                                // Notification Badge
                                Positioned(
                                  top: 6.h,
                                  right: 6.w,
                                  child: Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Profile Icon
                          GestureDetector(
                            onTap: () {
                              // Navigate to profile screen
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.cyan, Colors.deepPurple],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyan.withOpacity(0.5),
                                    blurRadius: 10.r,
                                    spreadRadius: 1.r,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),

                        // Welcome Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Text(
                                    'Our Fitness Family, ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    userName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.cyan,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Start your fitness journey today',
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Stats Grid
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 1.6,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildStatCard(
                                'Calories',
                                '$calories kcal',
                                Icons.local_fire_department,
                                Colors.orange,
                                calories / caloriesGoal,
                              ),
                              _buildStatCard(
                                'Steps',
                                '$steps steps',
                                Icons.directions_walk,
                                Colors.green,
                                steps / stepsGoal,
                              ),
                              _buildStatCard(
                                'Water',
                                '${water.toStringAsFixed(1)} L',
                                Icons.water_drop,
                                Colors.blue,
                                water / 3.0,
                              ),
                              _buildStatCard(
                                'Sleep',
                                '${sleep.toStringAsFixed(1)} H',
                                Icons.bedtime,
                                Colors.purple,
                                sleep / 8.0,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Premium Insights & AI Cards
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildAICard(
                                  'AI Coach',
                                  'Get personalized workout plans',
                                  Icons.fitness_center,
                                  Colors.cyan,
                                  isPremium: true,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildAICard(
                                  'Nutrition AI',
                                  'Smart meal recommendations',
                                  Icons.restaurant,
                                  Colors.purple,
                                  isPremium: true,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Premium Subscription Banner
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildPremiumBanner(),
                        ),

                        SizedBox(height: 20.h),

                        // Daily Workouts
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Daily Workouts',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'See All',
                                  style: GoogleFonts.poppins(
                                    color: Colors.cyan,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 20.w),
                          child: Row(
                            children: [
                              _buildWorkoutCard(
                                'Core Blast Initiation',
                                '15 Mins • Beginner',
                                Icons.fitness_center,
                                Colors.orange,
                                isPremium: true,
                              ),
                              SizedBox(width: 12.w),
                              _buildWorkoutCard(
                                'HIIT Burn',
                                '20 Mins • Intermediate',
                                Icons.flash_on,
                                Colors.red,
                                isPremium: true,
                              ),
                              SizedBox(width: 12.w),
                              _buildWorkoutCard(
                                'Yoga Flow',
                                '30 Mins • All Levels',
                                Icons.self_improvement,
                                Colors.green,
                                isPremium: false,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Live Sessions
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Live Sessions',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Text(
                                  'LIVE NOW',
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              _buildLiveSessionCard(
                                'Zen Flow AI',
                                'Coach Sarah',
                                '15 mins left',
                                Icons.self_improvement,
                                Colors.purple,
                                isPremium: true,
                              ),
                              SizedBox(height: 10.h),
                              _buildLiveSessionCard(
                                'Power HIIT',
                                'Coach Marcus',
                                'Starting in 5 mins',
                                Icons.flash_on,
                                Colors.orange,
                                isPremium: true,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: StudentBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  // Drawer Menu
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.95),
              Colors.black.withOpacity(0.9),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan.withOpacity(0.3),
                    Colors.deepPurple.withOpacity(0.3),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.cyan.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.deepPurple],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    userName,
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'ELITE TIER',
                        style: GoogleFonts.orbitron(
                          color: Colors.amber,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.cyan),
                        ),
                        child: Text(
                          'LVL 42',
                          style: GoogleFonts.orbitron(
                            color: Colors.cyan,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to edit profile
                    },
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.poppins(
                        color: Colors.cyan,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerSectionTitle('Dashboard'),
            _buildDrawerItem(
              icon: Icons.fitness_center,
              title: 'My Workouts',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.video_library,
              title: 'Live Classes',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.restaurant,
              title: 'Nutrition Plans',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.smart_toy,
              title: 'AI Coach',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.emoji_events,
              title: 'Challenges',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.bar_chart,
              title: 'Progress Analytics',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.fastfood,
              title: 'Meal Tracker',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.water_drop,
              title: 'Water Tracker',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.bedtime,
              title: 'Sleep Tracking',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.white24, height: 1),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Navigator.pop(context);
              },
              isLogout: true,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Text(
                    'VALLAVANPRO V2.0.4',
                    style: GoogleFonts.orbitron(
                      color: Colors.white38,
                      fontSize: 10.sp,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '© 2024 Advanced Bio-Optimization',
                    style: GoogleFonts.poppins(
                      color: Colors.white24,
                      fontSize: 8.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: GoogleFonts.orbitron(
          color: Colors.cyan,
          fontSize: 12.sp,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.redAccent : Colors.cyan,
        size: 22.sp,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isLogout ? Colors.redAccent : Colors.white70,
          fontSize: 14.sp,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isLogout ? Colors.redAccent : Colors.white38,
        size: 14.sp,
      ),
      onTap: onTap,
      hoverColor: Colors.cyan.withOpacity(0.1),
      splashColor: Colors.cyan.withOpacity(0.2),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: color, size: 16.sp),
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white24,
              color: color,
              minHeight: 4.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAICard(
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    bool isPremium = false,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), Colors.black.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20.sp),
              if (isPremium)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Text(
                    'PREMIUM',
                    style: GoogleFonts.poppins(
                      color: Colors.amber,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.withOpacity(0.2),
            Colors.deepPurple.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 15.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock Full Fitness Experience',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Personalized Diet, Live Classes & AI Guidance.',
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber, Colors.orange]),
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 10.r,
                ),
              ],
            ),
            child: Text(
              'Upgrade Now',
              style: GoogleFonts.orbitron(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    bool isPremium = false,
  }) {
    return Container(
      width: 180.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              if (isPremium)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Text(
                    'PREMIUM',
                    style: GoogleFonts.poppins(
                      color: Colors.amber,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveSessionCard(
    String title,
    String coach,
    String time,
    IconData icon,
    Color color, {
    bool isPremium = false,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), Colors.black.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  coach,
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isPremium)
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Icon(Icons.lock_outline, color: Colors.amber, size: 16.sp),
            ),
        ],
      ),
    );
  }
}
