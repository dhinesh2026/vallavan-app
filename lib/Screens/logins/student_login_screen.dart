import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';

import 'package:vallavanapp/Screens/otp/otp_verfication_screen.dart';

class StudentOnboardingScreen extends StatefulWidget {
  const StudentOnboardingScreen({super.key});

  @override
  State<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState extends State<StudentOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Page index for step-by-step flow
  int _currentStep = 0;

  // Form data
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  int? _age; // ADDED: Age field
  String? _selectedStatus; // ADDED: Working or Studying status
  String? _selectedGender;
  String? _selectedObjective;
  String? _selectedDiet;
  double _height = 170;
  double _weight = 70;
  String? _selectedClassType;
  TimeOfDay? _selectedTime;
  final _medicalInfoController = TextEditingController();
  final _mobileController = TextEditingController();

  bool _isLoading = false;

  // Error messages
  String? _step0Error;
  String? _step1Error;
  String? _step2Error;
  String? _step3Error;
  String? _step4Error; // ADDED: Age/Status error
  String? _step6Error;
  String? _step7Error;
  String? _step8Error;

  // Options
  final List<String> _genders = ['Male', 'Female', 'Other'];

  // Working/Studying Status Options
  final List<String> _statusOptions = [
    'Working Professional',
    'Student',
    'Freelancer',
    'Homemaker',
    'Entrepreneur',
    'Other',
  ];

  final List<String> _objectives = [
    'Study Focused (Mostly Sitting)',
    'Campus Active (Walking Daily)',
    'Fitness Beginner',
    'Regular Gym Goer',
    'Sports & Athlete',
  ];

  final List<String> _diets = [
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Weight Loss Diet',
    'Muscle Gain Diet',
    'Balanced Diet',
    'High Protein Diet',
  ];

  final List<String> _classTypes = [
    '1-to-1 Personal Training',
    'Group Classes (2-5 students)',
    'Large Group (6-12 students)',
  ];

  // Total steps
  final int _totalSteps = 10; // Increased to 10 steps

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

