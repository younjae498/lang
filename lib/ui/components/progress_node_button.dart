import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:la/ui/theme/brand_colors.dart';

enum ProgressNodeStyle {
  classic3D,
  glassmorphic,
  neumorphic,
  floatingIsland,
  woody3D,
  fantasyGlow,
}

enum NodeShape {
  circle,
  roundedSquare,
  capsule,
}

enum ProgressNodeStatus {
  locked,
  available,
  completed,
}

class ProgressNodeButton extends StatefulWidget {
  final double progress;
  final IconData? icon;
  final String? text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? baseColor;
  final double size;
  final double? width;
  final String? label;
  final ProgressNodeStyle style;
  final NodeShape shape;
  final bool hasShine;
  final ProgressNodeStatus status;

  const ProgressNodeButton({
    super.key,
    this.progress = 0.0,
    this.icon,
    this.text,
    required this.onPressed,
    this.color,
    this.baseColor,
    this.size = 80,
    this.width,
    this.label,
    this.style = ProgressNodeStyle.classic3D,
    this.shape = NodeShape.circle,
    this.hasShine = true,
    this.status = ProgressNodeStatus.available,
  });

  @override
  State<ProgressNodeButton> createState() => _ProgressNodeButtonState();
}

class _ProgressNodeButtonState extends State<ProgressNodeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _squishAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _squishAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = widget.status == ProgressNodeStatus.locked;
    
    return GestureDetector(
      onTapDown: (_) => isLocked ? null : _controller.forward(),
      onTapUp: (_) {
        if (isLocked) return;
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => isLocked ? null : _controller.reverse(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scaleX: _scaleAnimation.value,
                scaleY: _scaleAnimation.value * (1.0 + (1.0 - _squishAnimation.value) * 0.5),
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Progress Ring
                if (widget.progress > 0 && widget.shape == NodeShape.circle && !isLocked)
                  SizedBox(
                    width: widget.size + 16,
                    height: widget.size + 16,
                    child: CustomPaint(
                      painter: _ProgressPainter(
                        progress: widget.progress,
                        color: _getProgressColor(),
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                // Button Body
                _buildButtonStyle(),
              ],
            ),
          ),
          if (widget.label != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.label!.toUpperCase(),
              style: TextStyle(
                color: isLocked ? Colors.white30 : Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.2,
                shadows: isLocked ? null : const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getProgressColor() {
    if (widget.status == ProgressNodeStatus.completed) return AppColors.energyFace;
    
    switch (widget.style) {
      case ProgressNodeStyle.glassmorphic:
        return Colors.white;
      case ProgressNodeStyle.fantasyGlow:
        return const Color(0xFF00E5FF);
      default:
        return widget.color ?? AppColors.duoGreen;
    }
  }

  Widget _buildButtonStyle() {
    final double buttonWidth = widget.width ?? widget.size;
    final double buttonHeight = widget.size;
    final bool isLocked = widget.status == ProgressNodeStatus.locked;
    final bool isCompleted = widget.status == ProgressNodeStatus.completed;

    Color effectiveFaceColor = widget.color ?? (widget.style == ProgressNodeStyle.fantasyGlow ? const Color(0xFF1A237E) : AppColors.duoBlue);
    
    if (isLocked) {
      effectiveFaceColor = const Color(0xFFE0E0E0);
    } else if (isCompleted) {
      effectiveFaceColor = AppColors.energyFace;
    }

    final Color effectiveBaseColor = widget.baseColor ?? effectiveFaceColor.withRed((effectiveFaceColor.red * 0.7).toInt()).withGreen((effectiveFaceColor.green * 0.7).toInt()).withBlue((effectiveFaceColor.blue * 0.7).toInt());

    switch (widget.style) {
      case ProgressNodeStyle.fantasyGlow:
        return Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            shape: widget.shape == NodeShape.circle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.shape == NodeShape.circle ? null : _getBorderRadius(buttonHeight),
            boxShadow: isLocked ? null : [
              BoxShadow(color: effectiveFaceColor.withOpacity(0.5), blurRadius: 20, spreadRadius: 2),
              BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 5, spreadRadius: 1),
            ],
            border: Border.all(color: isLocked ? Colors.transparent : Colors.white.withOpacity(0.5), width: 2),
            gradient: RadialGradient(
              colors: [
                effectiveFaceColor.withOpacity(0.6),
                effectiveFaceColor,
              ],
            ),
          ),
          child: Center(child: _buildContent()),
        );

      case ProgressNodeStyle.woody3D:
        final Color woodyBase = isLocked ? const Color(0xFFBDBDBD) : const Color(0xFF8D5B28);
        final Color woodyDarkBase = isLocked ? const Color(0xFF9E9E9E) : const Color(0xFF5D3A1A);
        
        return Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: _getShapeDecoration(woodyDarkBase, isBase: true),
          child: Stack(
            children: [
              // Bottom Shadow/Depth
              Positioned(
                bottom: 0,
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight - 8,
                  decoration: _getShapeDecoration(woodyBase),
                ),
              ),
              // Top Surface
              Positioned(
                top: 0,
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight - 12,
                  decoration: _getShapeDecoration(effectiveFaceColor, hasGradient: true),
                  child: Stack(
                    children: [
                      if (widget.hasShine && !isLocked) _buildShineOverlay(buttonWidth, buttonHeight - 12),
                      Center(child: _buildContent()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case ProgressNodeStyle.glassmorphic:
        if (isLocked) {
          // Fallback design for locked glass nodes
          return Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              shape: widget.shape == NodeShape.circle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: widget.shape == NodeShape.circle ? null : _getBorderRadius(buttonHeight),
              color: Colors.white12,
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Center(child: _buildContent()),
          );
        }
        return ClipPath(
          clipper: _ShapeClipper(widget.shape),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                shape: widget.shape == NodeShape.circle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: widget.shape == NodeShape.circle ? null : _getBorderRadius(buttonHeight),
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
              ),
              child: Center(
                child: _buildContent(),
              ),
            ),
          ),
        );

      default:
        // Default to classic 3D for simple implementations or fallback
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: _getShapeDecoration(effectiveBaseColor, isBase: true),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: buttonWidth,
                height: buttonHeight - 8,
                decoration: _getShapeDecoration(effectiveFaceColor, hasGradient: true),
                child: Stack(
                  children: [
                    if (widget.hasShine && !isLocked) _buildShineOverlay(buttonWidth, buttonHeight - 8),
                    Center(child: _buildContent()),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildShineOverlay(double width, double height) {
    return Positioned(
      top: 2,
      left: 4,
      right: 4,
      child: Container(
        height: height * 0.35,
        decoration: BoxDecoration(
          borderRadius: widget.shape == NodeShape.circle 
              ? BorderRadius.all(Radius.circular(width)) 
              : _getBorderRadius(height),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final bool isLocked = widget.status == ProgressNodeStatus.locked;
    final bool isCompleted = widget.status == ProgressNodeStatus.completed;

    if (isLocked) {
      return Icon(Icons.lock_rounded, color: Colors.black26, size: widget.size * 0.4);
    }
    
    if (isCompleted) {
      return Icon(Icons.check_rounded, color: Colors.white, size: widget.size * 0.5);
    }

    if (widget.icon != null) {
      return Icon(
        widget.icon, 
        color: Colors.white.withOpacity(0.95), 
        size: widget.size * 0.45,
        shadows: [
          Shadow(color: Colors.black.withOpacity(0.3), offset: const Offset(0, 2), blurRadius: 4),
        ],
      );
    } else if (widget.text != null) {
      return Text(
        widget.text!,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: widget.size * 0.28,
          letterSpacing: 1.5,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.4), offset: const Offset(0, 3), blurRadius: 6),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  BorderRadius _getBorderRadius(double height) {
    if (widget.shape == NodeShape.capsule) return BorderRadius.circular(height / 2);
    return BorderRadius.circular(16);
  }

  Decoration _getShapeDecoration(Color color, {bool hasGradient = false, bool isBase = false}) {
    return BoxDecoration(
      color: hasGradient ? null : color,
      shape: widget.shape == NodeShape.circle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: widget.shape == NodeShape.circle ? null : _getBorderRadius(widget.size),
      gradient: hasGradient ? LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withBlue((color.blue + 30).clamp(0, 255)).withGreen((color.green + 30).clamp(0, 255)).withRed((color.red + 30).clamp(0, 255)),
          color,
        ],
      ) : null,
      boxShadow: isBase ? [
        BoxShadow(
          color: Colors.black.withOpacity(widget.status == ProgressNodeStatus.locked ? 0.2 : 0.5),
          offset: const Offset(0, 4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ] : null,
    );
  }
}

class _ShapeClipper extends CustomClipper<Path> {
  final NodeShape shape;
  _ShapeClipper(this.shape);

  @override
  Path getClip(Size size) {
    final path = Path();
    if (shape == NodeShape.circle) {
      path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    } else if (shape == NodeShape.capsule) {
      path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(size.height / 2)));
    } else {
      path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)));
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 8.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1.0);

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
