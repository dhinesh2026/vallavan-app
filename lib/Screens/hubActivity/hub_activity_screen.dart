import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/bottomNavbar/student_bottom_nav_bar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  int _selectedIndex = 2; // Activity tab selected

  // Health Data
  double _caloriesBurned = 1842;
  double _steps = 12482;
  int _activeTime = 64;
  int _heartRate = 72;

  // Activity Ring Values
  double _moveProgress = 0.85;
  double _exerciseProgress = 0.70;
  double _standProgress = 0.80;

  // Heart Rate Data Points
  List<HeartRateData> _heartRateData = [];

  // Weekly Activity Data
  List<WeeklyActivity> _weeklyData = [];

  // Recent Workouts
  final List<Map<String, dynamic>> _recentWorkouts = [
    {
      'name': 'Strength Training',
      'calories': 450,
      'time': 'Today, 08:30 AM',
      'duration': '45 mins',
      'icon': Icons.fitness_center,
      'color': Colors.orange,
    },
    {
      'name': 'Morning Yoga',
      'calories': 120,
      'time': 'Yesterday, 07:00 AM',
      'duration': '30 mins',
      'icon': Icons.self_improvement,
      'color': Colors.green,
    },
    {
      'name': 'HIIT Session',
      'calories': 580,
      'time': '2 days ago',
      'duration': '40 mins',
      'icon': Icons.flash_on,
      'color': Colors.red,
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

    _generateHeartRateData();
    _generateWeeklyData();
  }

  void _generateHeartRateData() {
    _heartRateData = [
      HeartRateData('08:00', 68),
      HeartRateData('09:00', 72),
      HeartRateData('10:00', 78),
      HeartRateData('11:00', 85),
      HeartRateData('12:00', 82),
      HeartRateData('13:00', 75),
      HeartRateData('14:00', 70),
      HeartRateData('15:00', 68),
      HeartRateData('16:00', 72),
      HeartRateData('17:00', 76),
      HeartRateData('18:00', 80),
      HeartRateData('19:00', 72),
      HeartRateData('20:00', 72),
    ];
  }

  void _generateWeeklyData() {
    _weeklyData = [
      WeeklyActivity('Mon', 450),
      WeeklyActivity('Tue', 520),
      WeeklyActivity('Wed', 380),
      WeeklyActivity('Thu', 620),
      WeeklyActivity('Fri', 580),
      WeeklyActivity('Sat', 490),
      WeeklyActivity('Sun', 430),
    ];
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
        Navigator.pop(context);
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
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
                stops: const [0.2, 0.5, 1.0],
              ),
            ),
          ),

          // Animated Grid Lines
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
              top: 200.h + (index * 250),
              right: -50.w + (index * 80),
              child: TweenAnimationBuilder(
                duration: Duration(seconds: 8 + index),
                tween: Tween<double>(begin: 0, end: 2 * pi),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(sin(value) * 30, cos(value * 0.7) * 30),
                    child: Container(
                      width: 150.w,
                      height: 150.w,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                  child: Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.cyan, Colors.cyanAccent],
                        ).createShader(bounds),
                        child: Text(
                          'Activity',
                          style: GoogleFonts.orbitron(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
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
                          Icons.sync,
                          color: Colors.cyan,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Activity Rings Row
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(child: _buildCaloriesCard()),
                              SizedBox(width: 12.w),
                              Expanded(child: _buildActivityRings()),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Heart Rate Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildHeartRateCard(),
                        ),

                        SizedBox(height: 20.h),

                        // Steps & Active Time Row
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(child: _buildStepsCard()),
                              SizedBox(width: 12.w),
                              Expanded(child: _buildActiveTimeCard()),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Weekly Analytics
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildWeeklyAnalytics(),
                        ),

                        SizedBox(height: 20.h),

                        // AI Insights
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildAIInsights(),
                        ),

                        SizedBox(height: 20.h),

                        // Recent Workouts
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildRecentWorkouts(),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating AI Assistant Button
          Positioned(
            bottom: 80.h,
            right: 20.w,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(
                          0.5 + _pulseController.value * 0.3,
                        ),
                        blurRadius: 20.r,
                        spreadRadius: 5.r,
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.cyan, Colors.deepPurple],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_rounded,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                );
              },
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

  Widget _buildCaloriesCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        children: [
          Text(
            'Calories Burned',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            '${_caloriesBurned.toInt()}',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'kcal',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.sp),
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: _caloriesBurned / 3000,
              backgroundColor: Colors.white24,
              color: Colors.orange,
              minHeight: 4.h,
            ),
          ),
          Text(
            'Goal: 3,000 kcal',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRings() {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _buildRingStat('Move', _moveProgress, Colors.red)),

          Expanded(
            child: _buildRingStat('Exercise', _exerciseProgress, Colors.green),
          ),

          Expanded(child: _buildRingStat('Stand', _standProgress, Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildRingStat(String title, double progress, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 42.w,
          height: 42.w,
          child: TweenAnimationBuilder(
            duration: const Duration(seconds: 2),
            tween: Tween<double>(begin: 0, end: progress),
            builder: (context, double value, child) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 5,
                backgroundColor: Colors.white24,
                color: color,
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10.sp),
        ),
        Text(
          '${(progress * 100).toInt()}%',
          style: GoogleFonts.orbitron(
            color: color,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHeartRateCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(
                            0.5 + _pulseController.value * 0.3,
                          ),
                          blurRadius: 8.r,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(width: 8.w),
              Text(
                'LIVE ${_heartRate} BPM',
                style: GoogleFonts.orbitron(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Heart Rate',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 100.h,
            child: CustomPaint(
              painter: HeartRatePainter(_heartRateData),
              size: Size(double.infinity, 100.h),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['08:00', '12:00', '16:00', '20:00', 'NOW']
                  .map(
                    (time) => Text(
                      time,
                      style: GoogleFonts.poppins(
                        color: time == 'NOW' ? Colors.cyan : Colors.white38,
                        fontSize: 10.sp,
                        fontWeight: time == 'NOW'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Steps',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '+12%',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${_steps.toInt()}',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: _steps / 15000,
              backgroundColor: Colors.white24,
              color: Colors.green,
              minHeight: 4.h,
            ),
          ),
          Text(
            'Goal 15,000',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTimeCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        children: [
          Text(
            'Active Time',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.sp),
          ),
          Text(
            '${_activeTime}',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'minutes',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: _activeTime / 90,
              backgroundColor: Colors.white24,
              color: Colors.purple,
              minHeight: 4.h,
            ),
          ),
          Text(
            'Goal 90m',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyAnalytics() {
    double maxCalories = _weeklyData
        .map((e) => e.calories)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      padding: EdgeInsets.all(16.w),
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
        children: [
          Text(
            'Weekly Analytics',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 140.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weeklyData.map((data) {
                double height = (data.calories / maxCalories) * 100;
                return Column(
                  children: [
                    Container(
                      width: 30.w,
                      height: height.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.cyan, Colors.cyan.shade300],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      data.day,
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      '${data.calories}',
                      style: GoogleFonts.orbitron(
                        color: Colors.white38,
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsights() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.cyan.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.cyan, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'AI Insights',
                style: GoogleFonts.orbitron(
                  color: Colors.cyan,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Peak Performance',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Your recovery score is high! You\'re 15% more efficient today than your weekly average. Perfect day for HIIT.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            children: [
              _buildInsightBadge('Me', Icons.mood),
              _buildInsightBadge('Ear', Icons.earbuds),
              _buildInsightBadge('inc', Icons.trending_up),
              _buildInsightBadge('var', Icons.show_chart),
              _buildInsightBadge('rhy', Icons.favorite),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBadge(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.cyan, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentWorkouts() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Workouts',
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
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          ..._recentWorkouts.map((workout) => _buildWorkoutItem(workout)),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(Map<String, dynamic> workout) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: (workout['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(workout['icon'], color: workout['color'], size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout['name'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  workout['time'],
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${workout['calories']} kcal',
                style: GoogleFonts.orbitron(
                  color: Colors.cyan,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                workout['duration'],
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Heart Rate Painter
class HeartRatePainter extends CustomPainter {
  final List<HeartRateData> data;

  HeartRatePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    double width = size.width;
    double height = size.height;
    double stepX = width / (data.length - 1);

    List<int> values = data.map((e) => e.value).toList();
    int maxValue = values.reduce((a, b) => a > b ? a : b);
    int minValue = values.reduce((a, b) => a < b ? a : b);
    double range = (maxValue - minValue).toDouble();

    Paint linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Paint fillPaint = Paint()
      ..color = Colors.red.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    Path linePath = Path();
    Path fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      double y = height - ((data[i].value - minValue) / range) * height;

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(width, height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    // Draw points
    Paint pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      double y = height - ((data[i].value - minValue) / range) * height;
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Data Models
class HeartRateData {
  final String time;
  final int value;
  HeartRateData(this.time, this.value);
}

class WeeklyActivity {
  final String day;
  final int calories;
  WeeklyActivity(this.day, this.calories);
}