    _firstNameController.addListener(() => _clearStepError(0));
    _emailController.addListener(() => _clearStepError(0));
    _mobileController.addListener(() => _clearStepError(9));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _medicalInfoController.dispose();
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
      if (step == 5) if (step == 6) _step6Error = null;
      if (step == 7) _step7Error = null;
      if (step == 8) _step8Error = null;
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
        return _validateStep4(); // Age & Status validation
      case 5:
        return _validateStep5(); // Height & Weight
      case 6:
        return _validateStep6(); // Class Type
      case 7:
        return _validateStep7(); // Preferred Time
      case 8:
        return true; // Medical info optional
      case 9:
        return _validateStep9(); // Mobile Number
      default:
        return true;
    }
  }

  bool _validateStep0() {
    if (_firstNameController.text.trim().isEmpty) {
      setState(() => _step0Error = 'Please enter your first name');
      _showSnackbar('Please enter your first name');
      return false;
    }
    if (_firstNameController.text.trim().length < 2) {
      setState(() => _step0Error = 'Name must be at least 2 characters');
      _showSnackbar('Name must be at least 2 characters');
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      setState(() => _step0Error = 'Please enter your email');
      _showSnackbar('Please enter your email');
      return false;
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      setState(() => _step0Error = 'Please enter a valid email');
      _showSnackbar('Please enter a valid email');
      return false;
    }
    setState(() => _step0Error = null);
    return true;
  }

  bool _validateStep1() {
    if (_selectedGender == null) {
      setState(() => _step1Error = 'Please select your gender');
      _showSnackbar('Please select your gender');
      return false;
    }
    setState(() => _step1Error = null);
    return true;
  }

  bool _validateStep2() {
    if (_selectedObjective == null) {
      setState(() => _step2Error = 'Please select your primary objective');
      _showSnackbar('Please select your primary objective');
      return false;
    }
    setState(() => _step2Error = null);
    return true;
  }

  bool _validateStep3() {
    if (_selectedDiet == null) {
      setState(() => _step3Error = 'Please select your dietary protocol');
      _showSnackbar('Please select your dietary protocol');
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
    if (_age! < 12) {
      setState(() => _step4Error = 'Age must be at least 12 years');
      _showSnackbar('Age must be at least 12 years');
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

  bool _validateStep5() {
    // Height & Weight - always valid with defaults
    return true;
  }

  bool _validateStep6() {
    if (_selectedClassType == null) {
      setState(() => _step6Error = 'Please select your class type');
      _showSnackbar('Please select your class type');
      return false;
    }
    setState(() => _step6Error = null);
    return true;
  }

  bool _validateStep7() {
    if (_selectedTime == null) {
      setState(() => _step7Error = 'Please select your preferred time');
      _showSnackbar('Please select your preferred time');
      return false;
    }
    setState(() => _step7Error = null);
    return true;
  }

  bool _validateStep9() {
    if (_mobileController.text.trim().isEmpty) {
      setState(() => _step8Error = 'Please enter mobile number');
      _showSnackbar('Please enter mobile number');
      return false;
    }
    if (_mobileController.text.trim().length != 10) {
      setState(() => _step8Error = 'Please enter valid 10-digit mobile number');
      _showSnackbar('Please enter valid 10-digit mobile number');
      return false;
    }
    if (!_isValidMobile(_mobileController.text.trim())) {
      setState(() => _step8Error = 'Please enter a valid Indian mobile number');
      _showSnackbar('Please enter a valid Indian mobile number');
      return false;
    }
    setState(() => _step0Error = null);
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

  double _calculateBMI() {
    double heightInM = _height / 100;
    double bmi = _weight / (heightInM * heightInM);
    return bmi;
  }

  String _getBMICategory() {
    double bmi = _calculateBMI();
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal / Optimal';
    if (bmi < 30) return 'Overweight';
    return 'Needs Attention';
  }

  Future<void> _handleSubmit() async {
    if (!_validateCurrentStep()) return;

    if (!_validateStep0() ||
        !_validateStep1() ||
        !_validateStep2() ||
        !_validateStep3() ||
        !_validateStep4() ||
        !_validateStep6() ||
        !_validateStep7() ||
        !_validateStep9()) {
      _showSnackbar('Please complete all steps correctly');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final studentData = {
      'fullName': _firstNameController.text.trim(),
      'email': _emailController.text.trim(),
      'mobileNumber': _mobileController.text.trim(),
      'age': _age,
      'status': _selectedStatus,
      'gender': _selectedGender,
      'objective': _selectedObjective,
      'diet': _selectedDiet,
      'height': _height,
      'weight': _weight,
      'bmi': _calculateBMI(),
      'bmiCategory': _getBMICategory(),
      'classType': _selectedClassType,
      'preferredTime': _selectedTime?.format(context),
      'medicalInfo': _medicalInfoController.text.trim(),
      'onboardingCompleted': true,
      'onboardingStep': 10,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Get.to(
        () => OtpVerificationScreen(
          phoneNumber: _mobileController.text,
          role: "student",
          studentData: studentData,
        ),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.cyan),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.grey[900],
              hourMinuteTextColor: Colors.white,
              dialHandColor: Colors.cyan,
              dialBackgroundColor: Colors.grey[800],
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _clearStepError(7);
      });
    }
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
        borderRadius: BorderRadius.circular(20.r),
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
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: child,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 90.w,
          height: 90.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.cyan, Colors.deepPurple],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: ClipOval(
              child: Image.asset(
                "assets/images/splash_logo.png",
                fit: BoxFit.cover,
              ),
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
          'Let\'s Personalize Your Fitness Journey',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT BIOLOGICAL GENDER *',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: _genders.map((gender) {
            bool isSelected = _selectedGender == gender;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedGender = gender);
                  _clearStepError(1);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [Colors.cyan, Colors.cyan.shade700],
                          )
                        : LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(12.r),
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
                              blurRadius: 10.r,
                              spreadRadius: 2.r,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      gender,
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
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

  Widget _buildObjectiveSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRIMARY OBJECTIVES *',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        ..._objectives.map((objective) {
          bool isSelected = _selectedObjective == objective;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedObjective = objective);
              _clearStepError(2);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          Colors.cyan.withOpacity(0.2),
                          Colors.deepPurple.withOpacity(0.2),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.02),
                        ],
                      ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.cyan
                      : Colors.white.withOpacity(0.2),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? Colors.cyan : Colors.white54,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      objective,
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        _buildErrorWidget(_step2Error),
      ],
    );
  }

  Widget _buildDietarySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DIETARY PROTOCOL *',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 10.h,
          children: _diets.map((diet) {
            bool isSelected = _selectedDiet == diet;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDiet = diet;
                  _clearStepError(3);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            Colors.green.shade700,
                            Colors.green.shade900,
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.03),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.green
                        : Colors.white.withOpacity(0.2),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8.r,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  diet,
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
        _buildErrorWidget(_step3Error),
      ],
    );
  }

  // NEW: Age & Status Selection Step
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
              items: List.generate(89, (index) => index + 12).map((age) {
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
          'WORKING / STUDYING *',
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

  Widget _buildHeightWeightSlider() {
    double bmi = _calculateBMI();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PHYSICAL BIOMETRICS',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),

        Text(
          'HEIGHT: ${_height.toInt()} cm',
          style: GoogleFonts.poppins(
            color: Colors.cyan,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          value: _height,
          min: 100,
          max: 250,
          activeColor: Colors.cyan,
          inactiveColor: Colors.white24,
          divisions: 150,
          label: '${_height.toInt()} cm',
          onChanged: (value) {
            setState(() {
              _height = value;
            });
          },
        ),

        SizedBox(height: 10.h),

        Text(
          'WEIGHT: ${_weight.toInt()} kg',
          style: GoogleFonts.poppins(
            color: Colors.cyan,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          value: _weight,
          min: 30,
          max: 200,
          activeColor: Colors.cyan,
          inactiveColor: Colors.white24,
          divisions: 170,
          label: '${_weight.toInt()} kg',
          onChanged: (value) {
            setState(() {
              _weight = value;
            });
          },
        ),

        SizedBox(height: 20.h),

        Container(
          padding: EdgeInsets.all(15.w),
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
                'CURRENT BMI PROFILE',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 11.sp,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                bmi.toStringAsFixed(1),
                style: GoogleFonts.orbitron(
                  color: Colors.cyan,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getBMICategory(),
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13.sp,
                ),
              ),
              if (_getBMICategory() == 'Normal / Optimal')
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    'Optimal for student athlete',
                    style: GoogleFonts.poppins(
                      color: Colors.greenAccent,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT CLASS TYPE *',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        ..._classTypes.map((type) {
          bool isSelected = _selectedClassType == type;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedClassType = type);
              _clearStepError(6);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          Colors.cyan.withOpacity(0.2),
                          Colors.deepPurple.withOpacity(0.2),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.02),
                        ],
                      ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.cyan
                      : Colors.white.withOpacity(0.2),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Colors.cyan : Colors.white54,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      type,
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        _buildErrorWidget(_step6Error),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PREFERRED TRAINING TIME *',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.cyan, size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'Select your preferred time',
                  style: GoogleFonts.poppins(
                    color: _selectedTime != null
                        ? Colors.white
                        : Colors.white54,
                    fontSize: 14.sp,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white38,
                  size: 14.sp,
                ),
              ],
            ),
          ),
        ),
        _buildErrorWidget(_step7Error),
      ],
    );
  }

  Widget _buildMedicalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MEDICAL INFORMATION',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _medicalInfoController,
          maxLines: 3,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText:
                'Any allergies, injuries, or medical conditions?\n(Optional - Leave empty if none)',
            hintStyle: GoogleFonts.poppins(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
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
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.medical_information,
                color: Colors.redAccent,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'This information helps us customize your workout plan safely',
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MOBILE NUMBER *',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Text(
                    '+91',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(height: 20.h, width: 1.w, color: Colors.white24),
                ],
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
        _buildErrorWidget(_step8Error),
        SizedBox(height: 20.h),

        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: Colors.blueAccent,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'ENCRYPTED CONNECTION',
                    style: GoogleFonts.orbitron(
                      color: Colors.blueAccent,
                      fontSize: 10.sp,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Your security is our priority. We use military-grade encryption to protect your data.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
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
          ),
        ),
        if (label == 'FIRST NAME' && _step0Error != null)
          _buildErrorWidget(_step0Error),
      ],
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

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WELCOME!',
              style: GoogleFonts.orbitron(
                color: Colors.cyan,
                fontSize: 18.sp,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'V-AL is analyzing your biometric potential.\nLet\'s build your performance profile.',
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 24.h),
            _buildTextField(
              'FIRST NAME',
              'Enter your name',
              _firstNameController,
            ),
            SizedBox(height: 20.h),
            _buildTextField(
              'EMAIL',
              'student@example.com',
              _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        );
      case 1:
        return _buildGenderSelector();
      case 2:
        return _buildObjectiveSelector();
      case 3:
        return _buildDietarySelector();
      case 4:
        return _buildAgeStatusSelector(); // NEW: Age & Status step
      case 5:
        return _buildHeightWeightSlider();
      case 6:
        return _buildClassTypeSelector();
      case 7:
        return _buildTimePicker();
      case 8:
        return _buildMedicalInfo();
      case 9:
        return _buildMobileNumber();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 20.h),

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

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildGlassContainer(
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: _buildCurrentStepContent(),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: GestureDetector(
                            onTap: _previousStep,
                            child: Container(
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 48.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isLoading
                                  ? [Colors.grey, Colors.grey]
                                  : [Colors.cyan, Colors.deepPurple],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.3),
                                blurRadius: 12.r,
                                spreadRadius: 2.r,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : (_currentStep == _totalSteps - 1
                                      ? _handleSubmit
                                      : _nextStep),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: _isLoading
                                ? SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 22.sp,
                                  )
                                : Text(
                                    _currentStep == _totalSteps - 1
                                        ? 'START MY FITNESS JOURNEY'
                                        : 'NEXT',
                                    style: GoogleFonts.orbitron(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 11.sp,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Transform Your Fitness Journey',
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 10.sp,
                          letterSpacing: 1,
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
