import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/bottomNavbar/trainer_bottom_nav_bar.dart';

class TrainerRevenueDashboard extends StatefulWidget {
  const TrainerRevenueDashboard({super.key});

  @override
  State<TrainerRevenueDashboard> createState() =>
      _TrainerRevenueDashboardState();
}

class _TrainerRevenueDashboardState extends State<TrainerRevenueDashboard>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  int _selectedIndex = 4; // Analytics tab selected

  // Revenue Data

  // Membership Breakdown
  final List<Map<String, dynamic>> _membershipPlans = [
    {
      'name': '1 Month',
      'price': 2999,
      'members': 124,
      'revenue': 371876,
      'color': Colors.cyan,
    },
    {
      'name': '6 Month',
      'price': 14999,
      'members': 86,
      'revenue': 1289914,
      'color': Colors.purple,
    },
    {
      'name': '1 Year',
      'price': 24999,
      'members': 74,
      'revenue': 1849926,
      'color': Colors.green,
    },
  ];

  // Revenue Breakdown
  final List<Map<String, dynamic>> _revenueBreakdown = [
    {
      'title': 'Live Classes',
      'amount': 42000,
      'change': '+8%',
      'icon': Icons.video_library,
      'color': Colors.cyan,
    },
    {
      'title': 'Subscriptions',
      'amount': 70000,
      'change': '+15%',
      'icon': Icons.subscriptions,
      'color': Colors.purple,
    },
    {
      'title': '1-on-1 Coaching',
      'amount': 25000,
      'change': '+12%',
      'icon': Icons.person,
      'color': Colors.orange,
    },
  ];

  // Monthly Revenue Data for Chart
  final List<MonthlyRevenue> _monthlyRevenue = [
    MonthlyRevenue('Jan', 185000),
    MonthlyRevenue('Feb', 192000),
    MonthlyRevenue('Mar', 210000),
    MonthlyRevenue('Apr', 228000),
    MonthlyRevenue('May', 245000),
    MonthlyRevenue('Jun', 267000),
    MonthlyRevenue('Jul', 284500),
  ];

  // AI Revenue Insights
  final List<Map<String, dynamic>> _aiInsights = [
    {
      'title': 'Top Revenue Plan',
      'value': '1 Year Plan',
      'subtitle': '₹24,999 per member',
      'trend': 'up',
      'color': Colors.green,
    },
    {
      'title': 'Renewal Forecast',
      'value': '94%',
      'subtitle': 'Next 30 days',
      'trend': 'up',
      'color': Colors.cyan,
    },
    {
      'title': 'Upsell Opportunity',
      'value': '₹1.2L',
      'subtitle': 'Potential revenue',
      'trend': 'alert',
      'color': Colors.orange,
    },
  ];

  // Subscription Analytics
  final List<Map<String, dynamic>> _subscriptionAnalytics = [
    {
      'label': 'Active Members',
      'value': '284',
      'change': '+12',
      'icon': Icons.people,
      'color': Colors.cyan,
    },
    {
      'label': 'Expiring This Month',
      'value': '23',
      'change': '-5',
      'icon': Icons.warning_amber,
      'color': Colors.orange,
    },
    {
      'label': 'Avg Lifetime Value',
      'value': '₹8,420',
      'change': '+15%',
      'icon': Icons.trending_up,
      'color': Colors.green,
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
                          'Revenue Intelligence',
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
                          Icons.filter_list,
                          color: Colors.cyan,
                          size: 20.sp,
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

                        // Total Revenue Card
                        _buildTotalRevenueCard(),

                        SizedBox(height: 16.h),

                        // Revenue Breakdown Row
                        Row(
                          children: _revenueBreakdown
                              .map(
                                (item) =>
                                    Expanded(child: _buildRevenueCard(item)),
                              )
                              .toList(),
                        ),

                        SizedBox(height: 16.h),

                        // Membership Revenue Breakdown
                        _buildMembershipBreakdown(),

                        SizedBox(height: 16.h),

                        // Revenue Chart
                        _buildRevenueChart(),

                        SizedBox(height: 16.h),

                        // Subscription Analytics
                        _buildSubscriptionAnalytics(),

                        SizedBox(height: 16.h),

                        // AI Revenue Insights
                        _buildAIRevenueInsights(),

                        SizedBox(height: 16.h),

                        // Paid vs Free Members
                        _buildPaidVsFreeMembers(),

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

  Widget _buildTotalRevenueCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL NET WORTH',
                style: GoogleFonts.orbitron(
                  color: Colors.white54,
                  fontSize: 10.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.green.shade700],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '+12%',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '₹8,45,200',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Monthly Revenue',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 9.sp,
                        ),
                      ),
                      Text(
                        '₹1.12L',
                        style: GoogleFonts.orbitron(
                          color: Colors.cyan,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+12%',
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Payout Available',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 9.sp,
                        ),
                      ),
                      Text(
                        '₹32,400',
                        style: GoogleFonts.orbitron(
                          color: Colors.green,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Est. Oct 28',
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            item['color'].withOpacity(0.15),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: item['color'].withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(item['icon'], color: item['color'], size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            item['title'],
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp),
          ),
          Text(
            item['amount'].toString(),
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item['change'],
            style: GoogleFonts.poppins(color: Colors.green, fontSize: 8.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBreakdown() {
    double maxRevenue = _membershipPlans
        .map((p) => (p['revenue'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(16.w),
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
          Text(
            'Membership Revenue Breakdown',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          ..._membershipPlans.map((plan) {
            double progress = (plan['revenue'] as num).toDouble() / maxRevenue;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: plan['color'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          plan['name'],
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${((plan['revenue'] as num) / 100000).toStringAsFixed(1)}L',
                      style: GoogleFonts.orbitron(
                        color: plan['color'],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    color: plan['color'],
                    minHeight: 6.h,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${plan['members']} members',
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 9.sp,
                      ),
                    ),
                    Text(
                      '@ ₹${plan['price']}',
                      style: GoogleFonts.poppins(
                        color: plan['color'],
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    double maxY = _monthlyRevenue
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      padding: EdgeInsets.all(16.w),
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
          Text(
            'Revenue Performance',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Revenue Trend',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                '+12% vs last month',
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 160.h,
            child: Row(
              children: _monthlyRevenue.map((data) {
                double height = (data.revenue / maxY) * 120;
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
                      Text(
                        data.month,
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 9.sp,
                        ),
                      ),
                      Text(
                        '₹${(data.revenue / 1000).toInt()}k',
                        style: GoogleFonts.orbitron(
                          color: Colors.white38,
                          fontSize: 8.sp,
                        ),
                      ),
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

  Widget _buildSubscriptionAnalytics() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
          Text(
            'Subscription Analytics',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: _subscriptionAnalytics
                .map((item) => Expanded(child: _buildAnalyticCard(item)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticCard(Map<String, dynamic> item) {
    bool isPositive = item['change'].toString().contains('+');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(item['icon'], color: item['color'], size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            item['value'],
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item['label'],
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp),
          ),
          Text(
            item['change'],
            style: GoogleFonts.poppins(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIRevenueInsights() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.cyan.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.cyan, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'AI Revenue Insights',
                style: GoogleFonts.orbitron(
                  color: Colors.cyan,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: _aiInsights
                .map((insight) => Expanded(child: _buildInsightCard(insight)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(Map<String, dynamic> insight) {
    Color color = insight['trend'] == 'up'
        ? Colors.green
        : (insight['trend'] == 'alert' ? Colors.orange : Colors.cyan);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            insight['title'],
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp),
          ),
          Text(
            insight['value'],
            style: GoogleFonts.orbitron(
              color: color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            insight['subtitle'],
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 8.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaidVsFreeMembers() {
    int paidMembers = 248;
    int freeMembers = 36;
    double paidPercentage = paidMembers / (paidMembers + freeMembers);

    return Container(
      padding: EdgeInsets.all(16.w),
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
          Text(
            'Member Distribution',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'PAID',
                      style: GoogleFonts.orbitron(
                        color: Colors.green,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$paidMembers',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(paidPercentage * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80.w,
                height: 80.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: paidPercentage,
                      strokeWidth: 8,
                      backgroundColor: Colors.white24,
                      color: Colors.green,
                    ),
                    Text(
                      '${(paidPercentage * 100).toInt()}%',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'FREE',
                      style: GoogleFonts.orbitron(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$freeMembers',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${((1 - paidPercentage) * 100).toInt()}%',
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
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                'Renewal Forecast: 94% Next 30 Days',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RevenuePoint {
  final String day;
  final double amount;
  RevenuePoint(this.day, this.amount);
}

class MonthlyRevenue {
  final String month;
  final double revenue;
  MonthlyRevenue(this.month, this.revenue);
}
