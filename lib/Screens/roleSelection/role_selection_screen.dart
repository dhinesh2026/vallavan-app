import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vallavanapp/Screens/logins/student_login_screen.dart';
import 'package:vallavanapp/Screens/logins/trainer_login_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Colour Palette
// ─────────────────────────────────────────────────────────────────────────────
class _Palette {
  static const bg = Color(0xFF080C18);
  static const cyan = Color(0xFF00E5FF);
  static const purple = Color(0xFFAA44FF);
  static const cyanDim = Color(0xFF003D46);
  static const purpleDim = Color(0xFF2A0050);
  static const white = Colors.white;
  static const white38 = Colors.white38;
}

// ─────────────────────────────────────────────────────────────────────────────
// Role Selection Screen
// ─────────────────────────────────────────────────────────────────────────────
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────
  String? _selectedRole;

  // ── Controllers ──────────────────────────────────────────────────────────
  late final AnimationController _bgGlowCtrl;
  late final AnimationController _entryCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _particleCtrl;

  // ── Animations ───────────────────────────────────────────────────────────
  late final Animation<double> _bgGlow;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;
  late final Animation<double> _pulse;
  late final Animation<double> _particleAnim;

  @override
  void initState() {
    super.initState();

    _bgGlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _bgGlow = CurvedAnimation(parent: _bgGlowCtrl, curve: Curves.easeInOut);

    _fadeIn = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideIn = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    _pulse = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _particleAnim = CurvedAnimation(
      parent: _particleCtrl,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _bgGlowCtrl.dispose();
    _entryCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    HapticFeedback.lightImpact();
    setState(() => _selectedRole = role);
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.bg,
      body: Stack(
        children: [
          // ── Layer 0 : animated background ──────────────────────────────
          _AnimatedBackground(glowAnim: _bgGlow, particleAnim: _particleAnim),
          // ── Layer 1 : main UI ──────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Column(
                    children: [
                      SizedBox(height: 28.h),
                      _Logo(pulse: _pulse, glowAnim: _bgGlow),
                      SizedBox(height: 30.h),
                      _buildSectionHeader(),
                      SizedBox(height: 26.h),
                      _RoleCard(
                        role: 'student',
                        selected: _selectedRole == 'student',
                        title: 'Student',
                        subtitle:
                            'Track workouts, join live classes,\ntransform your health.',
                        accentColor: _Palette.cyan,
                        dimColor: _Palette.cyanDim,
                        iconData: Icons.fitness_center_rounded,
                        features: const [
                          _FeatureTag(
                            icon: Icons.track_changes_rounded,
                            label: 'AI Tracking',
                          ),
                          _FeatureTag(
                            icon: Icons.restaurant_menu_rounded,
                            label: 'Nutrition',
                          ),
                          _FeatureTag(
                            icon: Icons.trending_up_rounded,
                            label: 'Progress',
                          ),
                        ],
                        previewWidgets: [
                          _PreviewTile(color: _Palette.cyan),
                          _PreviewTile(color: _Palette.cyan, showRing: true),
                          _PreviewTile(color: _Palette.cyan),
                        ],
                        onTap: () => _selectRole('student'),
                      ),
                      SizedBox(height: 14.h),
                      _RoleCard(
                        role: 'trainer',
                        selected: _selectedRole == 'trainer',
                        title: 'Trainer',
                        subtitle:
                            'Create workouts, host live sessions,\nmanage students.',
                        accentColor: _Palette.purple,
                        dimColor: _Palette.purpleDim,
                        iconData: Icons.videocam_rounded,
                        features: const [
                          _FeatureTag(
                            icon: Icons.live_tv_rounded,
                            label: 'Live Stream',
                          ),
                          _FeatureTag(
                            icon: Icons.bar_chart_rounded,
                            label: 'Analytics',
                          ),
                          _FeatureTag(
                            icon: Icons.monetization_on_rounded,
                            label: 'Revenue',
                          ),
                        ],
                        previewWidgets: [
                          _PreviewTile(
                            color: _Palette.purple,
                            isDashboard: true,
                          ),
                          _PreviewTile(color: _Palette.purple),
                          _PreviewTile(color: _Palette.purple),
                        ],
                        onTap: () => _selectRole('trainer'),
                      ),
                      SizedBox(height: 18.h),
                      _buildComparisonRow(),
                      SizedBox(height: 18.h),
                      _AIBanner(glowAnim: _bgGlow),
                      SizedBox(height: 22.h),
                      _ContinueButton(
                        enabled: _selectedRole != null,
                        selectedRole: _selectedRole,
                      ),
                      SizedBox(height: 14.h),
                      _buildFooter(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      children: [
        Text(
          'Choose Your Experience',
          style: GoogleFonts.sora(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: _Palette.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Continue as a Student or Professional Trainer',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: _Palette.white38,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildComparisonRow() {
    return Row(
      children: [
        Expanded(
          child: _ComparisonChip(
            icon: Icons.group_rounded,
            label: 'Join vs Host',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ComparisonChip(
            icon: Icons.show_chart_rounded,
            label: 'Track vs Manage',
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final style = GoogleFonts.inter(fontSize: 11.sp, color: _Palette.white38);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Privacy Policy', style: style),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text('•', style: style.copyWith(color: Colors.white24)),
        ),
        Text('Terms of Service', style: style),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text('•', style: style.copyWith(color: Colors.white24)),
        ),
        Text('AI Ethics', style: style),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated Background
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedBackground extends StatelessWidget {
  final Animation<double> glowAnim;
  final Animation<double> particleAnim;

  const _AnimatedBackground({
    required this.glowAnim,
    required this.particleAnim,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowAnim, particleAnim]),
      builder: (_, __) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Base gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF08091A),
                      Color(0xFF0C1120),
                      Color(0xFF080C18),
                    ],
                  ),
                ),
              ),
              // Cyan top-left blob
              Positioned(
                top: -120.h,
                left: -100.w,
                child: _GlowBlob(
                  size: 360.w,
                  color: _Palette.cyan,
                  opacity: 0.10 + 0.06 * glowAnim.value,
                ),
              ),
              // Purple bottom-right blob
              Positioned(
                bottom: 0,
                right: -120.w,
                child: _GlowBlob(
                  size: 380.w,
                  color: _Palette.purple,
                  opacity: 0.08 + 0.05 * glowAnim.value,
                ),
              ),
              // Particles
              CustomPaint(
                size: Size(1.sw, 1.sh),
                painter: _ParticlePainter(progress: particleAnim.value),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowBlob({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(opacity), Colors.transparent],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Particle Painter
// ─────────────────────────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final _rng = math.Random(12345);
  static late final List<_Particle> _particles = List.generate(
    55,
    (_) => _Particle(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      size: _rng.nextDouble() * 1.6 + 0.4,
      speed: _rng.nextDouble() * 0.004 + 0.001,
      opacity: _rng.nextDouble() * 0.5 + 0.15,
    ),
  );

  _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final y = (p.y - progress * p.speed) % 1.0;
      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);
      canvas.drawCircle(
        Offset(p.x * size.width, y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, size, speed, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo
// ─────────────────────────────────────────────────────────────────────────────
class _Logo extends StatelessWidget {
  final Animation<double> pulse;
  final Animation<double> glowAnim;

  const _Logo({required this.pulse, required this.glowAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([pulse, glowAnim]),
      builder: (_, __) => Column(
        children: [
          // ── Icon Badge ────────────────────────────────────────────────
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_Palette.cyan, _Palette.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _Palette.cyan.withOpacity(0.45 * pulse.value),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: _Palette.purple.withOpacity(0.25 * pulse.value),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // inner shimmer ring
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2 * glowAnim.value),
                      width: 1,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.45),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/images/splash_logo.png",
                    width: 110.w,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          // ── App Name ──────────────────────────────────────────────────
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [_Palette.cyan, _Palette.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              'VallavanFitness',
              style: GoogleFonts.orbitron(
                fontSize: 23.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'TRANSFORM YOUR FITNESS JOURNEY',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              color: Colors.white30,
              letterSpacing: 2.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Role Card
// ─────────────────────────────────────────────────────────────────────────────
class _RoleCard extends StatefulWidget {
  final String role;
  final bool selected;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color dimColor;
  final IconData iconData;
  final List<_FeatureTag> features;
  final List<_PreviewTile> previewWidgets;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.dimColor,
    required this.iconData,
    required this.features,
    required this.previewWidgets,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.975,
    ).animate(CurvedAnimation(parent: _tapCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _tapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _tapCtrl.forward(),
      onTapUp: (_) {
        _tapCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _tapCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: widget.selected
                  ? widget.accentColor.withOpacity(0.7)
                  : Colors.white.withOpacity(0.07),
              width: widget.selected ? 1.5 : 1.0,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.selected
                  ? [
                      widget.accentColor.withOpacity(0.10),
                      widget.dimColor.withOpacity(0.12),
                      Colors.white.withOpacity(0.02),
                    ]
                  : [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.02),
                    ],
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(0.18),
                      blurRadius: 30,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header Row ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _IconBadge(
                        icon: widget.iconData,
                        color: widget.accentColor,
                      ),
                      _SelectionCheck(
                        selected: widget.selected,
                        color: widget.accentColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  // ── Title ─────────────────────────────────────────
                  Text(
                    widget.title,
                    style: GoogleFonts.sora(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: widget.accentColor,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // ── Subtitle ──────────────────────────────────────
                  Text(
                    widget.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.white54,
                      height: 1.55,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  // ── Feature Tags ──────────────────────────────────
                  Wrap(spacing: 14.w, children: widget.features),
                  SizedBox(height: 16.h),
                  // ── Preview Strip ─────────────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                      height: 74.h,
                      child: Row(
                        children: widget.previewWidgets
                            .expand(
                              (w) => [
                                Expanded(child: w),
                                if (w != widget.previewWidgets.last)
                                  Container(
                                    width: 1,
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                              ],
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Role Card Sub-Widgets
// ─────────────────────────────────────────────────────────────────────────────
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.w,
      height: 46.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.r),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.20), color.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.30), width: 1),
      ),
      child: Icon(icon, color: color, size: 22.sp),
    );
  }
}

class _SelectionCheck extends StatelessWidget {
  final bool selected;
  final Color color;

  const _SelectionCheck({required this.selected, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? color.withOpacity(0.20) : Colors.transparent,
        border: Border.all(
          color: selected ? color : Colors.white24,
          width: 1.5,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selected
            ? Icon(
                Icons.check_rounded,
                key: const ValueKey(true),
                color: color,
                size: 14.sp,
              )
            : const SizedBox.shrink(key: ValueKey(false)),
      ),
    );
  }
}

class _FeatureTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white30, size: 12.sp),
        SizedBox(width: 4.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: Colors.white38,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PreviewTile extends StatelessWidget {
  final Color color;
  final bool showRing;
  final bool isDashboard;

  const _PreviewTile({
    required this.color,
    this.showRing = false,
    this.isDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.06), Colors.black.withOpacity(0.35)],
        ),
      ),
      child: Center(
        child: isDashboard
            ? _buildDashboardPreview()
            : showRing
            ? _buildRingPreview()
            : _buildBarsPreview(),
      ),
    );
  }

  Widget _buildRingPreview() {
    return SizedBox(
      width: 36.w,
      height: 36.w,
      child: CircularProgressIndicator(
        value: 0.72,
        strokeWidth: 3.5,
        backgroundColor: color.withOpacity(0.15),
        valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(0.65)),
      ),
    );
  }

  Widget _buildBarsPreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [3, 5, 4, 6, 3].map((h) {
        return Container(
          width: 5.w,
          height: (h * 6).toDouble().h,
          margin: EdgeInsets.symmetric(horizontal: 1.5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r),
            color: color.withOpacity(0.45),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDashboardPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50.w,
          height: 4.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r),
            color: color.withOpacity(0.35),
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          width: 38.w,
          height: 3.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r),
            color: color.withOpacity(0.20),
          ),
        ),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [2, 4, 3, 5].map((h) {
            return Container(
              width: 6.w,
              height: (h * 4).toDouble().h,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.5.r),
                color: color.withOpacity(0.40),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Comparison Chip
// ─────────────────────────────────────────────────────────────────────────────
class _ComparisonChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ComparisonChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.07), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white38, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AI Banner
// ─────────────────────────────────────────────────────────────────────────────
class _AIBanner extends StatelessWidget {
  final Animation<double> glowAnim;

  const _AIBanner({required this.glowAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, __) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: [
              _Palette.cyan.withOpacity(0.07),
              _Palette.purple.withOpacity(0.07),
            ],
          ),
          border: Border.all(
            color: _Palette.cyan.withOpacity(0.15 + 0.12 * glowAnim.value),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [_Palette.cyan, _Palette.purple],
              ).createShader(b),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 17.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'POWERED BY AI',
                  style: GoogleFonts.inter(
                    fontSize: 9.5.sp,
                    color: _Palette.cyan,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
                ),
                Text(
                  'Fitness Intelligence',
                  style: GoogleFonts.sora(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _Palette.cyan.withOpacity(0.10),
                border: Border.all(color: _Palette.cyan.withOpacity(0.25)),
              ),
              child: Icon(
                Icons.memory_rounded,
                color: _Palette.cyan,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Continue Button
// ─────────────────────────────────────────────────────────────────────────────
class _ContinueButton extends StatefulWidget {
  final bool enabled;
  final String? selectedRole;

  const _ContinueButton({required this.enabled, required this.selectedRole});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _ctrl.forward() : null,
      onTapUp: widget.enabled
          ? (_) {
              _ctrl.reverse();
              HapticFeedback.mediumImpact();

              if (widget.selectedRole == 'student') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentOnboardingScreen(),
                  ),
                );
              } else if (widget.selectedRole == 'trainer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainerOnboardingScreen(),
                  ),
                );
              }
            }
          : null,
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          height: 54.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            gradient: widget.enabled
                ? const LinearGradient(
                    colors: [Color(0xFF00C8E8), Color(0xFF9B35D8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.07),
                      Colors.white.withOpacity(0.04),
                    ],
                  ),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: _Palette.cyan.withOpacity(0.30),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: _Palette.purple.withOpacity(0.20),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              'Continue',
              style: GoogleFonts.sora(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: widget.enabled ? Colors.white : Colors.white24,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
