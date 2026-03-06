import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.onTap,
    this.colors = const [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
  });

  final Widget child;
  final VoidCallback? onTap;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}
