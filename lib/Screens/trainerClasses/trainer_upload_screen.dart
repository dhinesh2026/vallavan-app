import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerUploadContentScreen extends StatefulWidget {
  const TrainerUploadContentScreen({super.key});

  @override
  State<TrainerUploadContentScreen> createState() => _TrainerUploadContentScreenState();
}

class _TrainerUploadContentScreenState extends State<TrainerUploadContentScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  
  // Form Data
  final _classTitleController = TextEditingController();
  String? _selectedCategory;
  String? _selectedDifficulty;
  int _duration = 45;
  int _estCalories = 500;
  String? _streamMode; // "RECORDED" or "LIVE"
  String? _visibility; // "Public", "Premium", "Assigned Members"
  List<String> _assignedMembers = [];
  bool _aiOptimization = true;
    
  // Sample Data
  final List<String> _categories = [
    'HIIT', 'Cardio', 'Strength', 'Yoga', 'Pilates', 'MMA', 'Dance', 'Recovery'
  ];
  
  final List<String> _difficulties = ['Beginner', 'Intermediate', 'Advanced', 'Elite'];
  final List<String> _visibilities = ['Public', 'Premium', 'Assigned Members'];
  final List<String> _streamModes = ['RECORDED', 'LIVE'];
  
  // Library Items
  final List<Map<String, dynamic>> _libraryItems = [
    {
      'title': 'Kinetic Power Flow',
      'participants': 320,
      'rating': 4.9,
      'revenue': 1240,
      'status': 'live',
    },
    {
      'title': 'Hyper Burn HIIT',
      'participants': 280,
      'rating': 4.8,
      'revenue': 980,
      'status': 'live',
    },
  ];
  
  // Draft Items
  final List<Map<String, dynamic>> _draftItems = [
    {
      'title': 'Until the Draft #14',
      'lastEdited': '2 hours ago',
      'status': 'draft',
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
    _classTitleController.dispose();
    super.dispose();
  }

  void _saveDraft() {
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
            Icon(Icons.save, color: Colors.cyan, size: 30.sp),
            SizedBox(width: 10.w),
            Text('Draft Saved!', style: GoogleFonts.orbitron(color: Colors.white)),
          ],
        ),
        content: Text(
          'Your class "${_classTitleController.text}" has been saved as draft.',
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

  void _publishClass() {
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
            Text('Class Published!', style: GoogleFonts.orbitron(color: Colors.white)),
          ],
        ),
        content: Text(
          'Your class "${_classTitleController.text}" has been published successfully.',
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
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
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
                          child: Icon(Icons.arrow_back, color: Colors.cyan, size: 18.sp),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.cyan, Colors.purple],
                          ).createShader(bounds),
                          child: Text(
                            'Creator Studio',
                            style: GoogleFonts.orbitron(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      // Action Buttons - Wrapped in Row with mainAxisSize min
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildActionButton('Save Draft', Icons.save, Colors.grey, _saveDraft),
                          SizedBox(width: 10.w),
                          _buildActionButton('Publish', Icons.publish, Colors.cyan, _publishClass),
                        ],
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

                        // Create New Class Section
                        _buildCreateNewClass(),

                        SizedBox(height: 20.h),

                        // Stream Mode & Thumbnail Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildStreamMode()),
                            SizedBox(width: 16.w),
                            Expanded(child: _buildThumbnailUpload()),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // AI Optimization Card
                        _buildAIOptimization(),

                        SizedBox(height: 20.h),

                        // Library & Drafts Section
                        _buildLibraryAndDrafts(),

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

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), Colors.black.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14.sp),
            SizedBox(width: 4.w),
            Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewClass() {
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
          Text('Create New Class', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),

          // Class Title
          Text('Class Title', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
          SizedBox(height: 6.h),
          TextField(
            controller: _classTitleController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: _buildInputDecoration('e.g. Hyper-Metabolic Condition', Icons.title),
          ),
          SizedBox(height: 14.h),

          // Category & Difficulty Row
          Row(
            children: [
              Expanded(child: _buildCategorySelector()),
              SizedBox(width: 12.w),
              Expanded(child: _buildDifficultySelector()),
            ],
          ),
          SizedBox(height: 14.h),

          // Duration & Est Calories Row
          Row(
            children: [
              Expanded(child: _buildDurationSelector()),
              SizedBox(width: 12.w),
              Expanded(child: _buildCaloriesSelector()),
            ],
          ),
          SizedBox(height: 14.h),

          // Visibility Settings
          Text('Visibility', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
          SizedBox(height: 8.h),
          Wrap(
            children: _visibilities.map((visibility) => _buildVisibilityChip(visibility)).toList(),
          ),
          
          // Member Assignment (Only for Assigned Members)
          if (_visibility == 'Assigned Members') ...[
            SizedBox(height: 14.h),
            Text('Assign Members', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
            SizedBox(height: 8.h),
            _buildMemberAssignment(),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
        SizedBox(height: 6.h),
        _buildDropdown('Select Category', _categories, _selectedCategory, (value) {
          setState(() => _selectedCategory = value);
        }),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Difficulty', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
        SizedBox(height: 6.h),
        _buildDropdown('Select Difficulty', _difficulties, _selectedDifficulty, (value) {
          setState(() => _selectedDifficulty = value);
        }),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Duration (mins)', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _duration,
              dropdownColor: Colors.grey[900],
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp),
              icon: Icon(Icons.arrow_drop_down, color: Colors.cyan, size: 18.sp),
              isExpanded: true,
              items: [15, 30, 45, 60, 75, 90, 120].map((d) {
                return DropdownMenuItem(value: d, child: Text('$d mins'));
              }).toList(),
              onChanged: (value) => setState(() => _duration = value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Est. Calories', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.sp)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _estCalories,
              dropdownColor: Colors.grey[900],
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp),
              icon: Icon(Icons.arrow_drop_down, color: Colors.cyan, size: 18.sp),
              isExpanded: true,
              items: [200, 300, 400, 500, 600, 700, 800, 900, 1000].map((c) {
                return DropdownMenuItem(value: c, child: Text('$c kcal'));
              }).toList(),
              onChanged: (value) => setState(() => _estCalories = value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityChip(String visibility) {
    bool isSelected = _visibility == visibility;
    return GestureDetector(
      onTap: () => setState(() => _visibility = visibility),
      child: Container(
        margin: EdgeInsets.only(right: 6.w, bottom: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Colors.cyan, Colors.deepPurple])
              : LinearGradient(colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2)),
        ),
        child: Text(visibility, style: GoogleFonts.poppins(color: isSelected ? Colors.white : Colors.white70, fontSize: 11.sp)),
      ),
    );
  }

  Widget _buildMemberAssignment() {
    final List<Map<String, dynamic>> members = [
      {'name': 'Marcus Chen', 'avatar': 'MC'},
      {'name': 'Elena Rodriguez', 'avatar': 'ER'},
      {'name': 'Sarah Johnson', 'avatar': 'SJ'},
      {'name': 'Mike Chen', 'avatar': 'MC'},
    ];
    
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Wrap(
        spacing: 6.w,
        runSpacing: 6.h,
        children: members.map((member) {
          bool isSelected = _assignedMembers.contains(member['name']);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _assignedMembers.remove(member['name']);
                } else {
                  _assignedMembers.add(member['name']);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: [Colors.cyan, Colors.deepPurple])
                    : null,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(member['avatar'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp)),
                  SizedBox(width: 4.w),
                  Text(member['name'], style: GoogleFonts.poppins(color: isSelected ? Colors.white : Colors.white70, fontSize: 10.sp)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStreamMode() {
    return Container(
      padding: EdgeInsets.all(14.w),
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
          Text('Stream Mode', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          ..._streamModes.map((mode) => _buildStreamModeChip(mode)),
        ],
      ),
    );
  }

  Widget _buildStreamModeChip(String mode) {
    bool isSelected = _streamMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _streamMode = mode),
      child: Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.symmetric(vertical: 10.h),
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
              Icon(mode == 'RECORDED' ? Icons.videocam : Icons.live_tv, 
                  color: isSelected ? Colors.white : Colors.white70, size: 16.sp),
              SizedBox(width: 6.w),
              Text(mode, style: GoogleFonts.orbitron(color: isSelected ? Colors.white : Colors.white70, fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailUpload() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withOpacity(0.2), style: BorderStyle.solid),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, color: Colors.cyan, size: 28.sp),
                  SizedBox(height: 6.h),
                  Text('Drop thumbnail here', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp)),
                  Text('16:9 recommended', style: GoogleFonts.poppins(color: Colors.white38, fontSize: 8.sp)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIOptimization() {
    return Container(
      padding: EdgeInsets.all(14.w),
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
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.auto_awesome, color: Colors.cyan, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Optimization', style: GoogleFonts.orbitron(color: Colors.cyan, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                Text(
                  'Based on your student data, HIIT sessions at 6:00 AM see 40% higher engagement.',
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10.sp),
                ),
              ],
            ),
          ),
          Switch(
            value: _aiOptimization,
            onChanged: (v) => setState(() => _aiOptimization = v),
            activeColor: Colors.cyan,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryAndDrafts() {
    return Container(
      padding: EdgeInsets.all(14.w),
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
              Text('Library & Drafts', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.red),
                ),
                child: Text('LIVE', style: GoogleFonts.poppins(color: Colors.red, fontSize: 8.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ..._libraryItems.map((item) => _buildLibraryItem(item)),
          
          SizedBox(height: 14.h),
          Text('Drafts', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          ..._draftItems.map((draft) => _buildDraftItem(draft)),
        ],
      ),
    );
  }

  Widget _buildLibraryItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.cyan, Colors.purple]),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.play_circle, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                Text('${item['participants']} Participants • ${item['rating']} ★', 
                    style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${item['revenue']}', style: GoogleFonts.orbitron(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              Icon(Icons.analytics, color: Colors.cyan, size: 14.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraftItem(Map<String, dynamic> draft) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.description, color: Colors.orange, size: 24.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(draft['title'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                Text('Last edited ${draft['lastEdited']}', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 9.sp)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.cyan, Colors.deepPurple]),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text('Resume', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text(hint, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11.sp)),
          dropdownColor: Colors.grey[900],
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp),
          icon: Icon(Icons.arrow_drop_down, color: Colors.cyan, size: 18.sp),
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
      hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 11.sp),
      prefixIcon: Icon(icon, color: Colors.cyan, size: 16.sp),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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