import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/bottomNavbar/trainer_bottom_nav_bar.dart';

class TrainerLiveClassesScreen extends StatefulWidget {
  const TrainerLiveClassesScreen({super.key});

  @override
  State<TrainerLiveClassesScreen> createState() =>
      _TrainerLiveClassesScreenState();
}

class _TrainerLiveClassesScreenState extends State<TrainerLiveClassesScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  int _selectedTab = 1; // 0: Live, 1: Upcoming, 2: Completed
  int _selectedIndex = 1; // Live tab selected in bottom nav

  // Live Classes
  final List<Map<String, dynamic>> _liveClasses = [
    {
      'title': 'HIIT Power Hour',
      'trainer': 'Coach Alex',
      'time': '10:00 AM',
      'duration': '45 min',
      'members': 42,
      'viewers': 128,
      'attendance': 89,
      'thumbnail': '🔥',
      'color': Colors.red,
      'status': 'live',
    },
    {
      'title': 'Core Blast AI',
      'trainer': 'Coach Sarah',
      'time': '02:30 PM',
      'duration': '30 min',
      'members': 28,
      'viewers': 94,
      'attendance': 76,
      'thumbnail': '💪',
      'color': Colors.orange,
      'status': 'live',
    },
  ];

  // Upcoming Classes
  final List<Map<String, dynamic>> _upcomingClasses = [
    {
      'title': 'Sunset Yoga Flow',
      'trainer': 'Coach Emma',
      'date': 'Today',
      'time': '05:00 PM',
      'duration': '60 min',
      'booked': 65,
      'capacity': 80,
      'thumbnail': '🧘',
      'color': Colors.green,
      'status': 'upcoming',
    },
    {
      'title': 'Strength Foundation',
      'trainer': 'Coach Mike',
      'date': 'Tomorrow',
      'time': '08:00 AM',
      'duration': '50 min',
      'booked': 48,
      'capacity': 60,
      'thumbnail': '🏋️',
      'color': Colors.blue,
      'status': 'upcoming',
    },
    {
      'title': 'Metabolic Burn',
      'trainer': 'Coach Alex',
      'date': 'Tomorrow',
      'time': '06:30 PM',
      'duration': '45 min',
      'booked': 52,
      'capacity': 70,
      'thumbnail': '⚡',
      'color': Colors.purple,
      'status': 'upcoming',
    },
  ];

  // Completed Classes
  final List<Map<String, dynamic>> _completedClasses = [
    {
      'title': 'Morning HIIT',
      'trainer': 'Coach Alex',
      'date': 'Yesterday',
      'time': '07:00 AM',
      'duration': '45 min',
      'attendance': 92,
      'rating': 4.8,
      'thumbnail': '🏃',
      'color': Colors.grey,
      'status': 'completed',
    },
    {
      'title': 'Power Yoga',
      'trainer': 'Coach Emma',
      'date': 'Yesterday',
      'time': '09:30 AM',
      'duration': '60 min',
      'attendance': 88,
      'rating': 4.9,
      'thumbnail': '🧘',
      'color': Colors.grey,
      'status': 'completed',
    },
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
    switch (index) {
      case 0:
        // Navigate to Dashboard
        Navigator.pop(context);
        break;
      case 1:
        // Already on Live Classes
        break;
      case 2:
        // Navigate to Members
        break;
      case 3:
        // Navigate to Earnings
        break;
      case 4:
        // Navigate to Profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ),
            ),
          ),

          // Grid Lines
          ...List.generate(15, (index) {
            return Positioned(
              top: (index * 60).toDouble().h,
              left: 0,
              right: 0,
              child: Container(
                height: 1.h,
                color: Colors.cyan.withOpacity(0.05),
              ),
            );
          }),
          ...List.generate(8, (index) {
            return Positioned(
              left: (index * 50).toDouble().w,
              top: 0,
              bottom: 0,
              child: Container(
                width: 1.w,
                color: Colors.cyan.withOpacity(0.05),
              ),
            );
          }),

          // Animated Orbs
          ...List.generate(3, (index) {
            return Positioned(
              top: 150.h + (index * 200),
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
                // Header
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.cyan.withOpacity(0.3)),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.cyan,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.cyan, Colors.purple],
                        ).createShader(bounds),
                        child: Text(
                          'Live Classes',
                          style: GoogleFonts.orbitron(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: Colors.cyan,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      _buildTab('LIVE', 0, _liveClasses.length),
                      _buildTab('UPCOMING', 1, _upcomingClasses.length),
                      _buildTab('COMPLETED', 2, _completedClasses.length),
                    ],
                  ),
                ),

                // Stats Overview Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      _buildStatChip(
                        'Total Attendance',
                        '87%',
                        Icons.people,
                        Colors.green,
                      ),
                      SizedBox(width: 12.w),
                      _buildStatChip(
                        'Active Viewers',
                        '222',
                        Icons.visibility,
                        Colors.cyan,
                      ),
                      SizedBox(width: 12.w),
                      _buildStatChip(
                        'Completion Rate',
                        '94%',
                        Icons.auto_awesome,
                        Colors.purple,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Class List
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        if (_selectedTab == 0) ...[
                          ..._liveClasses.map(
                            (classItem) => _buildLiveClassCard(classItem),
                          ),
                          SizedBox(height: 80.h),
                        ],
                        if (_selectedTab == 1) ...[
                          ..._upcomingClasses.map(
                            (classItem) => _buildUpcomingClassCard(classItem),
                          ),
                          SizedBox(height: 80.h),
                        ],
                        if (_selectedTab == 2) ...[
                          ..._completedClasses.map(
                            (classItem) => _buildCompletedClassCard(classItem),
                          ),
                          SizedBox(height: 80.h),
                        ],
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

  Widget _buildTab(String title, int index, int count) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [Colors.cyan, Colors.deepPurple])
                : null,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.orbitron(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (count > 0) ...[
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 14.sp),
            SizedBox(width: 4.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 8.sp,
                    ),
                  ),

                  Text(
                    value,
                    style: GoogleFonts.orbitron(
                      color: color,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
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

  Widget _buildLiveClassCard(Map<String, dynamic> classItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 10.r),
        ],
      ),
      child: Column(
        children: [
          // Live Banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.red.shade700],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(
                              0.5 + _pulseController.value * 0.3,
                            ),
                            blurRadius: 6.r,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 8.w),
                Text(
                  'LIVE NOW',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.white70, size: 12.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '${classItem['viewers']}',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            classItem['color'],
                            classItem['color'].withOpacity(0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          classItem['thumbnail'],
                          style: TextStyle(fontSize: 24.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classItem['title'],
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${classItem['trainer']} • ${classItem['duration']}',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.red.shade700],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'JOIN',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _buildMetric(
                      'Members',
                      '${classItem['members']}',
                      Icons.people,
                      Colors.cyan,
                    ),
                    SizedBox(width: 16.w),
                    _buildMetric(
                      'Attendance',
                      '${classItem['attendance']}%',
                      Icons.trending_up,
                      Colors.green,
                    ),
                    SizedBox(width: 16.w),
                    _buildMetric(
                      'Time',
                      classItem['time'],
                      Icons.access_time,
                      Colors.orange,
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

  Widget _buildUpcomingClassCard(Map<String, dynamic> classItem) {
    double progress = classItem['booked'] / classItem['capacity'];
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      classItem['color'],
                      classItem['color'].withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    classItem['thumbnail'],
                    style: TextStyle(fontSize: 24.sp),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classItem['title'],
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${classItem['trainer']} • ${classItem['duration']}',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.cyan),
                ),
                child: Text(
                  'EDIT',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyan,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildMetric(
                'Date',
                classItem['date'],
                Icons.calendar_today,
                Colors.purple,
              ),
              SizedBox(width: 16.w),
              _buildMetric(
                'Time',
                classItem['time'],
                Icons.access_time,
                Colors.orange,
              ),
              SizedBox(width: 16.w),
              _buildMetric(
                'Booked',
                '${classItem['booked']}/${classItem['capacity']}',
                Icons.people,
                Colors.cyan,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              color: Colors.green,
              minHeight: 4.h,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${((progress) * 100).toInt()}% filled',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 9.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.deepPurple],
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Text(
                  'START STREAM',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedClassCard(Map<String, dynamic> classItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      classItem['color'],
                      classItem['color'].withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    classItem['thumbnail'],
                    style: TextStyle(fontSize: 24.sp),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classItem['title'],
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${classItem['trainer']} • ${classItem['duration']}',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 12.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '${classItem['rating']}',
                      style: GoogleFonts.orbitron(
                        color: Colors.amber,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildMetric(
                'Date',
                classItem['date'],
                Icons.calendar_today,
                Colors.purple,
              ),
              SizedBox(width: 16.w),
              _buildMetric(
                'Time',
                classItem['time'],
                Icons.access_time,
                Colors.orange,
              ),
              SizedBox(width: 16.w),
              _buildMetric(
                'Attendance',
                '${classItem['attendance']}%',
                Icons.people,
                Colors.green,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  'View Recording',
                  Icons.play_circle,
                  Colors.cyan,
                ),
                _buildActionButton('Analytics', Icons.analytics, Colors.purple),
                _buildActionButton('Share', Icons.share, Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 8.sp,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.orbitron(
                  color: Colors.white70,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
