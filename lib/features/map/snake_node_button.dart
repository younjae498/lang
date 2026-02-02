import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../ui/theme/brand_colors.dart';

enum SnakeNodeStatus { locked, available, completed }

class SnakeNodeButton extends StatefulWidget {
  const SnakeNodeButton({
    super.key,
    required this.onTap,
    this.status = SnakeNodeStatus.available,
    this.progress = 0.0,
    this.icon,
    this.color = AppColors.successFace,
    this.label = "0",
  });

  final VoidCallback onTap;
  final SnakeNodeStatus status;
  final double progress;
  final IconData? icon;
  final Color color;
  final String label;

  @override
  State<SnakeNodeButton> createState() => _SnakeNodeButtonState();
}

class _SnakeNodeButtonState extends State<SnakeNodeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _depthAnimation;

  @override
  void initState() {
    super.initState();
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
    if (widget.status == SnakeNodeStatus.locked) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.status == SnakeNodeStatus.locked) return;
    _controller.animateBack(0.0, curve: Curves.elasticOut).then((_) => widget.onTap());
  }

  void _handleTapCancel() {
    if (widget.status == SnakeNodeStatus.locked) return;
    _controller.animateBack(0.0, curve: Curves.elasticOut);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = widget.status == SnakeNodeStatus.locked;
    final bool isCompleted = widget.status == SnakeNodeStatus.completed;
    
    final Color faceColor = isLocked 
        ? AppColors.lockedGray 
        : (isCompleted ? AppColors.energyFace : widget.color);
    
    const double size = 90.0;
    const double maxDepth = 6.0;
    const double scaleY = 0.95;

    return GestureDetector(
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
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: maxDepth + 4,
                  child: Transform(
                    transform: Matrix4.identity()..scale(1.0, scaleY),
                    alignment: Alignment.center,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: maxDepth,
                  child: Transform(
                    transform: Matrix4.identity()..scale(1.0, scaleY),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: isLocked ? const Color(0xFF616161) : AppColors.foxOrange,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: _depthAnimation.value * maxDepth,
                  child: Transform(
                    transform: Matrix4.identity()..scale(1.0, scaleY),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: isLocked ? const Color(0xFFE0E0E0) : AppColors.foxCream,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 2.0),
                      ),
                      child: Center(child: _buildIcon(isLocked, isCompleted)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(bool isLocked, bool isCompleted) {
    if (isLocked) {
      return const Icon(Icons.lock_rounded, color: Color(0xFF9E9E9E), size: 32); 
    }
    if (isCompleted) {
      return const Icon(Icons.check_rounded, color: AppColors.foxBrown, size: 40); 
    }
    return Icon(widget.icon ?? Icons.star_rounded, color: AppColors.foxBrown, size: 36); 
  }
}
