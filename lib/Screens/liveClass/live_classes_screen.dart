import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vallavanapp/Screens/bottomNavbar/student_bottom_nav_bar.dart';
import 'dart:math';
import 'dart:async';

class LiveClassesScreen extends StatefulWidget {
  const LiveClassesScreen({super.key});

  @override
  State<LiveClassesScreen> createState() => _LiveClassesScreenState();
}

class _LiveClassesScreenState extends State<LiveClassesScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  int _selectedIndex = 1; // Live tab selected (index 1)
  int _sessionElapsedSeconds = 1104; // 18:24
  Timer? _sessionTimer;
  
  // Live comments
  final List<Map<String, String>> _liveComments = [
    {'user': 'Jared_X', 'comment': "Let's go! This set is killer 😍", 'time': 'now'},
    {'user': 'Sarah_Fit', 'comment': "How many rounds left? 😅", 'time': 'now'},
    {'user': 'Mike_Train', 'comment': "Push harder! 🔥", 'time': 'now'},
    {'user': 'FitQueen', 'comment': "Almost there!", 'time': 'now'},
  ];
  
  final TextEditingController _commentController = TextEditingController();
  
  // Categories
  final List<String> _categories = ['HIIT', 'Yoga', 'Fat Burn', 'Strength'];
  int _selectedCategory = 0;
  
  // Live Now Trainers
  final List<Map<String, dynamic>> _liveNowTrainers = [
    {
      'name': 'Power Yoga',
      'trainer': 'Sarah J.',
      'rating': 4.9,
      'viewers': '2.1k',
      'duration': '45 min',
      'isLive': true,
    },
    {
      'name': 'Core Strength',
      'trainer': 'Marcus T.',
      'rating': 4.8,
      'viewers': '1.5k',
      'duration': '30 min',
      'isLive': true,
    },
  ];
  
  // Upcoming Sessions
  final List<Map<String, dynamic>> _upcomingSessions = [
    {
      'name': 'Endurance Blast',
      'startsIn': '45m',
      'trainer': 'Coach Alex',
      'duration': '60 min',
      'level': 'Advanced',
    },
    {
      'name': 'Metabolic Reset',
      'startsIn': '2h 15m',
      'trainer': 'Coach Emma',
      'duration': '45 min',
      'level': 'Intermediate',
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
    
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _sessionElapsedSeconds++;
      });
    });
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _sessionTimer?.cancel();
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _liveComments.insert(0, {
          'user': 'You',
          'comment': _commentController.text,
          'time': 'now',
        });
        _commentController.clear();
      });
    }
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on index
    switch (index) {
      case 0:
        // Navigate to Coach/Home
        Navigator.pop(context);
        break;
      case 1:
        // Already on Live tab
        break;
      case 2:
        // Navigate to Hub
        break;
      case 3:
        // Navigate to Fuel
        break;
      case 4:
        // Navigate to Data
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
                  Colors.cyan.shade900.withOpacity(0.4),
                  Colors.deepPurple.shade900.withOpacity(0.6),
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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.cyan, Colors.cyanAccent],
                        ).createShader(bounds),
                        child: Text(
                          'Live Classes',
                          style: GoogleFonts.orbitron(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.red),
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
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.5 + _pulseController.value * 0.3),
                                        blurRadius: 8.r,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'LIVE',
                              style: GoogleFonts.orbitron(
                                color: Colors.red,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                        // Hero Live Session Card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildHeroLiveCard(),
                        ),

                        SizedBox(height: 20.h),

                        // Categories
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: List.generate(_categories.length, (index) {
                              bool isSelected = _selectedCategory == index;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedCategory = index),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [Colors.cyan, Colors.deepPurple],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.08),
                                                Colors.white.withOpacity(0.03),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2),
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _categories[index],
                                        style: GoogleFonts.poppins(
                                          color: isSelected ? Colors.white : Colors.white70,
                                          fontSize: 13.sp,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Live Now Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Live Now',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_liveNowTrainers.length}+ streaming',
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                  fontSize: 11.sp,
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
                            children: _liveNowTrainers.map((trainer) => 
                              _buildLiveNowCard(trainer)
                            ).toList(),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Upcoming Sessions
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Upcoming Today',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontSize: 16.sp,
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
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: _upcomingSessions.map((session) => 
                              _buildUpcomingCard(session)
                            ).toList(),
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

  Widget _buildHeroLiveCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.cyan.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.cyan.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.3),
            blurRadius: 20.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Streaming Badge
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
                                color: Colors.red.withOpacity(0.5 + _pulseController.value * 0.3),
                                blurRadius: 8.r,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'STREAMING IN HD',
                      style: GoogleFonts.orbitron(
                        color: Colors.white70,
                        fontSize: 10.sp,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: Colors.white54, size: 12.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '2.4k',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Session Timer
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.cyan, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Session Elapsed: ${_formatDuration(_sessionElapsedSeconds)}',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Workout Title
                Text(
                  'Advanced Fat Burn: High Intensity Flow',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'with Master Coach Alex Rivera',
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 16.h),

                // Live Comments Section
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    reverse: true,
                    itemCount: _liveComments.length,
                    itemBuilder: (context, index) {
                      final comment = _liveComments[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${comment['user']}: ',
                                style: GoogleFonts.poppins(
                                  color: Colors.cyan,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: comment['comment'],
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 12.h),

                // Comment Input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Say something...',
                          hintStyle: GoogleFonts.poppins(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        ),
                        onSubmitted: (_) => _sendComment(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: _sendComment,
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.cyan, Colors.deepPurple],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.send, color: Colors.white, size: 20.sp),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Join Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.red.shade700],
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 15.r,
                        spreadRadius: 2.r,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      'JOIN LIVE SESSION',
                      style: GoogleFonts.orbitron(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveNowCard(Map<String, dynamic> trainer) {
    return Container(
      width: 200.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5 + _pulseController.value * 0.3),
                            blurRadius: 6.r,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 6.w),
                Text(
                  'LIVE',
                  style: GoogleFonts.orbitron(
                    color: Colors.red,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.white54, size: 12.sp),
                    SizedBox(width: 4.w),
                    Text(
                      trainer['viewers'],
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              trainer['name'],
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              trainer['trainer'],
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 12.sp),
                SizedBox(width: 4.w),
                Text(
                  trainer['rating'].toString(),
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.access_time, color: Colors.white38, size: 12.sp),
                SizedBox(width: 4.w),
                Text(
                  trainer['duration'],
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.deepPurple],
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  'Watch Now',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(Map<String, dynamic> session) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan.withOpacity(0.2), Colors.deepPurple.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Center(
              child: Icon(Icons.fitness_center, color: Colors.cyan, size: 28.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['name'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${session['trainer']} • ${session['duration']} • ${session['level']}',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11.sp,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.cyan, size: 12.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Starts in ${session['startsIn']}',
                      style: GoogleFonts.poppins(
                        color: Colors.cyan,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              'Remind Me',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}