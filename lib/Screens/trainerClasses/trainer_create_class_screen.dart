import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerCreateClassScreen extends StatefulWidget {
  const TrainerCreateClassScreen({super.key});

  @override
  State<TrainerCreateClassScreen> createState() => _TrainerCreateClassScreenState();
}

class _TrainerCreateClassScreenState extends State<TrainerCreateClassScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  
  // Form Data
  final _sessionTitleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _duration = 60;
  int _capacity = 25;
  
  // Selection Values
  String? _selectedTrainer;
  String? _sessionType; // "One-to-One" or "Group"
  List<String> _selectedStudents = [];
  String? _selectedCategory;
  String? _selectedLevel;
  String? _selectedMode;
  bool _aiAutomation = false;
  bool _aiAttendanceTracking = true;
  bool _aiRecommendations = false;
  
  // Sample Data
  final List<String> _trainers = [
    'Coach Alex Rivera',
    'Coach Sarah Johnson',
    'Coach Marcus Chen',
    'Coach Emma Davis',
  ];
  
  final List<Map<String, dynamic>> _students = [
    {'name': 'Marcus Chen', 'avatar': 'MC', 'email': 'marcus@example.com', 'level': 'Advanced'},
    {'name': 'Elena Rodriguez', 'avatar': 'ER', 'email': 'elena@example.com', 'level': 'Intermediate'},
    {'name': 'Sarah Johnson', 'avatar': 'SJ', 'email': 'sarah@example.com', 'level': 'Elite'},
    {'name': 'Mike Chen', 'avatar': 'MC', 'email': 'mike@example.com', 'level': 'Beginner'},
    {'name': 'Emma Davis', 'avatar': 'ED', 'email': 'emma@example.com', 'level': 'Advanced'},
  ];
  
  final List<String> _categories = [
    'Strength Training', 'HIIT', 'Yoga', 'Pilates', 'Cardio', 'MMA', 'Dance'
  ];
  
  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced', 'Elite'];
  final List<String> _modes = ['Online', 'Offline', 'Hybrid'];
  
  // Today's Sessions
  final List<Map<String, dynamic>> _todaySessions = [
    {'title': 'Elite Strength & Conditioning', 'time': '08:00 AM', 'status': 'live', 'current': 3, 'capacity': 12, 'duration': '60 min'},
    {'title': 'Advanced Yoga Flow', 'time': '04:00 PM', 'status': 'upcoming', 'current': 18, 'capacity': 25, 'duration': '45 min'},
  ];
  
  // Live Class Analytics
  final List<Map<String, dynamic>> _liveAnalytics = [
    {'title': 'Explosive Cardio Elite', 'engagement': 98, 'color': Colors.cyan},
    {'title': 'Midnight Flow', 'engagement': 85, 'color': Colors.purple},
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
    _sessionTitleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.cyan),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.cyan),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _publishSession() {
    String studentNames = _selectedStudents.isNotEmpty 
        ? _selectedStudents.join(', ') 
        : 'Not assigned';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: Colors.cyan, width: 1),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 30.sp),
            SizedBox(width: 10.w),
            Text('Session Published!', style: GoogleFonts.orbitron(color: Colors.white)),
          ],
        ),
        content: Text(
          'Your session "${_sessionTitleController.text}" has been scheduled successfully.\n\n'
          '📅 Date: ${_selectedDate.toString().split(' ')[0]}\n'
          '⏰ Time: ${_selectedTime.format(context)}\n'
          '⏱️ Duration: ${_duration} min\n'
          '👥 Type: ${_sessionType ?? 'Not selected'}\n'
          '👥 Capacity: $_capacity\n'
          '👤 Assigned Students: $studentNames',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.orbitron(color: Colors.cyan)),
          ),
        ],
      ),
    );
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

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.6)],
                    ),
                    border: Border(bottom: BorderSide(color: Colors.cyan.withOpacity(0.3))),
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
                          child: Icon(Icons.arrow_back, color: Colors.cyan, size: 20.sp),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.cyan, Colors.purple],
                        ).createShader(bounds),
                        child: Text(
                          'Create New Class',
                          style: GoogleFonts.orbitron(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),

                        // Date Header
                        _buildDateHeader(),

                        SizedBox(height: 16.h),

                        // Today's Sessions
                        _buildTodaySessions(),

                        SizedBox(height: 16.h),

                        // AI Insights
                        _buildAIInsights(),

                        SizedBox(height: 16.h),

                        // Create Session Form
                        _buildCreateSessionForm(),

                        SizedBox(height: 16.h),

                        // Live Class Analytics
                        _buildLiveAnalytics(),

                        SizedBox(height: 16.h),

                        // Recent Bookings
                        _buildRecentBookings(),

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
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.cyan, Colors.purple]),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(Icons.calendar_today, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFormattedDate(),
                  style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  '"Excellence is a habit."',
                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.sp, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[_selectedDate.weekday - 1]}, ${months[_selectedDate.month - 1]} ${_selectedDate.day}';
  }

  Widget _buildTodaySessions() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Today\'s Sessions', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: Text('View All', style: GoogleFonts.poppins(color: Colors.cyan, fontSize: 11.sp)),
              ),
            ],
          ),
          ..._todaySessions.map((session) => _buildSessionCard(session)),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    bool isLive = session['status'] == 'live';
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isLive ? Colors.red.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          width: isLive ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isLive)
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.red, Colors.red.shade700]),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5 + _pulseController.value * 0.3),
                                  blurRadius: 4.r,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text('LIVE NOW', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                )
              else
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text('UPCOMING', style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 9.sp, fontWeight: FontWeight.bold)),
                ),
              const Spacer(),
              Text(session['time'], style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(session['title'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isLive)
                Text('${session['current']} | ${session['capacity']}', style: GoogleFonts.poppins(color: Colors.cyan, fontSize: 12.sp))
              else
                Text('${session['current']}/${session['capacity']} Booked • ${session['duration']}', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isLive ? [Colors.red, Colors.red.shade700] : [Colors.cyan, Colors.deepPurple]),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(isLive ? 'START' : 'MANAGE', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold)),
              ),
            ],
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
          colors: [Colors.cyan.withOpacity(0.15), Colors.deepPurple.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.cyan.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(Icons.auto_awesome, color: Colors.cyan, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Peak Attendance Projection', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
                Row(
                  children: [
                    Text('+32%', style: GoogleFonts.orbitron(color: Colors.green, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    SizedBox(width: 12.w),
                    _buildTimeBadge('MORNING', Colors.orange),
                    _buildTimeBadge('EVENING PEAK', Colors.cyan),
                    _buildTimeBadge('LATE', Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(label, style: GoogleFonts.poppins(color: color, fontSize: 8.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCreateSessionForm() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Create', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),

          // Session Title
          Text('SESSION TITLE', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
          SizedBox(height: 6.h),
          TextField(
            controller: _sessionTitleController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: _buildInputDecoration('e.g. Morning Burn HIIT', Icons.title),
          ),
          SizedBox(height: 16.h),

          // Trainer Selection
          Text('SELECT TRAINER', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
          SizedBox(height: 6.h),
          _buildDropdown('Select Trainer', _trainers, _selectedTrainer, (value) {
            setState(() => _selectedTrainer = value);
          }),
          SizedBox(height: 16.h),

          // Session Type (One-to-One / Group)
          Text('SESSION TYPE', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
          SizedBox(height: 6.h),
          Row(
            children: [
              _buildTypeChip('One-to-One', Icons.person),
              SizedBox(width: 12.w),
              _buildTypeChip('Group', Icons.people),
            ],
          ),
          SizedBox(height: 16.h),

          // Student Selection (Only for One-to-One)
          if (_sessionType == 'One-to-One') ...[
            Text('ASSIGN STUDENT', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
            SizedBox(height: 6.h),
            _buildStudentSelector(),
            SizedBox(height: 16.h),
          ],

          // Capacity (Only for Group)
          if (_sessionType == 'Group') ...[
            _buildCapacitySelector(),
            SizedBox(height: 16.h),
          ],

          // Category & Level Row
          Row(
            children: [
              Expanded(child: _buildCategorySelector()),
              SizedBox(width: 12.w),
              Expanded(child: _buildLevelSelector()),
            ],
          ),
          SizedBox(height: 16.h),

          // Date & Time Row
          Row(
            children: [
              Expanded(child: _buildDatePicker()),
              SizedBox(width: 12.w),
              Expanded(child: _buildTimePicker()),
            ],
          ),
          SizedBox(height: 16.h),

          // Duration
          _buildDurationSelector(),
          SizedBox(height: 16.h),

          // Mode Selection
          Text('MODE', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
          SizedBox(height: 6.h),
          Wrap(
            children: _modes.map((mode) => _buildModeChip(mode)).toList(),
          ),
          SizedBox(height: 16.h),

          // AI Automation Options
          Text('AI AUTOMATION', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
          SizedBox(height: 8.h),
          _buildAIToggle('AI-Powered Scheduling', 'Optimize time based on member availability', _aiAutomation, (v) {
            setState(() => _aiAutomation = v);
          }),
          _buildAIToggle('AI Attendance Tracking', 'Auto-mark attendance with face recognition', _aiAttendanceTracking, (v) {
            setState(() => _aiAttendanceTracking = v);
          }),
          _buildAIToggle('AI Recommendations', 'Suggest next sessions based on performance', _aiRecommendations, (v) {
            setState(() => _aiRecommendations = v);
          }),
          SizedBox(height: 20.h),

          // Publish Button
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.cyan, Colors.deepPurple]),
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(color: Colors.cyan.withOpacity(0.3), blurRadius: 15.r),
              ],
            ),
            child: ElevatedButton(
              onPressed: _publishSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              ),
              child: Text('PUBLISH SESSION', style: GoogleFonts.orbitron(fontSize: 14.sp, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    bool isSelected = _sessionType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _sessionType = label;
            if (label == 'One-to-One') {
              _capacity = 1;
              _selectedStudents.clear();
            } else {
              _capacity = 25;
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [Colors.cyan, Colors.deepPurple])
                : LinearGradient(colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2)),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.white70, size: 16.sp),
                SizedBox(width: 8.w),
                Text(label, style: GoogleFonts.poppins(color: isSelected ? Colors.white : Colors.white70, fontSize: 12.sp)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentSelector() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: _students.map((student) {
          bool isSelected = _selectedStudents.contains(student['name']);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (_sessionType == 'One-to-One') {
                  // For One-to-One, only one student can be selected
                  _selectedStudents.clear();
                  _selectedStudents.add(student['name']);
                } else {
                  // For Group, multiple students can be selected
                  if (isSelected) {
                    _selectedStudents.remove(student['name']);
                  } else {
                    if (_selectedStudents.length < _capacity) {
                      _selectedStudents.add(student['name']);
                    } else {
                      _showSnackbar('Maximum capacity reached');
                    }
                  }
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.cyan, Colors.purple]),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(student['avatar'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student['name'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
                        Text(student['level'], style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: Colors.cyan, size: 22.sp)
                  else
                    Icon(Icons.radio_button_unchecked, color: Colors.white38, size: 22.sp),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CATEGORY', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
        SizedBox(height: 6.h),
        _buildDropdown('Select Category', _categories, _selectedCategory, (value) {
          setState(() => _selectedCategory = value);
        }),
      ],
    );
  }

  Widget _buildLevelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LEVEL', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
        SizedBox(height: 6.h),
        _buildDropdown('Select Level', _levels, _selectedLevel, (value) {
          setState(() => _selectedLevel = value);
        }),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DATE', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.cyan, size: 16.sp),
                SizedBox(width: 12.w),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TIME', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.cyan, size: 16.sp),
                SizedBox(width: 12.w),
                Text(
                  _selectedTime.format(context),
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DURATION', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _duration,
              dropdownColor: Colors.grey[900],
              style: GoogleFonts.poppins(color: Colors.white),
              icon: Icon(Icons.arrow_drop_down, color: Colors.cyan),
              isExpanded: true,
              items: [30, 45, 60, 75, 90, 120].map((d) {
                return DropdownMenuItem(value: d, child: Text('$d Minutes'));
              }).toList(),
              onChanged: (value) => setState(() => _duration = value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCapacitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LIMIT', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _capacity,
              dropdownColor: Colors.grey[900],
              style: GoogleFonts.poppins(color: Colors.white),
              icon: Icon(Icons.arrow_drop_down, color: Colors.cyan),
              isExpanded: true,
              items: [5, 10, 15, 20, 25, 30, 40, 50].map((c) {
                return DropdownMenuItem(value: c, child: Text('$c Participants'));
              }).toList(),
              onChanged: (value) => setState(() => _capacity = value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModeChip(String mode) {
    bool isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _selectedMode = mode),
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Colors.cyan, Colors.deepPurple])
              : LinearGradient(colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2)),
        ),
        child: Text(mode, style: GoogleFonts.poppins(color: isSelected ? Colors.white : Colors.white70, fontSize: 12.sp)),
      ),
    );
  }

  Widget _buildAIToggle(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.cyan, size: 16.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                Text(subtitle, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 9.sp)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.cyan),
        ],
      ),
    );
  }

  Widget _buildLiveAnalytics() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Class Analytics', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          ..._liveAnalytics.map((analytics) => _buildAnalyticsItem(analytics)),
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(Map<String, dynamic> analytics) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: analytics['color'],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(analytics['title'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp)),
          ),
          Text('${analytics['engagement']}% Engagement', style: GoogleFonts.orbitron(color: analytics['color'], fontSize: 12.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecentBookings() {
    final bookings = [
      {'name': 'Marcus Chen', 'attendance': 92},
      {'name': 'Elena Rodriguez', 'attendance': 78},
    ];
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Bookings', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          ...bookings.map((booking) => _buildBookingItem(booking)),
        ],
      ),
    );
  }

  Widget _buildBookingItem(Map<String, dynamic> booking) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.cyan, Colors.purple]),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(booking['name'][0], style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(booking['name'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ),
          Text('Attendance: ${booking['attendance']}%', style: GoogleFonts.orbitron(color: Colors.cyan, fontSize: 12.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text(hint, style: GoogleFonts.poppins(color: Colors.white38)),
          dropdownColor: Colors.grey[900],
          style: GoogleFonts.poppins(color: Colors.white),
          icon: Icon(Icons.arrow_drop_down, color: Colors.cyan),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.white38),
      prefixIcon: Icon(icon, color: Colors.cyan, size: 18.sp),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.cyan, width: 2),
      ),
    );
  }
}