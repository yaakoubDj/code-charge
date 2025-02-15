import 'package:flutter/material.dart';

class TrueFalseBall extends StatefulWidget {
  final bool isValid; // true for green, false for red

  const TrueFalseBall({Key? key, required this.isValid}) : super(key: key);

  @override
  State<TrueFalseBall> createState() => _TrueFalseBallState();
}

class _TrueFalseBallState extends State<TrueFalseBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.isValid ? Colors.green : Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
