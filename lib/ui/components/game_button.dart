import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/brand_colors.dart';
import '../theme/metrics.dart';

class GameButton extends StatefulWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppMetrics.buttonHeight,
    this.baseHeight = AppMetrics.buttonDepth,
    this.pressedOffset = AppMetrics.buttonPressOffset,
    this.radius = AppMetrics.radiusButton,
    this.faceColor = AppColors.orangeFace,
    this.baseColor = AppColors.orangeBase,
    this.outlineColor = AppColors.orangeOutline,
    this.textStyle,
    this.isLoading = false,
    this.enabled = true,
    this.leading,
    this.fullWidth = true,
    this.isJuicy = true,
  });

  final String label;
  final VoidCallback? onPressed;

  final double height;
  final double baseHeight;
  final double pressedOffset;
  final double radius;

  final Color faceColor;
  final Color baseColor;
  final Color outlineColor;

  final TextStyle? textStyle;
  final bool isLoading;
  final bool enabled;

  final Widget? leading;
  final bool fullWidth;
  final bool isJuicy;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _pressed = false;

  bool get _canPress => widget.enabled && !widget.isLoading && widget.onPressed != null;

  void _setPressed(bool v) {
    if (!_canPress) return;
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final face = widget.enabled ? widget.faceColor : widget.faceColor.withOpacity(0.45);
    final base = widget.enabled ? widget.baseColor : widget.baseColor.withOpacity(0.25);
    // outline is unused in stone clay style (border is white/transparent)

    final textStyle = widget.textStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            );

    final totalHeight = widget.height + widget.baseHeight;

    final child = AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: SizedBox(
        height: totalHeight,
        width: widget.fullWidth ? double.infinity : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. BASE (The Side Thickness / Depth)
            Positioned(
              left: 0,
              right: 0,
              top: widget.baseHeight,
              height: widget.height,
              child: Container(
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
              ),
            ),

            // 2. FACE (The tactile puffy layer)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              top: _pressed ? widget.baseHeight * 0.8 : 0,
              height: widget.height,
              child: Container(
                decoration: BoxDecoration(
                  // Glossy gradient background
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _brightenColor(face, 0.2),
                      face,
                      _darkenColor(face, 0.15),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(widget.radius),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2.0),
                ),
                child: Stack(
                  children: [
                    // Glossy Highlight
                    if (widget.isJuicy && widget.enabled)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ButtonGlossyPainter(radius: widget.radius),
                        ),
                      ),
                    
                    Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.leading != null) ...[
                                  widget.leading!,
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  widget.label, 
                                  style: textStyle?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(color: Colors.black26, offset: const Offset(0, 1), blurRadius: 2)
                                    ]
                                  )
                                ),
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
                  onTap: _canPress
                      ? () {
                          HapticFeedback.lightImpact();
                          widget.onPressed?.call();
                        }
                      : null,
                  onHighlightChanged: (v) => _setPressed(v),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: _canPress,
      label: widget.label,
      child: child,
    );
  }
}

  // Color manipulation helpers
  Color _brightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

class _ButtonGlossyPainter extends CustomPainter {
  final double radius;
  _ButtonGlossyPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    // Bright glossy highlight on top
    final highlightRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.08,
        size.width * 0.8,
        size.height * 0.3,
      ),
      Radius.circular(radius * 0.7),
    );
    
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.7),
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(highlightRRect.outerRect);
    
    canvas.drawRRect(highlightRRect, highlightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
