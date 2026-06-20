import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/bottomNavbar/student_bottom_nav_bar.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late AnimationController _ringAnimationController;
  int _selectedIndex = 3; // Nutrition tab selected
  
  // Nutrition Data
  double _remainingCalories = 842;
  double _consumedCalories = 1658;
  double _burnedCalories = 420;
  double _totalCalories = 2500;
  
  // Macros
  double _protein = 142;
  double _proteinGoal = 180;
  double _carbs = 185;
  double _carbsGoal = 250;
  double _fats = 52;
  double _fatsGoal = 70;
  
  // Hydration
  double _waterIntake = 2.4;
  double _waterGoal = 3.5;
  
  // Today's Meals
  final List<Map<String, dynamic>> _todayMeals = [
    {
      'name': 'Avocado Power',
      'time': '08:30 AM',
      'calories': 420,
      'type': 'breakfast',
      'icon': Icons.breakfast_dining,
    },
    {
      'name': 'Salmon Quino',
      'time': '01:15 PM',
      'calories': 680,
      'type': 'lunch',
      'icon': Icons.lunch_dining,
    },
  ];
  
  // Weekly Performance Data
  List<WeeklyNutrientData> _weeklyData = [];
  
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
    _ringAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    
    _generateWeeklyData();
  }

  void _generateWeeklyData() {
    _weeklyData = [
      WeeklyNutrientData('Mon', 1850),
      WeeklyNutrientData('Tue', 2100),
      WeeklyNutrientData('Wed', 1950),
      WeeklyNutrientData('Thu', 2280),
      WeeklyNutrientData('Fri', 2140),
      WeeklyNutrientData('Sat', 1890),
      WeeklyNutrientData('Sun', 1760),
    ];
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _ringAnimationController.dispose();
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

  double get _totalConsumedEnergy => _consumedCalories - _burnedCalories;

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
                  Colors.green.shade900.withOpacity(0.3),
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
                            Colors.green.withOpacity(0.08),
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
                          colors: [Colors.green, Colors.cyan],
                        ).createShader(bounds),
                        child: Text(
                          'Nutrition',
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
                        child: Icon(Icons.refresh, color: Colors.green, size: 20.sp),
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
                        // Calorie Ring and Stats Row
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(child: _buildCalorieRing()),
                              SizedBox(width: 16.w),
                              Expanded(child: _buildCalorieStats()),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Nutrient Matrix
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildNutrientMatrix(),
                        ),

                        SizedBox(height: 20.h),

                        // AI Scan Card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildAIScanCard(),
                        ),

                        SizedBox(height: 20.h),

                        // Today's Meals
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildTodayMeals(),
                        ),

                        SizedBox(height: 20.h),

                        // Hydration Tracker
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildHydrationTracker(),
                        ),

                        SizedBox(height: 20.h),

                        // AI Insights
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildAIInsights(),
                        ),

                        SizedBox(height: 20.h),

                        // Performance Trends
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildPerformanceTrends(),
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
                        color: Colors.green.withOpacity(0.5 + _pulseController.value * 0.3),
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
                          colors: [Colors.green, Colors.cyan],
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

  Widget _buildCalorieRing() {
    double progress = _totalConsumedEnergy / _totalCalories;
    
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
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120.w,
                height: 120.w,
                child: TweenAnimationBuilder(
                  duration: const Duration(seconds: 2),
                  tween: Tween<double>(begin: 0, end: progress),
                  builder: (context, double value, child) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 8,
                      backgroundColor: Colors.white24,
                      color: Colors.green,
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Text(
                    'REMAINING',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    '${_remainingCalories.toInt()}',
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'kcal',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieStats() {
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
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildStatRow('Consumed', '${_consumedCalories.toInt()}', Colors.orange),
          SizedBox(height: 12.h),
          _buildStatRow('Burned', '${_burnedCalories.toInt()}', Colors.blue),
          SizedBox(height: 12.h),
          _buildStatRow('Net', '${_totalConsumedEnergy.toInt()}', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 12.sp,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientMatrix() {
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
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrient Matrix',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          _buildNutrientRow('Protein', _protein, _proteinGoal, Colors.red),
          SizedBox(height: 12.h),
          _buildNutrientRow('Carbohydrates', _carbs, _carbsGoal, Colors.orange),
          SizedBox(height: 12.h),
          _buildNutrientRow('Healthy Fats', _fats, _fatsGoal, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String name, double current, double goal, Color color) {
    double progress = current / goal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
            Text(
              '${current.toInt()}g / ${goal.toInt()}g',
              style: GoogleFonts.orbitron(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.white24,
            color: color,
            minHeight: 6.h,
          ),
        ),
      ],
    );
  }

  Widget _buildAIScanCard() {
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
        border: Border.all(
          color: Colors.cyan.withOpacity(0.5),
          width: 1,
        ),
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
            child: Icon(Icons.camera_alt, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Scan',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyan,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Instant nutrient recognition',
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Text(
              'SCAN',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMeals() {
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
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Meals',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View History',
                  style: GoogleFonts.poppins(
                    color: Colors.cyan,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          ..._todayMeals.map((meal) => _buildMealItem(meal)),
        ],
      ),
    );
  }

  Widget _buildMealItem(Map<String, dynamic> meal) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(meal['icon'], color: Colors.cyan, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  meal['time'],
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
                '${meal['calories']} kcal',
                style: GoogleFonts.orbitron(
                  color: Colors.orange,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '68%',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHydrationTracker() {
    double progress = _waterIntake / _waterGoal;
    int remaining = ((_waterGoal - _waterIntake) * 1000).toInt();
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.15),
            Colors.cyan.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.blue.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Hydration Lab',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_waterIntake.toStringAsFixed(1)}L / ${_waterGoal.toStringAsFixed(1)}L Target',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(
                  '+250ml 600ml',
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              color: Colors.blue,
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${remaining}ml remaining to reach goal',
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 10.sp,
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
            Colors.purple.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.purple.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.purple, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'AI Insights',
                style: GoogleFonts.orbitron(
                  color: Colors.purple,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInsightCard(
            'Protein Gap Detected',
            'You\'re 35g short of your muscle synthesis goal. AI recommends a whey isolate shake or 150g greek yogurt now.',
            Icons.fitness_center,
            Colors.orange,
          ),
          SizedBox(height: 12.h),
          _buildInsightCard(
            'Metabolic Optimization',
            'High activity forecast for tomorrow. Increase carb intake by 15% tonight for peak glycogen storage.',
            Icons.trending_up,
            Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 16.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.orbitron(
                    color: color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTrends() {
    double avgCalories = _weeklyData.map((e) => e.calories).reduce((a, b) => a + b) / _weeklyData.length;
    double maxCalories = _weeklyData.map((e) => e.calories).reduce((a, b) => a > b ? a : b).toDouble();
    
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
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance Trends',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildTrendStat('AVG DAILY', '${avgCalories.toInt()} kcal'),
                  SizedBox(width: 12.w),
                  _buildTrendStat('CONSISTENCY', '94%'),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 80.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weeklyData.map((data) {
                double height = (data.calories / maxCalories) * 60;
                return Column(
                  children: [
                    Container(
                      width: 25.w,
                      height: height.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.cyan, Colors.green],
                        ),
                        borderRadius: BorderRadius.circular(6.r),
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
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 9.sp,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.cyan,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Data Model
class WeeklyNutrientData {
  final String day;
  final int calories;
  WeeklyNutrientData(this.day, this.calories);
}