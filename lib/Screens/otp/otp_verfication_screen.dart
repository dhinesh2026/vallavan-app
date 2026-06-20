import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:vallavanapp/Screens/authService/auth_service.dart';
import 'package:vallavanapp/Screens/homePage/student_home_screen.dart';
import 'package:vallavanapp/Screens/homePage/trainer_home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String role;
  final Map<String, dynamic>? trainerData;
  final Map<String, dynamic>? studentData;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.role,
    this.trainerData,
    this.studentData,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  int _resendTimer = 30;
  Timer? _timer;
  bool _isLoading = false;
  
  final AuthService _authService = AuthService();

  // Helper method to get user name based on role
  String get _userName {
    if (widget.role.toLowerCase() == 'trainer' && widget.trainerData != null) {
      return widget.trainerData!['fullName'] ?? 'Trainer';
    } else if (widget.role.toLowerCase() == 'student' && widget.studentData != null) {
      return widget.studentData!['firstName'] ?? 'Student';
    }
    return widget.role.toUpperCase();
  }

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
    _startResendTimer();
    _sendOtpOnLoad();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _sendOtpOnLoad() async {
    final result = await _authService.sendOtp(widget.phoneNumber, widget.role);
    
    if (!result['success']) {
      _showSnackbar(result['message'] ?? 'Failed to send OTP');
    } else {
      _showSnackbar('OTP sent successfully!');
    }
  }

  Future<void> _resendOtp() async {
    if (_resendTimer == 0) {
      setState(() {
        _startResendTimer();
      });
      
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _otpFocusNodes[0].requestFocus();
      
      final result = await _authService.sendOtp(widget.phoneNumber, widget.role);
      
      if (result['success']) {
        _showSnackbar('OTP resent successfully!');
      } else {
        _showSnackbar(result['message'] ?? 'Failed to resend OTP');
      }
    }
  }

  String get _enteredOtp {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length != 6) {
      _showSnackbar('Please enter complete 6-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> requestData = {
      'phoneNumber': widget.phoneNumber,
      'otp': _enteredOtp,
      'role': widget.role,
    };
    
    if (widget.role.toLowerCase() == 'trainer' && widget.trainerData != null) {
      requestData['trainerData'] = widget.trainerData;
    }
    
    if (widget.role.toLowerCase() == 'student' && widget.studentData != null) {
      requestData['studentData'] = widget.studentData;
    }

    final result = await _authService.verifyOtp(
      widget.phoneNumber,
      _enteredOtp,
      widget.role,
      userData: widget.role.toLowerCase() == 'trainer' ? widget.trainerData : widget.studentData,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      _showSuccessDialog();
    } else {
      _showSnackbar(result['message'] ?? 'Invalid OTP. Please try again.');
    }
  }

  void _navigateToHomeScreen() {
    if (widget.role.toLowerCase() == 'student') {
      // Pass student name to home screen
      Get.offAll(
        () => StudentHomeScreen(userName: _userName),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 500),
      );
    } else if (widget.role.toLowerCase() == 'trainer') {
      // Pass trainer name to home screen
      Get.offAll(
        () => TrainerHomeScreen(userName: _userName),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: Colors.cyan, width: 1),
        ),
        title: Row(
          children: [
            Icon(Icons.verified, color: Colors.greenAccent, size: 30.sp),
            SizedBox(width: 10.w),
            Text('Welcome $_userName!', 
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16.sp),
            ),
          ],
        ),
        content: Text(
          'Mobile number verified successfully!\n\n'
          'Welcome to VallavanPro as ${widget.role.toUpperCase()}!',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToHomeScreen();
            },
            child: Text(
              'Continue',
              style: GoogleFonts.orbitron(color: Colors.cyan),
            ),
          ),
        ],
      ),
    );
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

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
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
        borderRadius: BorderRadius.circular(30.r),
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
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: child,
        ),
      ),
    );
  }

  String _maskMobileNumber() {
    String mobile = widget.phoneNumber;
    if (mobile.length == 10) {
      return '+91 ${mobile.substring(0, 5)}••••${mobile.substring(8)}';
    }
    return '+91 ${widget.phoneNumber}';
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 70.w,
          height: 70.w,
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
  padding: EdgeInsets.all(8.w),
  child: Image.asset(
    "assets/images/splash_logo.png",
    fit: BoxFit.contain,
  ),
),
        ),
        SizedBox(height: 12.h),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.cyan, Colors.cyanAccent],
          ).createShader(bounds),
          child: Text(
            'VALLAVAN PRO',
            style: GoogleFonts.orbitron(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    _buildLogo(),

                    SizedBox(height: 25.h),

                    _buildGlassContainer(
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'VERIFY YOUR NUMBER',
                                style: GoogleFonts.orbitron(
                                  color: Colors.cyan,
                                  fontSize: 14.sp,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(height: 15.h),

                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.cyan.withOpacity(0.2),
                                      Colors.deepPurple.withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: Colors.cyan.withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  'Signing in as ${widget.role.toUpperCase()}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.cyan,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 15.h),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _maskMobileNumber(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Text(
                                      'Edit',
                                      style: GoogleFonts.poppins(
                                        color: Colors.cyan,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  width: 42.w,
                                  height: 50.h,
                                  child: TextFormField(
                                    controller: _otpControllers[index],
                                    focusNode: _otpFocusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: const BorderSide(
                                          color: Colors.cyan,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) =>
                                        _onOtpChanged(index, value),
                                  ),
                                );
                              }),
                            ),

                            SizedBox(height: 20.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Resend OTP in ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white54,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  '${_resendTimer.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.cyan,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' sec',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white54,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                if (_resendTimer == 0) ...[
                                  SizedBox(width: 8.w),
                                  GestureDetector(
                                    onTap: _resendOtp,
                                    child: Text(
                                      'Resend OTP',
                                      style: GoogleFonts.poppins(
                                        color: Colors.cyan,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            SizedBox(height: 20.h),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 48.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isLoading
                                      ? [Colors.grey, Colors.grey]
                                      : [Colors.cyan, Colors.deepPurple],
                                ),
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
                                onPressed: _isLoading ? null : _verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                child: _isLoading
                                    ? SpinKitFadingCircle(
                                        color: Colors.white,
                                        size: 22.sp,
                                      )
                                    : Text(
                                        'VERIFY & CONTINUE',
                                        style: GoogleFonts.orbitron(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                              ),
                            ),

                            SizedBox(height: 15.h),

                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lock_outline,
                                        color: Colors.blueAccent,
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'ENCRYPTED CONNECTION',
                                        style: GoogleFonts.orbitron(
                                          color: Colors.blueAccent,
                                          fontSize: 9.sp,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Your security is our priority. We use military-grade encryption.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white60,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
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