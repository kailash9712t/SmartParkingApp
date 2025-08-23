import 'package:flutter/material.dart';

class ProgressIndicatorBar extends StatelessWidget
    implements PreferredSizeWidget {
  final double currentStep;
  final double totalStep;
  final Duration animationDuration;

  const ProgressIndicatorBar({
    super.key,
    required this.currentStep,
    this.totalStep = 3,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: (currentStep - 1) / totalStep),
      duration: animationDuration,
      builder: (context, value, child) {
        return SizedBox(
          height: 10,
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(20);
}
