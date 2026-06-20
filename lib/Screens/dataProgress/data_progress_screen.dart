import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/bottomNavbar/student_bottom_nav_bar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  int _selectedIndex = 4; // Progress tab selected

  // Progress Data
  int _currentStreak = 64;
  double _currentWeight = 78.4;
  double _targetWeight = 75.0;
  double _bmi = 22.4;
  int _consistency = 96;

  // Weight History Data
  List<WeeklyCalorieData> _weeklyCalories = [];

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
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _generateWeightHistory();
    _generateWeeklyCalories();
  }

  void _generateWeightHistory() {}

  void _generateWeeklyCalories() {
    _weeklyCalories = [
      WeeklyCalorieData('Mon', 2100, 1950),
      WeeklyCalorieData('Tue', 2350, 2100),
      WeeklyCalorieData('Wed', 1980, 2050),
      WeeklyCalorieData('Thu', 2450, 2200),
      WeeklyCalorieData('Fri', 2280, 2150),
    ];
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
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

  double get _weightRemaining => _currentWeight - _targetWeight;

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
                  Colors.purple.shade900.withOpacity(0.3),
                  Colors.cyan.shade900.withOpacity(0.4),
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
                            Colors.purple.withOpacity(0.08),
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
                          colors: [Colors.purple, Colors.cyan],
                        ).createShader(bounds),
                        child: Text(
                          'Progress',
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
                          Icons.share,
                          color: Colors.purple,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Streak Card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildStreakCard(),
                        ),

                        SizedBox(height: 10.h),

                        // Evolution Section (Before/After)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildEvolutionCard(),
                        ),

                        SizedBox(height: 10.h),

                        // Weight & Stats Row
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(child: _buildWeightCard()),
                              SizedBox(width: 12.w),
                              Expanded(child: _buildStatsCard()),
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // AI Smart Analysis
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildAIAnalysis(),
                        ),

                        SizedBox(height: 10.h),

                        // Weekly Active Calories Chart
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildWeeklyCaloriesChart(),
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
                        color: Colors.purple.withOpacity(
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
                          colors: [Colors.purple, Colors.cyan],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.psychology_rounded,
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

  Widget _buildStreakCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.orange.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 15.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Current Streak',
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 12.sp,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_currentStreak',
                style: GoogleFonts.orbitron(
                  color: Colors.orange,
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '-Day',
                style: GoogleFonts.orbitron(
                  color: Colors.white70,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge('WARRIOR', Colors.red),
              SizedBox(width: 12.w),
              _buildBadge('CONSISTENCY', Colors.blue),
              SizedBox(width: 12.w),
              _buildBadge('KING', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String title, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        title,
        style: GoogleFonts.orbitron(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEvolutionCard() {
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
            'EVOLUTION',
            style: GoogleFonts.orbitron(
              color: Colors.cyan,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildBeforeAfterCard(
                  'April 12 Before',
                  'assets/before.png', // Replace with actual asset
                  Colors.red,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildBeforeAfterCard(
                  'April 12 After',
                  'assets/after.png', // Replace with actual asset
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeforeAfterCard(
    String label,
    String imagePath,
    Color borderColor,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [borderColor.withOpacity(0.3), Colors.black],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(Icons.person, color: borderColor, size: 48.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightCard() {
    double progress = (_currentWeight - _targetWeight) / (82.5 - _targetWeight);

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
            'Weight Trend',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.sp),
          ),
          Text(
            '${_currentWeight.toStringAsFixed(1)} kg',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Target: ${_targetWeight.toStringAsFixed(1)} kg',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white24,
              color: Colors.green,
              minHeight: 6.h,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '-${_weightRemaining.toStringAsFixed(1)} kg to go',
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
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
          _buildStatItem(
            'BMI',
            '${_bmi.toStringAsFixed(1)}',
            'Healthy',
            Colors.cyan,
          ),
          SizedBox(height: 16.h),
          _buildStatItem(
            'Consistency',
            '$_consistency%',
            'Excellent',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    String subtitle,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: color,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.poppins(color: color, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildAIAnalysis() {
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
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.2),
            blurRadius: 15.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMART ANALYSIS',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyan,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Your muscle-to-fat ratio has improved by 4% this month. You are on track to hit your target by August.',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCaloriesChart() {
    double maxCalories = _weeklyCalories
        .map(
          (e) => e.currentCalories > e.previousCalories
              ? e.currentCalories
              : e.previousCalories,
        )
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // TITLE
          Text(
            'Weekly Active Calories',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            'THIS VS LAST WEEK',
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 8.sp,
              letterSpacing: 1.2,
            ),
          ),

          SizedBox(height: 18.h),

          // CHART
          SizedBox(
            height: 110.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _weeklyCalories.map((data) {
                double currentHeight =
                    (data.currentCalories / maxCalories) * 65;

                double previousHeight =
                    (data.previousCalories / maxCalories) * 50;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // LAST WEEK
                        Container(
                          width: 10.w,
                          height: previousHeight.h,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),

                        SizedBox(width: 4.w),

                        // THIS WEEK
                        Container(
                          width: 10.w,
                          height: currentHeight.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.cyan, Colors.purple],
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      data.day,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 14.h),

          // LEGEND
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLegend('This Week', Colors.cyan),
                SizedBox(width: 18.w),
                _buildLegend('Last Week', Colors.white24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp),
        ),
      ],
    );
  }
}

// Data Models
class WeightData {
  final String week;
  final double weight;
  WeightData(this.week, this.weight);
}

class WeeklyCalorieData {
  final String day;
  final int currentCalories;
  final int previousCalories;
  WeeklyCalorieData(this.day, this.currentCalories, this.previousCalories);
}
