import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/bottomNavbar/trainer_bottom_nav_bar.dart';
import 'package:vallavanapp/Screens/trainerClasses/trainer_create_class_screen.dart';
import 'package:vallavanapp/Screens/trainerClasses/trainer_schedule_screen.dart';
import 'package:vallavanapp/Screens/trainerClasses/trainer_upload_screen.dart';

class TrainerHomeScreen extends StatefulWidget {
  final String userName;
  const TrainerHomeScreen({super.key, this.userName = "Coach Sivaraj"});

  @override
  State<TrainerHomeScreen> createState() => _TrainerHomeScreenState();
}

class _TrainerHomeScreenState extends State<TrainerHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  int _selectedIndex = 0;

  // Trainer Data - Using widget.userName instead of hardcoded value
  int _totalMembers = 1284;
  int _activeClasses = 24;
  double _monthlyRevenue = 14250.00;
  double _memberGrowth = 12.0;

  // Upcoming Sessions
  final List<Map<String, dynamic>> _upcomingSessions = [
    {
      'title': 'HIIT Power Hour',
      'time': '10:00 AM',
      'members': 42,
      'status': 'live',
      'color': Colors.red,
    },
    {
      'title': 'Core Blast AI',
      'time': '02:30 PM',
      'members': 18,
      'status': 'waiting',
      'color': Colors.orange,
    },
    {
      'title': 'Sunset Yoga Flow',
      'time': '05:00 PM',
      'members': 65,
      'status': 'waiting',
      'color': Colors.green,
    },
  ];

  // Quick Actions
  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.add_circle_outline,
      'label': 'Create Class',
      'color': Colors.cyan,
    },
    {'icon': Icons.schedule, 'label': 'Schedule Live', 'color': Colors.purple},
    {'icon': Icons.upload_file, 'label': 'Upload', 'color': Colors.orange},
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('trainer_scaffold'),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Animated Background
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
                color: Colors.cyan.withOpacity(0.05),
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
                color: Colors.cyan.withOpacity(0.05),
              ),
            );
          }),

          // Animated Floating Orbs
          ...List.generate(3, (index) {
            return Positioned(
              top: 150.h + (index * 180),
              right: -50.w + (index * 80),
              child: TweenAnimationBuilder(
                duration: Duration(seconds: 8 + index),
                tween: Tween<double>(begin: 0, end: 2 * pi),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(sin(value) * 30, cos(value * 0.7) * 30),
                    child: Container(
                      width: 120.w,
                      height: 120.w,
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
                // Top Bar with Menu, Title, Profile & Notification
                Container(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
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
                      // Menu Icon - Using Builder to get correct context
                      Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.menu,
                                color: Colors.cyan,
                                size: 20.sp,
                              ),
                            ),
                          );
                        },
                      ),

                      // App Title
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.cyan, Colors.cyanAccent],
                        ).createShader(bounds),
                        child: Text(
                          'VallavanFitness',
                          style: GoogleFonts.orbitron(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),

                      // Right Side Icons (Notification + Profile)
                      Row(
                        children: [
                          // Notification Icon
                          GestureDetector(
                            onTap: () {},
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
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.notifications_none,
                                    color: Colors.cyan,
                                    size: 18.sp,
                                  ),
                                ),
                                Positioned(
                                  top: 5.h,
                                  right: 5.w,
                                  child: Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // Profile Icon
                          GestureDetector(
                            onTap: () {},
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
                                    blurRadius: 8.r,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18.sp,
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
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),

                        // Greeting Section - FIXED: Using widget.userName
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Evening,',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 13.sp,
                              ),
                            ),
                            Text(
                              widget.userName, // FIXED: Using passed userName
                              style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '3 Live Sessions Today',
                              style: GoogleFonts.poppins(
                                color: Colors.cyan,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Stats Row (3 cards in a row)
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                '${_totalMembers}',
                                'TOTAL MEMBERS',
                                '+${_memberGrowth.toStringAsFixed(0)}%',
                                Icons.people,
                                Colors.cyan,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _buildStatCard(
                                '$_activeClasses',
                                'ACTIVE CLASSES',
                                'Today',
                                Icons.video_library,
                                Colors.purple,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _buildStatCard(
                                '\$${_monthlyRevenue.toStringAsFixed(0)}',
                                'MONTHLY REVENUE',
                                '+8%',
                                Icons.attach_money,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 14.h),

                        // AI Pulse Card
                        _buildAIPulseCard(),

                        SizedBox(height: 14.h),

                        // Quick Actions
                        Row(
                          children: _quickActions
                              .map(
                                (action) =>
                                    Expanded(child: _buildQuickAction(action)),
                              )
                              .toList(),
                        ),

                        SizedBox(height: 16.h),

                        // Upcoming Sessions
                        _buildUpcomingSessions(),

                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TrainerBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  // Drawer Menu - FIXED: Using widget.userName in drawer header
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
                    width: 55.w,
                    height: 55.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.deepPurple],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    widget.userName, // FIXED: Using passed userName
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'ELITE TRAINER',
                        style: GoogleFonts.orbitron(
                          color: Colors.amber,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
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
                          'LVL 89',
                          style: GoogleFonts.orbitron(
                            color: Colors.cyan,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.poppins(
                        color: Colors.cyan,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              Icons.dashboard,
              'Dashboard',
              () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              Icons.fitness_center,
              'My Classes',
              () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              Icons.people,
              'Members',
              () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              Icons.analytics,
              'Analytics',
              () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              Icons.attach_money,
              'Earnings',
              () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              Icons.settings,
              'Settings',
              () => Navigator.pop(context),
            ),
            const Divider(color: Colors.white24, height: 1),
            _buildDrawerItem(
              Icons.logout,
              'Logout',
              () => Navigator.pop(context),
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.redAccent : Colors.cyan,
        size: 20.sp,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isLogout ? Colors.redAccent : Colors.white70,
          fontSize: 13.sp,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isLogout ? Colors.redAccent : Colors.white38,
        size: 12.sp,
      ),
      onTap: onTap,
    );
  }

  Widget _buildStatCard(
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
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
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: color, size: 16.sp),
              ),
              Icon(Icons.trending_up, color: color, size: 12.sp),
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
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 8.sp),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(color: color, fontSize: 8.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildAIPulseCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.cyan.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(
                                  0.5 + _pulseController.value * 0.3,
                                ),
                                blurRadius: 6.r,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'AI PULSE',
                      style: GoogleFonts.orbitron(
                        color: Colors.cyan,
                        fontSize: 10.sp,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'System Health',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 50.w,
            height: 50.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.84,
                  strokeWidth: 5,
                  backgroundColor: Colors.white24,
                  color: Colors.green,
                ),
                Column(
                  children: [
                    Text(
                      '84%',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'On Track',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 7.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () {
        if (action['label'] == 'Create Class') {
          Get.to(
            () => const TrainerCreateClassScreen(),
            transition: Transition.rightToLeft,
          );
        } else if (action['label'] == 'Schedule Live') {
          Get.to(
            () => const TrainerScheduleScreen(),
            transition: Transition.rightToLeft,
          );
        } else if (action['label'] == 'Upload') {
          Get.to(
            () => const TrainerUploadContentScreen(),
            transition: Transition.rightToLeft,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              action['color'].withOpacity(0.15),
              Colors.black.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: action['color'].withOpacity(0.5), width: 1),
        ),
        child: Column(
          children: [
            Icon(action['icon'], color: action['color'], size: 20.sp),
            SizedBox(height: 6.h),
            Text(
              action['label'],
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingSessions() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Sessions',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    color: Colors.cyan,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          ..._upcomingSessions.map((session) => _buildSessionCard(session)),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    bool isLive = session['status'] == 'live';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isLive
              ? Colors.red.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: isLive ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: session['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.fitness_center,
              color: session['color'],
              size: 20.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['title'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  session['time'],
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  '${session['members']} Members joined',
                  style: GoogleFonts.poppins(
                    color: Colors.cyan,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          if (isLive)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.red.shade700],
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Start',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(
                'Waiting',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 10.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}