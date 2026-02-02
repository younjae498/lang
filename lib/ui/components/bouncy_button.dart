import 'package:flutter/material.dart';

class BouncyButton extends StatefulWidget {
  const BouncyButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleDown = 0.9,
    this.scaleUp = 1.05,
    this.duration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double scaleDown;
  final double scaleUp;
  final Duration duration;

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 1.0, 
    );
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    _isPressed = true;
    _controller.animateTo(1.0, curve: Curves.easeOut, duration: widget.duration); // Scale down
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    _isPressed = false;
    // Bounce effect: Reverse -> Overshoot -> Settled
    _controller.reverse().then((_) {
        // Trigger the actual callback after the visual "up" starts
        widget.onPressed?.call();
    });
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    _isPressed = false;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // 0.0 -> 1.0 (Pressed)
    // Scale goes from 1.0 -> scaleDown
    final scale = 1.0 - (_controller.value * (1.0 - widget.scaleDown));

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: scale,
        child: widget.child,
      ),
    );
  }
}
