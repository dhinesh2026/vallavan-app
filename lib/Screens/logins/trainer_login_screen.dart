import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';
import 'package:vallavanapp/Screens/otp/otp_verfication_screen.dart';

class TrainerOnboardingScreen extends StatefulWidget {
  const TrainerOnboardingScreen({super.key});

  @override
  State<TrainerOnboardingScreen> createState() =>
      _TrainerOnboardingScreenState();
}

class _TrainerOnboardingScreenState extends State<TrainerOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Basic Info
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  int? _age; // ADDED: Age field
  String? _selectedStatus; // ADDED: Working/Studying status
  String? _selectedGender;
  String? _selectedLocation;
  List<String> _selectedLanguages = [];
  String? _profilePhotoPath;

  // Specialization & Experience
  List<String> _selectedSpecializations = [];
  int _experienceYears = 5;
  String? _trainingRank;

  // Coaching Style
  List<String> _coachingStyles = [];
  List<String> _liveClassCategories = [];

  // Equipment
  String? _equipmentChoice;
  List<String> _selectedEquipment = [];

  // Available Timings
  List<String> _selectedTimeSlots = [];

  // Certifications & ID
  bool _idVerified = false;
  String? _idProofPath;

  bool _isLoading = false;
  int _currentStep = 0;
  final int _totalSteps = 5; // Increased to 5 steps

  // Validation error messages for each step
  String? _step0Error;
  String? _step1Error;
  String? _step2Error;
  String? _step3Error;
  String? _step4Error;

  // Options Data
  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  // Working/Studying Status Options
  final List<String> _statusOptions = [
    'Working Professional',
    'Student',
    'Freelancer',
    'Homemaker',
    'Entrepreneur',
    'Other',
  ];

  final List<String> _locations = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Kolkata',
    'Ahmedabad',
    'International',
  ];
  final List<String> _languagesList = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Marathi',
    'Gujarati',
    'Bengali',
    'Punjabi',
  ];
  final List<String> _specializationsList = [
    'Weight Loss',
    'HIIT',
    'Yoga',
    'Bodybuilding',
    'Cardio',
    'MMA',
    'Strength Training',
    'Pilates',
    'Zumba',
    'CrossFit',
    'Calisthenics',
  ];
  final List<String> _trainingRanks = [
    'ELITE TIER',
    'PRO TIER',
    'BEGINNER TIER',
  ];
  final List<String> _coachingStylesList = [
    'Online Coaching',
    'Live Classes',
    'In-Person',
    'Hybrid',
  ];
  final List<String> _liveClassCategoriesList = [
    'HIIT Blast',
    'Yoga Flow',
    'Strength Build',
    'Cardio Burn',
    'MMA Conditioning',
    'Pilates Core',
    'Dance Fitness',
  ];
  final List<String> _equipmentList = [
    'Kettlebell',
    'Dumbbells',
    'TRX / Cable',
    'Mobility Tools',
    'Resistance Bands',
    'Barbell',
    'Battle Ropes',
    'Medicine Ball',
  ];
  final List<String> _equipmentChoices = ['With Equipment', 'No Equipment'];
  final List<String> _timeSlots = [
    'Morning (6 AM - 12 PM)',
    'Afternoon (12 PM - 5 PM)',
    'Evening (5 PM - 9 PM)',
    'Night (9 PM - 12 AM)',
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _fullNameController.addListener(() => _clearStepError(0));
    _mobileController.addListener(() => _clearStepError(0));
    _emailController.addListener(() => _clearStepError(0));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _clearStepError(int step) {
    setState(() {
      if (step == 0) _step0Error = null;
      if (step == 1) _step1Error = null;
      if (step == 2) _step2Error = null;
      if (step == 3) _step3Error = null;
      if (step == 4) _step4Error = null;
    });
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        if (_currentStep < _totalSteps - 1) {
          _currentStep++;
        }
      });
    }
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _validateStep0();
      case 1:
        return _validateStep1();
      case 2:
        return _validateStep2();
      case 3:
        return _validateStep3();
      case 4:
        return _validateStep4();
      default:
        return true;
    }
  }

  bool _validateStep0() {
    if (_fullNameController.text.trim().isEmpty) {
      setState(() => _step0Error = 'Please enter your full name');
      _showSnackbar('Please enter your full name');
      return false;
    }
    if (_fullNameController.text.trim().length < 3) {
      setState(() => _step0Error = 'Name must be at least 3 characters');
      _showSnackbar('Name must be at least 3 characters');
      return false;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _step0Error = 'Please enter your email');
      _showSnackbar('Please enter your email');
      return false;
    }
    if (!_isValidEmail(email)) {
      setState(() => _step0Error = 'Please enter a valid email address');
      _showSnackbar('Please enter a valid email address');
      return false;
    }

    final mobile = _mobileController.text.trim();
    if (mobile.isEmpty) {
      setState(() => _step0Error = 'Please enter mobile number');
      _showSnackbar('Please enter mobile number');
      return false;
    }
    if (mobile.length != 10) {
      setState(() => _step0Error = 'Please enter valid 10-digit mobile number');
      _showSnackbar('Please enter valid 10-digit mobile number');
      return false;
    }
    if (!_isValidMobile(mobile)) {
      setState(() => _step0Error = 'Please enter a valid Indian mobile number');
      _showSnackbar('Please enter a valid Indian mobile number');
      return false;
    }

    if (_selectedGender == null) {
      setState(() => _step0Error = 'Please select your gender');
      _showSnackbar('Please select your gender');
      return false;
    }

    if (_selectedLocation == null) {
      setState(() => _step0Error = 'Please select your location');
      _showSnackbar('Please select your location');
      return false;
    }

    if (_selectedLanguages.isEmpty) {
      setState(() => _step0Error = 'Please select at least one language');
      _showSnackbar('Please select at least one language');
      return false;
    }

    setState(() => _step0Error = null);
    return true;
  }

  bool _validateStep1() {
    if (_selectedSpecializations.isEmpty) {
      setState(() => _step1Error = 'Please select at least one specialization');
      _showSnackbar('Please select at least one specialization');
      return false;
    }
    if (_trainingRank == null) {
      setState(() => _step1Error = 'Please select your training rank');
      _showSnackbar('Please select your training rank');
      return false;
    }
    setState(() => _step1Error = null);
    return true;
  }

  bool _validateStep2() {
    if (_coachingStyles.isEmpty) {
      setState(() => _step2Error = 'Please select at least one coaching style');
      _showSnackbar('Please select at least one coaching style');
      return false;
    }
    if (_liveClassCategories.isEmpty) {
      setState(
        () => _step2Error = 'Please select at least one live class category',
      );
      _showSnackbar('Please select at least one live class category');
      return false;
    }
    if (_equipmentChoice == null) {
      setState(() => _step2Error = 'Please select equipment preference');
      _showSnackbar('Please select equipment preference');
      return false;
    }
    setState(() => _step2Error = null);
    return true;
  }

  bool _validateStep3() {
    if (_selectedTimeSlots.isEmpty) {
      setState(() => _step3Error = 'Please select at least one time slot');
      _showSnackbar('Please select at least one time slot');
      return false;
    }
    if (!_idVerified) {
      setState(() => _step3Error = 'Please verify your ID');
      _showSnackbar('Please verify your ID');
      return false;
    }
    setState(() => _step3Error = null);
    return true;
  }

  bool _validateStep4() {
    if (_age == null) {
      setState(() => _step4Error = 'Please enter your age');
      _showSnackbar('Please enter your age');
      return false;
    }
    if (_age! < 18) {
      setState(() => _step4Error = 'Age must be at least 18 years');
      _showSnackbar('Age must be at least 18 years');
      return false;
    }
    if (_age! > 100) {
      setState(() => _step4Error = 'Please enter a valid age');
      _showSnackbar('Please enter a valid age');
      return false;
    }
    if (_selectedStatus == null) {
      setState(() => _step4Error = 'Please select your status');
      _showSnackbar('Please select your status');
      return false;
    }
    setState(() => _step4Error = null);
    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidMobile(String mobile) {
    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    return mobileRegex.hasMatch(mobile);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_validateCurrentStep()) return;

    if (!_validateStep0() ||
        !_validateStep1() ||
        !_validateStep2() ||
        !_validateStep3() ||
        !_validateStep4()) {
      _showSnackbar('Please complete all steps correctly');
      return;
    }

    setState(() => _isLoading = true);

    final trainerData = {
      'fullName': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'mobileNumber': _mobileController.text.trim(),
      'age': _age,
      'status': _selectedStatus,
      'gender': _selectedGender,
      'location': _selectedLocation,
      'languages': _selectedLanguages,
      'specializations': _selectedSpecializations,
      'experienceYears': _experienceYears,
      'trainingRank': _trainingRank,
      'coachingStyles': _coachingStyles,
      'liveClassCategories': _liveClassCategories,
      'equipmentChoice': _equipmentChoice,
      'equipment': _selectedEquipment,
      'availableTimings': _selectedTimeSlots,
      'idVerified': _idVerified,
      'profilePhoto': _profilePhotoPath,
      'idProof': _idProofPath,
      'onboardingCompleted': true,
      'onboardingStep': 5,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isLoading = false);

    Get.to(
      () => OtpVerificationScreen(
        phoneNumber: _mobileController.text,
        role: "trainer",
        trainerData: trainerData,
      ),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildErrorWidget(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 14.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              error,
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
            blurRadius: 20.r,
            spreadRadius: 5.r,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSelectionChip(
    String label,
    List<String> selectedList,
    VoidCallback onTap,
  ) {
    bool isSelected = selectedList.contains(label);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Colors.cyan, Colors.cyan.shade700])
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.03),
                  ],
                ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.3),
                    blurRadius: 8.r,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingButton(
    String text,
    VoidCallback onTap, {
    bool isLarge = true,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isLarge ? double.infinity : null,
      height: isLarge ? 55.h : 45.h,
      padding: isLarge ? null : EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.cyan, Colors.deepPurple]),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.3),
            blurRadius: 15.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.orbitron(
            fontSize: isLarge ? 14.sp : 12.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.cyan,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.white38),
      prefixIcon: Icon(icon, color: Colors.cyan, size: 20.sp),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: const BorderSide(color: Colors.cyan, width: 2),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentStep == index
                ? Colors.cyan
                : _currentStep > index
                ? Colors.cyan.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
          ),
        );
      }),
    );
  }

  // NEW: Age & Status Selection Step (Step 4)
  Widget _buildAgeStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AGE *',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _age,
              hint: Text(
                'Select your age',
                style: GoogleFonts.poppins(color: Colors.white38),
              ),
              dropdownColor: Colors.grey[900],
              style: GoogleFonts.poppins(color: Colors.white),
              icon: Icon(Icons.arrow_drop_down, color: Colors.cyan),
              isExpanded: true,
              items: List.generate(83, (index) => index + 18).map((age) {
                return DropdownMenuItem(value: age, child: Text('$age years'));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _age = value;
                  _clearStepError(4);
                });
              },
            ),
          ),
        ),
        SizedBox(height: 24.h),

        Text(
          'WORKING / STUDYING STATUS *',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 10.h,
          children: _statusOptions.map((status) {
            bool isSelected = _selectedStatus == status;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStatus = status;
                  _clearStepError(4);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(colors: [Colors.cyan, Colors.deepPurple])
                      : LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.03),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.cyan
                        : Colors.white.withOpacity(0.2),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.3),
                            blurRadius: 8.r,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        _buildErrorWidget(_step4Error),
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.cyan, Colors.deepPurple],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.5),
                blurRadius: 30.r,
                spreadRadius: 5.r,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Image.asset(
              "assets/images/splash_logo.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.cyan, Colors.cyanAccent],
          ).createShader(bounds),
          child: Text(
            'VallavanFitness',
            style: GoogleFonts.orbitron(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Build Your Trainer Profile',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10.sp),
        ),
      ],
    );
  }

  // STEP 0: Basic Info
  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _profilePhotoPath = 'assets/images/logo.png';
              });
            },
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.cyan, Colors.deepPurple],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.5),
                    blurRadius: 20.r,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 48.r,
                backgroundColor: Colors.transparent,
                backgroundImage: _profilePhotoPath != null
                    ? const AssetImage('assets/images/logo.png')
                          as ImageProvider
                    : null,
                child: _profilePhotoPath == null
                    ? Icon(Icons.camera_alt, color: Colors.white, size: 30.sp)
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        Text(
          'FULL NAME *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _fullNameController,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: _buildInputDecoration(
            'Enter your full name',
            Icons.person_outline,
          ),
        ),
        SizedBox(height: 16.h),

        Text(
          'EMAIL ADDRESS *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: _buildInputDecoration(
            'trainer@example.com',
            Icons.email_outlined,
          ),
        ),
        SizedBox(height: 16.h),

        Text(
          'MOBILE NUMBER *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  '+91',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: '98765 43210',
                  hintStyle: GoogleFonts.poppins(color: Colors.white38),
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(color: Colors.cyan, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        Text(
          'GENDER *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Row(
          children: _genders
              .map(
                (gender) => Expanded(
                  child: _buildSelectionChip(
                    gender,
                    [_selectedGender ?? ''],
                    () {
                      setState(() => _selectedGender = gender);
                      _clearStepError(0);
                    },
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 16.h),

        Text(
          'LOCATION *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Wrap(
          children: _locations
              .map(
                (loc) =>
                    _buildSelectionChip(loc, [_selectedLocation ?? ''], () {
                      setState(() => _selectedLocation = loc);
                      _clearStepError(0);
                    }),
              )
              .toList(),
        ),
        SizedBox(height: 16.h),

        Text(
          'LANGUAGES KNOWN *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Wrap(
          children: _languagesList
              .map(
                (lang) => _buildSelectionChip(lang, _selectedLanguages, () {
                  setState(() {
                    if (_selectedLanguages.contains(lang)) {
                      _selectedLanguages.remove(lang);
                    } else {
                      _selectedLanguages.add(lang);
                    }
                    _clearStepError(0);
                  });
                }),
              )
              .toList(),
        ),
        _buildErrorWidget(_step0Error),
      ],
    );
  }

  // STEP 1: Specialization & Experience
  Widget _buildSpecializationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SPECIALIZATION *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Wrap(
          children: _specializationsList
              .map(
                (spec) =>
                    _buildSelectionChip(spec, _selectedSpecializations, () {
                      setState(() {
                        if (_selectedSpecializations.contains(spec)) {
                          _selectedSpecializations.remove(spec);
                        } else {
                          _selectedSpecializations.add(spec);
                        }
                        _clearStepError(1);
                      });
                    }),
              )
              .toList(),
        ),
        SizedBox(height: 30.h),

        Text(
          'EXPERIENCE YEARS',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Text(
              '${_experienceYears}y',
              style: GoogleFonts.orbitron(color: Colors.cyan, fontSize: 32.sp),
            ),
            Expanded(
              child: Slider(
                value: _experienceYears.toDouble(),
                min: 0,
                max: 30,
                divisions: 30,
                activeColor: Colors.cyan,
                onChanged: (v) => setState(() => _experienceYears = v.toInt()),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),

        Text(
          'TRAINING RANK *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Row(
          children: _trainingRanks.map((rank) {
            bool isSelected = _trainingRank == rank;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _trainingRank = rank);
                  _clearStepError(1);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: [Colors.amber, Colors.orange])
                        : LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: isSelected
                          ? Colors.amber
                          : Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        rank.split(' ')[0],
                        style: GoogleFonts.orbitron(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        rank.split(' ')[1],
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.black87 : Colors.white54,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        _buildErrorWidget(_step1Error),
      ],
    );
  }

  // STEP 2: Coaching Style & Equipment
  Widget _buildCoachingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COACHING STYLE *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Wrap(
          children: _coachingStylesList
              .map(
                (style) => _buildSelectionChip(style, _coachingStyles, () {
                  setState(() {
                    if (_coachingStyles.contains(style)) {
                      _coachingStyles.remove(style);
                    } else {
                      _coachingStyles.add(style);
                    }
                    _clearStepError(2);
                  });
                }),
              )
              .toList(),
        ),
        SizedBox(height: 30.h),

        Text(
          'LIVE CLASS CATEGORIES *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Wrap(
          children: _liveClassCategoriesList
              .map(
                (cat) => _buildSelectionChip(cat, _liveClassCategories, () {
                  setState(() {
                    if (_liveClassCategories.contains(cat)) {
                      _liveClassCategories.remove(cat);
                    } else {
                      _liveClassCategories.add(cat);
                    }
                    _clearStepError(2);
                  });
                }),
              )
              .toList(),
        ),
        SizedBox(height: 30.h),

        Text(
          'EQUIPMENT EXPERTISE *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Row(
          children: _equipmentChoices
              .map(
                (choice) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _equipmentChoice = choice;
                        if (choice == 'No Equipment') {
                          _selectedEquipment.clear();
                        }
                        _clearStepError(2);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: _equipmentChoice == choice
                            ? LinearGradient(
                                colors: choice == 'No Equipment'
                                    ? [
                                        Colors.grey.shade700,
                                        Colors.grey.shade900,
                                      ]
                                    : [Colors.cyan, Colors.cyan.shade700],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.08),
                                  Colors.white.withOpacity(0.03),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: _equipmentChoice == choice
                              ? Colors.cyan
                              : Colors.white.withOpacity(0.2),
                          width: _equipmentChoice == choice ? 1.5 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          choice,
                          style: GoogleFonts.poppins(
                            color: _equipmentChoice == choice
                                ? Colors.white
                                : Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 16.h),

        if (_equipmentChoice == 'With Equipment')
          Wrap(
            children: _equipmentList
                .map(
                  (eq) => _buildSelectionChip(eq, _selectedEquipment, () {
                    setState(() {
                      if (_selectedEquipment.contains(eq)) {
                        _selectedEquipment.remove(eq);
                      } else {
                        _selectedEquipment.add(eq);
                      }
                    });
                  }),
                )
                .toList(),
          ),

        if (_equipmentChoice == 'No Equipment')
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Center(
              child: Text(
                '✓ No equipment needed - Bodyweight training only',
                style: GoogleFonts.poppins(
                  color: Colors.greenAccent,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        _buildErrorWidget(_step2Error),
      ],
    );
  }

  // STEP 3: Timings & Certifications
  Widget _buildTimingsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AVAILABLE TIMINGS *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: _timeSlots.map((slot) {
              bool isSelected = _selectedTimeSlots.contains(slot);
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          slot,
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                      Switch(
                        value: isSelected,
                        onChanged: (v) {
                          setState(() {
                            if (v) {
                              _selectedTimeSlots.add(slot);
                            } else {
                              _selectedTimeSlots.remove(slot);
                            }
                            _clearStepError(3);
                          });
                        },
                        activeColor: Colors.cyan,
                      ),
                    ],
                  ),
                  if (slot != _timeSlots.last) Divider(color: Colors.white24),
                ],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 30.h),

        Text(
          'ID VERIFICATION *',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () {
            setState(() {
              _idVerified = true;
              _clearStepError(3);
            });
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: _idVerified
                  ? LinearGradient(
                      colors: [
                        Colors.green.shade700.withOpacity(0.2),
                        Colors.green.shade900.withOpacity(0.2),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: _idVerified
                    ? Colors.green
                    : Colors.white.withOpacity(0.2),
                width: _idVerified ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _idVerified ? Icons.verified : Icons.upload_file,
                  color: _idVerified ? Colors.green : Colors.cyan,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _idVerified
                        ? 'ID Verified ✓'
                        : 'Upload ID Proof (Aadhar/PAN/Passport)',
                    style: GoogleFonts.poppins(
                      color: _idVerified ? Colors.green : Colors.white70,
                    ),
                  ),
                ),
                if (!_idVerified)
                  Icon(Icons.arrow_forward, color: Colors.cyan, size: 20.sp),
              ],
            ),
          ),
        ),
        _buildErrorWidget(_step3Error),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stepWidgets = [
      _buildBasicInfo(),
      _buildSpecializationStep(),
      _buildCoachingStep(),
      _buildTimingsStep(),
      _buildAgeStatusSelector(), // NEW: Age & Status step added
    ];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: _glowAnimation.value,
                    colors: [
                      Colors.cyan.shade900.withOpacity(0.3),
                      Colors.deepPurple.shade900.withOpacity(0.5),
                      Colors.black,
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),

          ...List.generate(3, (index) {
            return Positioned(
              top: 100.h + (index * 150),
              left: -50.w + (index * 100),
              child: TweenAnimationBuilder(
                duration: Duration(seconds: 5 + index),
                tween: Tween<double>(begin: 0, end: 2 * pi),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(sin(value) * 20, cos(value) * 20),
                    child: Container(
                      width: 150.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.cyan.withOpacity(0.15),
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

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16.h),

                _buildLogo(),

                SizedBox(height: 16.h),

                _buildStepIndicator(),

                SizedBox(height: 6.h),

                Text(
                  'STEP ${_currentStep + 1} OF $_totalSteps',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyan,
                    fontSize: 10.sp,
                    letterSpacing: 2,
                  ),
                ),

                SizedBox(height: 16.h),

                // Stats Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Experience',
                          '${_experienceYears}+',
                        ),
                      ),
                      Expanded(
                        child: _buildStatCard(
                          'Specializations',
                          '${_selectedSpecializations.length}+',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildGlassContainer(
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: stepWidgets[_currentStep],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        GestureDetector(
                          onTap: _previousStep,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            height: 48.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'BACK',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) SizedBox(width: 12.w),
                      Expanded(
                        child: _buildGlowingButton(
                          _currentStep == _totalSteps - 1
                              ? 'LAUNCH MY TRAINER PLATFORM'
                              : 'NEXT',
                          _currentStep == _totalSteps - 1
                              ? _handleSubmit
                              : _nextStep,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: SpinKitFoldingCube(color: Colors.cyan, size: 50.sp),
              ),
            ),
        ],
      ),
    );
  }
}
