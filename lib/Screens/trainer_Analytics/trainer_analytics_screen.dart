import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/bottomNavbar/trainer_bottom_nav_bar.dart';

class TrainerAnalyticsDashboard extends StatefulWidget {
  const TrainerAnalyticsDashboard({super.key});

  @override
  State<TrainerAnalyticsDashboard> createState() => _TrainerAnalyticsDashboardState();
}

class _TrainerAnalyticsDashboardState extends State<TrainerAnalyticsDashboard>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
// 0: Weekly, 1: Monthly, 2: Yearly
  int _selectedPayoutTab = 0; // 0: All, 1: Pending, 2: Completed
  int _selectedIndex = 3; // Analytics tab selected (index 3 for Earnings/Analytics)

  // Revenue Data
  final List<RevenuePoint> _weeklyRevenue = [
    RevenuePoint('MON', 28500),
    RevenuePoint('TUE', 31200),
    RevenuePoint('WED', 29800),
    RevenuePoint('THU', 34500),
    RevenuePoint('FRI', 37800),
    RevenuePoint('SAT', 32450),
  ];

  // Top Performing Students
  final List<Map<String, dynamic>> _topStudents = [
    {'name': 'Sarah Johnson', 'progress': 94, 'attendance': 98, 'avatar': 'SJ', 'color': Colors.cyan},
    {'name': 'Mike Chen', 'progress': 88, 'attendance': 92, 'avatar': 'MC', 'color': Colors.purple},
    {'name': 'Emma Davis', 'progress': 96, 'attendance': 95, 'avatar': 'ED', 'color': Colors.green},
    {'name': 'Alex Rivera', 'progress': 82, 'attendance': 86, 'avatar': 'AR', 'color': Colors.orange},
  ];

  // At-Risk Members
  final List<Map<String, dynamic>> _atRiskMembers = [
    {'name': 'John Smith', 'lastActive': '5 days ago', 'attendance': 45, 'reason': 'Low engagement'},
    {'name': 'Lisa Wong', 'lastActive': '7 days ago', 'attendance': 38, 'reason': 'Missed classes'},
    {'name': 'David Kim', 'lastActive': '4 days ago', 'attendance': 52, 'reason': 'Inconsistent'},
  ];

  // Payout History
  final List<Map<String, dynamic>> _payoutHistory = [
    {'amount': 45000, 'date': 'Oct 20', 'id': 'TXN-94021', 'bank': 'HDFC Bank', 'status': 'completed'},
    {'amount': 32400, 'date': 'Oct 28', 'id': 'UPCOMING', 'bank': 'Upcoming Transfer', 'status': 'pending'},
    {'amount': 28500, 'date': 'Oct 12', 'id': 'TXN-82011', 'bank': 'UPI Transfer', 'status': 'completed'},
  ];

  // Top Performing Content
  final List<Map<String, dynamic>> _topContent = [
    {'title': 'Hyper-Burn 3000', 'revenue': 12400, 'cpa': 85, 'students': 142, 'color': Colors.red},
    {'title': 'Cyber-Zen Flow', 'revenue': 8200, 'cpa': 110, 'students': 98, 'color': Colors.cyan},
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
        // Navigate to Live Classes
        break;
      case 2:
        // Navigate to Members
        break;
      case 3:
        // Already on Analytics
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
                          colors: [Colors.cyan.withOpacity(0.08), Colors.transparent],
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
                          'Analytics Intelligence',
                          style: GoogleFonts.orbitron(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
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

                        // Revenue Stats Row
                        _buildRevenueStats(),

                        SizedBox(height: 16.h),

                        // Revenue Breakdown
                        Row(
                          children: [
                            Expanded(child: _buildRevenueCard('Live Classes', '₹42,000', '+8%', Icons.video_library, Colors.cyan)),
                            SizedBox(width: 12.w),
                            Expanded(child: _buildRevenueCard('Subscriptions', '₹70,000', '+15%', Icons.subscriptions, Colors.purple)),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Weekly Revenue Chart
                        _buildWeeklyRevenueChart(),

                        SizedBox(height: 16.h),

                        // Performance Metrics Row
                        Row(
                          children: [
                            Expanded(child: _buildMetricRing('Attendance', 87, Colors.green)),
                            SizedBox(width: 12.w),
                            Expanded(child: _buildMetricRing('Completion Rate', 92, Colors.cyan)),
                            SizedBox(width: 12.w),
                            Expanded(child: _buildMetricRing('Retention', 94, Colors.purple)),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Student Analytics Section
                        _buildStudentAnalytics(),

                        SizedBox(height: 16.h),

                        // Top Performing Students
                        _buildTopStudents(),

                        SizedBox(height: 16.h),

                        // At-Risk Members
                        _buildAtRiskMembers(),

                        SizedBox(height: 16.h),

                        // Payout Section
                        _buildPayoutSection(),

                        SizedBox(height: 16.h),

                        // ROI Intelligence
                        _buildROIIntelligence(),

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

  Widget _buildRevenueStats() {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL NET WORTH', style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 10.sp)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green, Colors.green.shade700]),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text('+12%', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Text('₹8,45,200', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Monthly', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
                    Text('₹1.12L', style: GoogleFonts.orbitron(color: Colors.cyan, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(width: 1.w, height: 30.h, color: Colors.white24),
              Expanded(
                child: Column(
                  children: [
                    Text('Payout Available', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
                    Text('₹32,400', style: GoogleFonts.orbitron(color: Colors.green, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(String title, String amount, String change, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), Colors.black.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16.sp),
              const Spacer(),
              Text(change, style: GoogleFonts.poppins(color: Colors.green, fontSize: 10.sp)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(amount, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
          Text(title, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
        ],
      ),
    );
  }

  Widget _buildWeeklyRevenueChart() {
    double maxY = _weeklyRevenue.map((e) => e.amount).reduce((a, b) => a > b ? a : b).toDouble();
    
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
              Text('Performance Analysis', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
              Text('Weekly Revenue Growth', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
            ],
          ),
          Text('₹32,450 this week', style: GoogleFonts.orbitron(color: Colors.cyan, fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          SizedBox(
            height: 140.h,
            child: Row(
              children: _weeklyRevenue.map((data) {
                double height = (data.amount / maxY) * 100;
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        width: 28.w,
                        height: height.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.cyan, Colors.purple],
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(data.day, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRing(String label, int percentage, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 60.w,
            height: 60.w,
            child: TweenAnimationBuilder(
              duration: const Duration(seconds: 2),
              tween: Tween<double>(begin: 0, end: percentage / 100),
              builder: (context, double value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: 6,
                      backgroundColor: Colors.white24,
                      color: color,
                    ),
                    Text('$percentage%', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10.sp)),
        ],
      ),
    );
  }

  Widget _buildStudentAnalytics() {
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
          Text('Student Analytics', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildAnalyticItem('Active Students', '284', '+12', Icons.people, Colors.cyan),
              SizedBox(width: 12.w),
              _buildAnalyticItem('Workout Completion', '87%', '+5%', Icons.fitness_center, Colors.green),
              SizedBox(width: 12.w),
              _buildAnalyticItem('Live Engagement', '76%', '+8%', Icons.video_library, Colors.purple),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildAnalyticItem('Nutrition Compliance', '82%', '+3%', Icons.restaurant, Colors.orange),
              SizedBox(width: 12.w),
              _buildAnalyticItem('Transformation Rate', '68%', '+10%', Icons.trending_up, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticItem(String label, String value, String change, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(height: 4.h),
            Text(value, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 8.sp)),
            Text(change, style: GoogleFonts.poppins(color: Colors.green, fontSize: 8.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStudents() {
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
              Text('Top Performing Students', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: Text('View All', style: GoogleFonts.poppins(color: Colors.cyan, fontSize: 11.sp)),
              ),
            ],
          ),
          ..._topStudents.map((student) => _buildTopStudentItem(student)),
        ],
      ),
    );
  }

  Widget _buildTopStudentItem(Map<String, dynamic> student) {
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
              gradient: LinearGradient(colors: [student['color'], student['color'].withOpacity(0.5)]),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(student['avatar'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student['name'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
                Text('Progress: ${student['progress']}%', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
              ],
            ),
          ),
          _buildProgressRing(student['progress'], Colors.cyan),
        ],
      ),
    );
  }

  Widget _buildProgressRing(int percentage, Color color) {
    return SizedBox(
      width: 35.w,
      height: 35.w,
      child: CircularProgressIndicator(
        value: percentage / 100,
        strokeWidth: 3,
        backgroundColor: Colors.white24,
        color: color,
      ),
    );
  }

  Widget _buildAtRiskMembers() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.15), Colors.deepPurple.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.red, size: 16.sp),
              SizedBox(width: 8.w),
              Text('At-Risk Members', style: GoogleFonts.orbitron(color: Colors.red, fontSize: 14.sp, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${_atRiskMembers.length} members', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
            ],
          ),
          SizedBox(height: 12.h),
          ..._atRiskMembers.map((member) => _buildAtRiskItem(member)),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.cyan, Colors.deepPurple]),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text('Send AI Engagement Blast', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAtRiskItem(Map<String, dynamic> member) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member['name'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                Text('Last active: ${member['lastActive']}', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp)),
              ],
            ),
          ),
          Text('${member['attendance']}%', style: GoogleFonts.orbitron(color: Colors.red, fontSize: 14.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPayoutSection() {
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
          Text('Payout Logic', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildPayoutTab('All', 0, 3),
              _buildPayoutTab('Pending', 1, 1),
              _buildPayoutTab('Completed', 2, 2),
            ],
          ),
          SizedBox(height: 12.h),
          ..._payoutHistory
              .where((p) => _selectedPayoutTab == 0 || 
                  (_selectedPayoutTab == 1 && p['status'] == 'pending') ||
                  (_selectedPayoutTab == 2 && p['status'] == 'completed'))
              .map((payout) => _buildPayoutItem(payout)),
        ],
      ),
    );
  }

  Widget _buildPayoutTab(String title, int index, int count) {
    bool isSelected = _selectedPayoutTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPayoutTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            gradient: isSelected ? LinearGradient(colors: [Colors.cyan, Colors.deepPurple]) : null,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2)),
          ),
          child: Center(
            child: Text(title, style: GoogleFonts.orbitron(color: isSelected ? Colors.white : Colors.white70, fontSize: 11.sp)),
          ),
        ),
      ),
    );
  }

  Widget _buildPayoutItem(Map<String, dynamic> payout) {
    bool isPending = payout['status'] == 'pending';
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: isPending ? Colors.orange.withOpacity(0.3) : Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isPending ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(isPending ? Icons.schedule : Icons.check_circle, color: isPending ? Colors.orange : Colors.green, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('₹${payout['amount']}', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                Text(payout['date'], style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
                if (payout['id'] != 'UPCOMING')
                  Text(payout['id'], style: GoogleFonts.poppins(color: Colors.white38, fontSize: 8.sp)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isPending ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(payout['status'].toUpperCase(), style: GoogleFonts.poppins(color: isPending ? Colors.orange : Colors.green, fontSize: 9.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildROIIntelligence() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.withOpacity(0.15), Colors.deepPurple.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.cyan.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: Colors.cyan, size: 18.sp),
              SizedBox(width: 8.w),
              Text('ROI Intelligence', style: GoogleFonts.orbitron(color: Colors.cyan, fontSize: 14.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12.h),
          Text('Top Performing Content', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11.sp)),
          ..._topContent.map((content) => _buildContentItem(content)),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildROIMetric('Rev per Student', '₹840', '+12%'),
              SizedBox(width: 12.w),
              _buildROIMetric('Retention Rate', '92%', '+5%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem(Map<String, dynamic> content) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: content['color'],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(content['title'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${content['revenue']}', style: GoogleFonts.orbitron(color: Colors.cyan, fontSize: 14.sp, fontWeight: FontWeight.bold)),
              Text('CPA: ₹${content['cpa']}', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildROIMetric(String label, String value, String change) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp)),
            Text(value, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            Text(change, style: GoogleFonts.poppins(color: Colors.green, fontSize: 9.sp)),
          ],
        ),
      ),
    );
  }
}

class RevenuePoint {
  final String day;
  final double amount;
  RevenuePoint(this.day, this.amount);
}