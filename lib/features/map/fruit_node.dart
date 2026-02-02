import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../ui/theme/brand_colors.dart';
import '../../ui/theme/metrics.dart';

enum FruitNodeState {
  locked,   // 꽃봉오리 🌸
  active,   // 반짝이는 과일 ⭐
  completed // 익은 과일 🍎
}

enum FruitType {
  apple,   // 🍎 빨강 (Level 1-3)
  orange,  // 🍊 주황 (Level 4-6)
  lemon,   // 🍋 노랑 (Level 7-9)
  star,    // ⭐ 별 (Level 10+)
}

class FruitNode extends StatefulWidget {
  const FruitNode({
    super.key,
    required this.state,
    required this.label,
    required this.type,
    required this.onTap,
    this.size = 85.0,
  });

  final FruitNodeState state;
  final String label;
  final FruitType type;
  final VoidCallback onTap;
  final double size;

  @override
  State<FruitNode> createState() => _FruitNodeState();
}

class _FruitNodeState extends State<FruitNode> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _bounceController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for active nodes
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Particle sparkle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Bounce on tap
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Color _getFruitColor() {
    if (widget.state == FruitNodeState.locked) {
      return const Color(0xFFF8BBD0); // 연한 핑크 (꽃봉오리)
    }

    switch (widget.type) {
      case FruitType.apple:
        return widget.state == FruitNodeState.completed
            ? const Color(0xFFFF6B6B) // 빨강
            : AppColors.orangeFace; // 활성: 오렌지
      case FruitType.orange:
        return widget.state == FruitNodeState.completed
            ? const Color(0xFFFF9500)
            : AppColors.orangeFace;
      case FruitType.lemon:
        return widget.state == FruitNodeState.completed
            ? const Color(0xFFFFD93D)
            : AppColors.orangeFace;
      case FruitType.star:
        return widget.state == FruitNodeState.completed
            ? AppColors.yellowFace
            : AppColors.orangeFace;
    }
  }

  Color _getSecondaryColor() {
    if (widget.state == FruitNodeState.locked) {
      return const Color(0xFFF48FB1);
    }

    switch (widget.type) {
      case FruitType.apple:
        return const Color(0xFFFFD93D);
      case FruitType.orange:
        return const Color(0xFFFFB300);
      case FruitType.lemon:
        return const Color(0xFFFFF176);
      case FruitType.star:
        return const Color(0xFFFFE082);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.state == FruitNodeState.active;
    final baseSize = widget.size;
    final adjustedSize = isActive ? baseSize * 1.1 : baseSize;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _bounceController.forward();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _bounceController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _bounceController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _bounceController]),
        builder: (context, child) {
          final pulse = isActive ? (math.sin(_pulseController.value * math.pi * 2) * 0.05 + 1.0) : 1.0;
          final bounce = _bounceController.value;
          final scale = pulse * (1.0 - bounce * 0.1);

          final fruitColor = _getFruitColor();
          final baseColor = _getDarkerColor(fruitColor);

          return Transform.scale(
            scale: scale,
            child: SizedBox(
              width: adjustedSize,
              height: adjustedSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Particle glow for active nodes (now uses solid colored circles)
                  if (isActive)
                    AnimatedBuilder(
                      animation: _particleController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(adjustedSize, adjustedSize),
                          painter: _ParticlePainter(
                            progress: _particleController.value,
                            color: fruitColor,
                          ),
                        );
                      },
                    ),

                  // 3D BASE for the "Fruit toy"
                  Positioned(
                    bottom: adjustedSize * 0.05,
                    child: Container(
                      width: adjustedSize * 0.85,
                      height: adjustedSize * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: baseColor,
                      ),
                    ),
                  ),

                  // Main fruit body (Face)
                  Positioned(
                    top: 0,
                    child: Container(
                      width: adjustedSize * 0.85,
                      height: adjustedSize * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: fruitColor,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Solid Highlight shape (Toy-like)
                          Positioned(
                            top: adjustedSize * 0.12,
                            left: adjustedSize * 0.18,
                            child: Container(
                              width: adjustedSize * 0.22,
                              height: adjustedSize * 0.12,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(adjustedSize),
                              ),
                            ),
                          ),

                          // Icon/Label
                          Center(
                            child: _buildIcon(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Stem/Leaf decoration
                  if (widget.state != FruitNodeState.locked)
                    Positioned(
                      top: -adjustedSize * 0.05,
                      child: _buildStem(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.state == FruitNodeState.locked) {
      return Icon(
        Icons.lock_rounded,
        size: widget.size * 0.4,
        color: Colors.white.withOpacity(0.9),
      );
    }

    if (widget.state == FruitNodeState.completed) {
      return Icon(
        Icons.check_rounded,
        size: widget.size * 0.45,
        color: Colors.white,
      );
    }

    // Active: show label
    return Text(
      widget.label,
      style: TextStyle(
        fontSize: widget.size * 0.35,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    );
  }

  Widget _buildStem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Solid Stem
        Container(
          width: widget.size * 0.1,
          height: widget.size * 0.15,
          decoration: BoxDecoration(
            color: const Color(0xFF795548), // Solid Brown
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Solid Leaf
        Transform.translate(
          offset: Offset(widget.size * 0.08, -widget.size * 0.05),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: widget.size * 0.18,
              height: widget.size * 0.1,
              decoration: BoxDecoration(
                color: AppColors.successFace, // Solid Green
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(widget.size),
                  bottomLeft: Radius.circular(widget.size),
                  bottomRight: Radius.circular(widget.size * 0.2),
                  topLeft: Radius.circular(widget.size * 0.2),
                ),
                border: Border.all(color: Colors.black.withOpacity(0.05), width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getDarkerColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.52;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3) + (progress * 2 * math.pi);
      final distance = radius + (math.sin(progress * 2 * math.pi + i) * 8);
      
      final x = centerX + math.cos(angle) * distance;
      final y = centerY + math.sin(angle) * distance;
      
      final opacity = (math.sin(progress * 2 * math.pi + i) + 1) / 2;
      
      paint.color = color.withOpacity(opacity * 0.7);
      // Small solid squares for "pixel art/toy" feel
      canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: 5, height: 5), paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
