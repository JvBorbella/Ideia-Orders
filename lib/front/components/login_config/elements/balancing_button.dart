import 'package:flutter/material.dart';

class InfiniteSwing extends StatefulWidget {
  final Widget child;

  const InfiniteSwing({super.key, required this.child});

  @override
  State<InfiniteSwing> createState() => _InfiniteSwingState();
}

class _InfiniteSwingState extends State<InfiniteSwing>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(seconds: 3),
      lowerBound: -0.05,
      upperBound: 0.05,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: controller.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}