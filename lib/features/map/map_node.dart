import 'package:flutter/material.dart';
import 'dart:math' as math;

enum NodeState { locked, active, completed }

class MapNodeWidget extends StatefulWidget {
  const MapNodeWidget({
    super.key,
    required this.label,
    required this.state,
    required this.onTap,
    this.baseSize = 90.0,
  });

  final String label;
  final NodeState state;
  final VoidCallback onTap;
  final double baseSize;

  @override
  State<MapNodeWidget> createState() => _MapNodeWidgetState();
}

class _MapNodeWidgetState extends State<MapNodeWidget> with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _idleController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    
    // Idle "attraction" tilt for active nodes
    _idleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Pulse animation for active nodes (glow effect)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Shimmer/particle animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // Bounce controller for tap feedback
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    if (widget.state == NodeState.active) {
      _idleController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3D Switch Physics: Thickness layer (Base) + Pressable Layer (Face)
    final double thickness = 12.0;
    final double currentOffset = _isPressed ? thickness : 0.0;
    final double currentScale = _isPressed ? 0.96 : 1.0;
    
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _bounceController.forward(from: 0);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (widget.state != NodeState.locked) widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedBuilder(
        animation: Listenable.merge([_idleController, _pulseController, _shimmerController, _bounceController]),
        builder: (context, child) {
          // Subtle idle floating for active node
          final floatOffset = widget.state == NodeState.active 
              ? math.sin(_idleController.value * 2 * math.pi) * 3.0 
              : 0.0;
          
          // Pulse scale effect for active nodes
          final pulseScale = widget.state == NodeState.active
              ? 1.0 + (math.sin(_pulseController.value * 2 * math.pi) * 0.05)
              : 1.0;
          
          // Bounce effect
          final bounceValue = Curves.elasticOut.transform(_bounceController.value);
          final bounceScale = 1.0 + (bounceValue * 0.15);

          return Transform.translate(
            offset: Offset(0, floatOffset),
            child: Transform.scale(
              scale: pulseScale * bounceScale,
              child: AnimatedScale(
                scale: currentScale,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                child: SizedBox(
                  width: widget.baseSize,
                  height: widget.baseSize + thickness,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Pulse glow effect for active nodes
                      if (widget.state == NodeState.active)
                        Positioned(
                          top: thickness, left: -5, right: -5, bottom: -5,
                          child: Opacity(
                            opacity: 0.3 + (_pulseController.value * 0.4),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.baseSize * 0.45),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF9800),
                                    blurRadius: 20 + (_pulseController.value * 10),
                                    spreadRadius: 2 + (_pulseController.value * 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      
                      // 1. BASE (The 3D Thickness layer)
                      Positioned(
                        top: thickness, left: 0, right: 0, bottom: 0,
                        child: CustomPaint(
                          painter: _StoneClayPainter(
                            color: _getShadowColor(),
                            isBase: true,
                          ),
                        ),
                      ),

                      // 2. FACE (The tactile puffy layer)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 80),
                        curve: Curves.easeOut,
                        top: currentOffset,
                        left: 0, right: 0, bottom: thickness - currentOffset,
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: Size(widget.baseSize, widget.baseSize),
                              painter: _StoneClayPainter(
                                color: _getFaceColor(),
                                isBase: false,
                              ),
                            ),
                            
                            // Shimmer particles for active nodes
                            if (widget.state == NodeState.active)
                              CustomPaint(
                                size: Size(widget.baseSize, widget.baseSize),
                                painter: _ShimmerParticlePainter(
                                  progress: _shimmerController.value,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            
                            // 3. Iconic Features
                            Center(
                              child: _buildNodeIcon(),
                            ),
                          ],
                        ),
                      ),
                      
                      // 4. Fruit Stem & Leaf (On top of the fruit)
                      Positioned(
                        top: currentOffset - 8, left: 0, right: 0,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Leaf with gentle sway
                              Transform.rotate(
                                angle: 0.3 + (math.sin(_idleController.value * 2 * math.pi) * 0.1),
                                child: Container(
                                  width: 12,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF66BB6A),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                              // Stem
                              Container(
                                width: 4,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5D4037),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 5. Guiding Fox (Only for active node)
                      if (widget.state == NodeState.active && !_isPressed)
                        Positioned(
                          top: -40, left: 0, right: 0,
                          child: Center(
                            child: Transform.scale(
                              scale: 1.0 + (math.sin(_idleController.value * 2 * math.pi) * 0.1),
                              child: const Text("🦊", style: TextStyle(fontSize: 36)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNodeIcon() {
    switch (widget.state) {
      case NodeState.locked:
        return const Icon(Icons.lock_rounded, color: Colors.black26, size: 28);
      case NodeState.active:
        return Text(
          widget.label,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
          ),
        );
      case NodeState.completed:
        return const Icon(Icons.star_rounded, color: Colors.white, size: 40);
    }
  }

  Color _getFaceColor() {
     switch (widget.state) {
       case NodeState.locked: return const Color(0xFFA5D6A7); // Unripe Green
       case NodeState.active: return const Color(0xFFFFB300); // Bright Glossy Orange
       case NodeState.completed: return const Color(0xFFFDD835); // Vibrant Golden Yellow
     }
  }

  Color _getShadowColor() {
     switch (widget.state) {
       case NodeState.locked: return const Color(0xFF66BB6A); // Green Base
       case NodeState.active: return const Color(0xFFE65100); // Deep Rich Orange
       case NodeState.completed: return const Color(0xFFF57F17); // Gold Base
     }
  }
}

class _StoneClayPainter extends CustomPainter {
  final Color color;
  final bool isBase;
  _StoneClayPainter({required this.color, required this.isBase});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.width * 0.45);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );

    if (isBase) {
      // Base: Dark shadow/depth layer
      final basePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, basePaint);
    } else {
      // Face: Glossy gradient button like the image
      
      // 1. Main gradient fill (bright top to darker bottom)
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _brightenColor(color, 0.3), // Brighter top
            color, // Original middle
            _darkenColor(color, 0.15), // Darker bottom
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawRRect(rrect, gradientPaint);

      // 2. Glossy highlight on top (the shiny part from the image)
      final highlightPath = Path();
      final highlightRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.15, 
          size.height * 0.05,
          size.width * 0.7, 
          size.height * 0.35,
        ),
        Radius.circular(size.width * 0.35),
      );
      highlightPath.addRRect(highlightRRect);
      
      final highlightPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.7),
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.0),
          ],
        ).createShader(highlightRRect.outerRect);
      canvas.drawPath(highlightPath, highlightPaint);

      // 3. Subtle inner shadow at bottom for depth
      final shadowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.15),
          ],
          stops: const [0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      final innerPath = Path()..addRRect(rrect);
      canvas.drawPath(innerPath, shadowPaint);
    }
  }

  Color _brightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}

// Shimmer particle effect painter
class _ShimmerParticlePainter extends CustomPainter {
  final double progress;
  final Color color;
  
  _ShimmerParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    // Create multiple sparkle particles
    final random = math.Random(42); // Fixed seed for consistent pattern
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (progress * 2 * math.pi);
      final distance = size.width * 0.3 + (math.sin(progress * 2 * math.pi + i) * size.width * 0.1);
      
      final x = size.width / 2 + math.cos(angle) * distance;
      final y = size.height / 2 + math.sin(angle) * distance;
      
      // Pulsating size
      final particleSize = 2.0 + (math.sin(progress * 2 * math.pi * 2 + i) * 1.5);
      
      // Fade in/out based on position in cycle
      final opacity = (math.sin(progress * 2 * math.pi + i) + 1) / 2;
      paint.color = color.withOpacity(opacity * 0.8);
      
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
