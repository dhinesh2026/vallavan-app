import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/bottomNavbar/trainer_bottom_nav_bar.dart';

class TrainerMembershipDashboard extends StatefulWidget {
  const TrainerMembershipDashboard({super.key});

  @override
  State<TrainerMembershipDashboard> createState() =>
      _TrainerMembershipDashboardState();
}

class _TrainerMembershipDashboardState extends State<TrainerMembershipDashboard>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  int _selectedIndex = 2; // Members tab selected (index 2)

  // Revenue Data
  double _totalRevenue = 28450.00;
  double _monthlyGrowth = 18.5;
  int _activeMembers = 284;
  int _newMembers = 42;
  double _renewalRate = 94.5;

  // Membership Plans
  final List<Map<String, dynamic>> _membershipPlans = [
    {
      'name': 'Basic',
      'price': 49,
      'period': 'mo',
      'members': 128,
      'color': Colors.blue,
      'features': ['Basic Workouts', 'Community Access', 'Progress Tracking'],
      'isPopular': false,
    },
    {
      'name': 'Pro',
      'price': 99,
      'period': 'mo',
      'members': 96,
      'color': Colors.cyan,
      'features': [
        'AI Personal Coach',
        'Live Classes',
        'Nutrition Plans',
        'Advanced Analytics',
      ],
      'isPopular': true,
    },
    {
      'name': 'Elite',
      'price': 149,
      'period': 'mo',
      'members': 60,
      'color': Colors.purple,
      'features': [
        '1-on-1 Coaching',
        'Unlimited Classes',
        'Custom Plans',
        'Priority Support',
        'AI Insights',
      ],
      'isPopular': false,
    },
  ];

  // Revenue Chart Data
  final List<RevenueData> _revenueData = [
    RevenueData('Jan', 18500),
    RevenueData('Feb', 19200),
    RevenueData('Mar', 21000),
    RevenueData('Apr', 22800),
    RevenueData('May', 24500),
    RevenueData('Jun', 26700),
    RevenueData('Jul', 28450),
  ];

  // Active Members List
  final List<Map<String, dynamic>> _activeMembersList = [
    {
      'name': 'Sarah Johnson',
      'plan': 'Elite',
      'since': 'Mar 2024',
      'progress': 92,
      'avatar': 'SJ',
    },
    {
      'name': 'Mike Chen',
      'plan': 'Pro',
      'since': 'Jan 2024',
      'progress': 78,
      'avatar': 'MC',
    },
    {
      'name': 'Emma Davis',
      'plan': 'Elite',
      'since': 'Feb 2024',
      'progress': 95,
      'avatar': 'ED',
    },
    {
      'name': 'Alex Rivera',
      'plan': 'Basic',
      'since': 'Apr 2024',
      'progress': 65,
      'avatar': 'AR',
    },
    {
      'name': 'Jessica Lee',
      'plan': 'Pro',
      'since': 'Mar 2024',
      'progress': 88,
      'avatar': 'JL',
    },
  ];

  // AI Growth Insights
  final List<Map<String, dynamic>> _aiInsights = [
    {
      'title': 'Growth Velocity',
      'value': '+32%',
      'trend': 'up',
      'description': 'Member growth accelerated this month',
    },
    {
      'title': 'Retention Score',
      'value': '94.5%',
      'trend': 'up',
      'description': 'Highest retention among Elite members',
    },
    {
      'title': 'Upsell Opportunity',
      'value': '23',
      'trend': 'alert',
      'description': 'Basic members ready for Pro upgrade',
    },
  ];

  // Promotional Campaigns
  final List<Map<String, dynamic>> _campaigns = [
    {
      'name': 'Summer Transformation',
      'reach': '2.4k',
      'conversion': '12%',
      'status': 'active',
      'color': Colors.green,
    },
    {
      'name': 'Referral Rewards',
      'reach': '1.8k',
      'conversion': '8%',
      'status': 'active',
      'color': Colors.cyan,
    },
    {
      'name': 'New Year Elite',
      'reach': '3.2k',
      'conversion': '15%',
      'status': 'ended',
      'color': Colors.grey,
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
    // Handle navigation - will be handled by the bottom nav bar's internal navigation
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
                          'Membership Hub',
                          style: GoogleFonts.orbitron(
                            fontSize: 22.sp,
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
                          Icons.filter_alt,
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

                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Revenue',
                                '\$${_totalRevenue.toStringAsFixed(0)}',
                                '+${_monthlyGrowth.toStringAsFixed(0)}%',
                                Icons.attach_money,
                                Colors.green,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatCard(
                                'Active Members',
                                '$_activeMembers',
                                '+$_newMembers',
                                Icons.people,
                                Colors.cyan,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatCard(
                                'Renewal Rate',
                                '${_renewalRate.toStringAsFixed(0)}%',
                                '+5.2%',
                                Icons.autorenew,
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Revenue Chart
                        _buildRevenueChart(),

                        SizedBox(height: 20.h),

                        // Membership Plans
                        _buildMembershipPlans(),

                        SizedBox(height: 20.h),

                        // Membership Analytics
                        _buildMembershipAnalytics(),

                        SizedBox(height: 20.h),

                        // Active Members List
                        _buildActiveMembersList(),

                        SizedBox(height: 20.h),

                        // AI Growth Insights
                        _buildAIGrowthInsights(),

                        SizedBox(height: 20.h),

                        // Promotional Campaigns
                        _buildPromotionalCampaigns(),

                        // Quick Actions
                        _buildQuickActions(),

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
      // ADDED: Trainer Bottom Navigation Bar
      bottomNavigationBar: TrainerBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    double maxY = _revenueData
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
            'Revenue Analytics',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 160.h,
            child: Row(
              children: _revenueData.map((data) {
                double height = (data.revenue / maxY) * 120;
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        width: 25.w,
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

  Widget _buildMembershipPlans() {
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
            'Membership Plans',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: _membershipPlans
                .map((plan) => Expanded(child: _buildPlanCard(plan)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    bool isPopular = plan['isPopular'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            plan['color'].withOpacity(0.15),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isPopular ? Colors.cyan : plan['color'].withOpacity(0.5),
          width: isPopular ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'POPULAR',
                style: GoogleFonts.poppins(
                  color: Colors.cyan,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(height: 4.h),
          Text(
            plan['name'],
            style: GoogleFonts.orbitron(
              color: plan['color'],
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${plan['price']}',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '/${plan['period']}',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            '${plan['members']} members',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 9.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipAnalytics() {
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
            'Membership Analytics',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildAnalyticItem('Churn Rate', '4.2%', '▼ 0.8%', Colors.red),
              SizedBox(width: 12.w),
              _buildAnalyticItem(
                'Avg Lifetime',
                '8.4 mo',
                '▲ 1.2',
                Colors.green,
              ),
              SizedBox(width: 12.w),
              _buildAnalyticItem('LTV', '\$892', '▲ \$124', Colors.cyan),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticItem(
    String label,
    String value,
    String change,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp),
            ),
            Text(
              value,
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              change,
              style: GoogleFonts.poppins(color: color, fontSize: 8.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveMembersList() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Members',
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
          ..._activeMembersList.map((member) => _buildMemberItem(member)),
        ],
      ),
    );
  }

  Widget _buildMemberItem(Map<String, dynamic> member) {
    Color planColor = member['plan'] == 'Elite'
        ? Colors.purple
        : (member['plan'] == 'Pro' ? Colors.cyan : Colors.blue);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [planColor, planColor.withOpacity(0.5)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member['avatar'],
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${member['plan']} Plan • Since ${member['since']}',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${member['progress']}%',
                style: GoogleFonts.orbitron(
                  color: planColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Active',
                style: GoogleFonts.poppins(color: Colors.green, fontSize: 8.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIGrowthInsights() {
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
                'AI Growth Insights',
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
      padding: EdgeInsets.all(8.w),
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
            insight['description'],
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 7.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalCampaigns() {
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
            'Promotional Campaigns',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          ..._campaigns.map((campaign) => _buildCampaignItem(campaign)),
        ],
      ),
    );
  }

  Widget _buildCampaignItem(Map<String, dynamic> campaign) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: campaign['status'] == 'active'
                  ? campaign['color']
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign['name'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Reach: ${campaign['reach']} • Conversion: ${campaign['conversion']}',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: campaign['status'] == 'active'
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              campaign['status'].toUpperCase(),
              style: GoogleFonts.poppins(
                color: campaign['status'] == 'active'
                    ? Colors.green
                    : Colors.grey,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {'icon': Icons.person_add, 'label': 'Add Member', 'color': Colors.cyan},
      {'icon': Icons.email, 'label': 'Send Blast', 'color': Colors.purple},
      {
        'icon': Icons.campaign,
        'label': 'New Campaign',
        'color': Colors.orange,
      },
      {'icon': Icons.analytics, 'label': 'Reports', 'color': Colors.green},
    ];

    return Container(
      margin: EdgeInsets.only(top: 16.h),
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
      child: Row(
        children: actions
            .map(
              (action) => Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              action['color'].withOpacity(0.2),
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          action['icon'],
                          color: action['color'],
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        action['label'],
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class RevenueData {
  final String month;
  final double revenue;
  RevenueData(this.month, this.revenue);
}