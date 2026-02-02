import 'package:flutter/material.dart';
import '../../ui/theme/brand_colors.dart';
import '../../ui/theme/metrics.dart';
import 'dart:math' as math;

class SkipJumpButton extends StatefulWidget {
  const SkipJumpButton({
    super.key,
    required this.onTap,
    this.text = "여기로 건너뛸까요?",
  });

  final VoidCallback onTap;
  final String text;

  @override
  State<SkipJumpButton> createState() => _SkipJumpButtonState();
}

class _SkipJumpButtonState extends State<SkipJumpButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _depthAnimation;

  @override
  void initState() {
    super.initState();
     // Fast press, Bouncy release
    _controller = AnimationController(
        vsync: this, 
        duration: const Duration(milliseconds: 70),
        reverseDuration: const Duration(milliseconds: 600)
    );
    _depthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    // Elastic Pop Visual
    _controller.animateBack(0.0, curve: Curves.elasticOut).then((_) => widget.onTap());
  }

  void _handleTapCancel() {
    _controller.animateBack(0.0, curve: Curves.elasticOut);
  }

  @override
  Widget build(BuildContext context) {
    const double size = 72.0;
    const double maxDepth = 6.0;
    const double scaleY = 0.95; // Stood up perspective

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Tooltip Speech Bubble
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.tooltipDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: -0.2,
            ),
          ),
        ),
        
        // 2. Speech Bubble Triangle
        CustomPaint(
          size: const Size(20, 10),
          painter: _TrianglePainter(color: AppColors.tooltipDark),
        ),
        
        const SizedBox(height: 8),

        // 3. 3D Circular Button
        GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SizedBox(
                width: size + 10,
                height: (size * scaleY) + maxDepth + 10,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                // TILT TRANSFORM (Isometric Lying Down)
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) 
                    ..rotateX(-0.5),        
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // 1. Shadow (Soft Ambient)
                      Positioned(
                        top: maxDepth + 8,
                        child: Transform(
                          transform: Matrix4.identity()..scale(1.0, scaleY),
                          alignment: Alignment.center,
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 12,
                                  offset: Offset(0, 8),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 2. 3D SIDE (The Block Body)
                      Positioned(
                        top: maxDepth,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..scale(1.0, scaleY),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: AppColors.foxOrange, // Deep Side
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.foxBrown,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 3. FACE (The Clickable Top)
                      Positioned(
                        top: _depthAnimation.value * maxDepth,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..scale(1.0, scaleY),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: AppColors.foxCream, // Cream Top
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white, 
                                width: 3.0, 
                              ),
                            ),
                            child: Stack(
                              children: [
                                 // TEXTURE VARIETY PACK (Index based)
                                 // Keeping Fur for SkipJumpButton specifically as requested
                                 Positioned.fill(
                                   child: CustomPaint(
                                     painter: _FurPatternPainter(
                                       color: AppColors.foxOrange.withOpacity(0.35),
                                     ),
                                   ),
                                 ),

                                 // COMIC GLOSS
                                 Positioned(
                                   top: 6,
                                   left: 8,
                                   child: Container(
                                     width: size * 0.35,
                                     height: size * 0.2,
                                     decoration: BoxDecoration(
                                       color: Colors.white, 
                                       borderRadius: const BorderRadius.all(Radius.elliptical(20, 10)),
                                     ),
                                   ),
                                 ),
                                 
                                 // SPARKLE
                                 const Positioned(
                                   bottom: 8,
                                   right: 8,
                                   child: Icon(
                                     Icons.auto_awesome, 
                                     color: AppColors.foxOrange,
                                     size: 16,
                                   ),
                                 ),

                                 // CONTENT (Icon)
                                 Center(
                                   child: Padding(
                                     padding: const EdgeInsets.only(bottom: 0),
                                     child: const Icon(
                                       Icons.play_arrow_rounded, 
                                       color: AppColors.foxBrown, 
                                       size: 40,
                                     ),
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ], // Stack children
            ), // Stack
          ); // SizedBox
        }, // Builder
      ), // AnimatedBuilder
    ), // GestureDetector
    const SizedBox(height: 8),
    ], // Column children
    ); // Column
  }
}

class _FurPatternPainter extends CustomPainter {
  final Color color;
  _FurPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Stylized "Tufts"
    _drawTuft(canvas, paint, w * 0.2, h * 0.35);
    _drawTuft(canvas, paint, w * 0.75, h * 0.25);
    _drawTuft(canvas, paint, w * 0.35, h * 0.65);
    _drawTuft(canvas, paint, w * 0.82, h * 0.55);
    _drawTuft(canvas, paint, w * 0.15, h * 0.75);
    _drawTuft(canvas, paint, w * 0.6, h * 0.82);
  }

  void _drawTuft(Canvas canvas, Paint paint, double x, double y) {
    final path = Path();
    path.moveTo(x, y);
    path.quadraticBezierTo(x + 2, y - 2, x + 5, y + 1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
