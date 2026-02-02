import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/metrics.dart';
import '../theme/brand_colors.dart';

enum TileState { idle, selected, correct, wrong }

class GameChoiceTile extends StatefulWidget {
  const GameChoiceTile({
    super.key,
    required this.label,
    required this.onPressed,
    this.state = TileState.idle,
    this.height = AppMetrics.tileHeight,
    this.baseHeight = AppMetrics.tileDepth,
    this.pressedOffset = AppMetrics.tilePressOffset,
    this.radius = AppMetrics.radiusCard,
    this.leading,
  });

  final String label;
  final VoidCallback onPressed;
  final TileState state;
  final double height;
  final double baseHeight;
  final double pressedOffset;
  final double radius;
  final Widget? leading;

  @override
  State<GameChoiceTile> createState() => _GameChoiceTileState();
}

class _GameChoiceTileState extends State<GameChoiceTile> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  Color get _faceColor {
    switch (widget.state) {
      case TileState.selected:
        return AppColors.energyFace; // Bright Blue for selection
      case TileState.correct:
        return AppColors.successFace; // Success Green
      case TileState.wrong:
        return AppColors.errorFace; // Bright Red
      case TileState.idle:
        return AppColors.neutralFace; // Pure White
    }
  }

  Color get _baseColor {
    switch (widget.state) {
      case TileState.selected:
        return AppColors.energyBase; // Deep Blue
      case TileState.correct:
        return AppColors.successBase; // Deep Green
      case TileState.wrong:
        return AppColors.errorBase; // Deep Red
      case TileState.idle:
        return AppColors.neutralBase; // Light Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    // Stone Switch Physics
    final double thickness = 8.0;
    final double currentOffset = _pressed ? thickness : 0.0;
    final double currentScale = _pressed ? 0.98 : 1.0;
    
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: widget.state == TileState.selected || widget.state == TileState.correct || widget.state == TileState.wrong
              ? Colors.white 
              : const Color(0xFF455A64), // Dark Blue Grey for idle
        );

    return AnimatedScale(
      scale: currentScale,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: SizedBox(
        height: widget.height + thickness,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. BASE (Depth Layer)
            Positioned(
              left: 0,
              right: 0,
              top: thickness,
              height: widget.height,
              child: Container(
                decoration: BoxDecoration(
                  color: _baseColor,
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
              ),
            ),

            // 2. FACE (Pressable Layer)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              top: currentOffset,
              height: widget.height,
              child: Container(
                decoration: BoxDecoration(
                  // Glossy gradient (bright top to darker bottom)
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _brightenColor(_faceColor, 0.15),
                      _faceColor,
                      _darkenColor(_faceColor, 0.1),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(widget.radius),
                  border: Border.all(
                    color: widget.state == TileState.idle 
                        ? AppColors.neutralOutline.withOpacity(0.3)
                        : Colors.white.withOpacity(0.3), 
                    width: 2.0,
                  ),
                ),
                child: Stack(
                  children: [
                    // Glossy Highlight on top
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _TileGlossyPainter(
                          radius: widget.radius,
                          isIdle: widget.state == TileState.idle,
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          if (widget.leading != null) ...[
                            widget.leading!,
                            const SizedBox(width: 16),
                          ],
                          Expanded(
                            child: Text(
                              widget.label,
                              style: textStyle,
                            ),
                          ),
                          if (widget.state == TileState.correct)
                            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
                          if (widget.state == TileState.wrong)
                            const Icon(Icons.cancel_rounded, color: Colors.white, size: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Touch Layer
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(widget.radius),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onPressed();
                  },
                  onHighlightChanged: (v) => _setPressed(v),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Color manipulation helpers for glossy effect
  Color _brightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

class _TileGlossyPainter extends CustomPainter {
  final double radius;
  final bool isIdle;
  
  _TileGlossyPainter({required this.radius, required this.isIdle});

  @override
  void paint(Canvas canvas, Size size) {
    // Glossy highlight on top (more prominent for active states)
    final highlightOpacity = isIdle ? 0.15 : 0.6;
    
    final highlightRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.05,
        size.width * 0.8,
        size.height * 0.3,
      ),
      Radius.circular(radius * 0.8),
    );
    
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(highlightOpacity),
          Colors.white.withOpacity(highlightOpacity * 0.5),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(highlightRRect.outerRect);
    
    canvas.drawRRect(highlightRRect, highlightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
