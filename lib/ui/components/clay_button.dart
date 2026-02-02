import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';
import '../theme/metrics.dart';

class ClayButton extends StatefulWidget {
  const ClayButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.successFace,
    this.baseColor,
    this.textColor = Colors.white,
    this.icon,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color? baseColor;
  final Color textColor;
  final IconData? icon;
  final bool fullWidth;

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _depthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _depthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    _controller.reverse().then((_) => widget.onPressed?.call());
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? _getDarkerColor(widget.color);
    final isDisabled = widget.onPressed == null;
    const double maxDepth = 6.0;
    const double radius = 16.0;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: isDisabled ? 0.6 : 1.0,
            child: SizedBox(
              width: widget.fullWidth ? double.infinity : null,
              height: 52 + maxDepth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // BASE (The 3D part)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: maxDepth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                    ),
                  ),
                  
                  // FACE (The part you click)
                  Positioned(
                    top: _depthAnimation.value * maxDepth,
                    left: 0,
                    right: 0,
                    bottom: maxDepth - (_depthAnimation.value * maxDepth),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: widget.color,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: widget.textColor, size: 24),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.label.toUpperCase(),
                              style: TextStyle(
                                color: widget.textColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 0.8,
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
          );
        },
      ),
    );
  }

  Color _getDarkerColor(Color color) {
    if (color == AppColors.duoGreen) return AppColors.duoGreenBase;
    if (color == AppColors.duoBlue) return AppColors.duoBlueBase;
    if (color == AppColors.duoGold) return AppColors.duoGoldBase;
    if (color == AppColors.duoRed) return AppColors.duoRedBase;

    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }
}
