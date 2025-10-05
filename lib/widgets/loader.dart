import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key});

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Fixed duration
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80.0,  // Fixed size
        height: 80.0, // Fixed size
        decoration: BoxDecoration(
          color: Colors.black54, // Fixed background color
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: RotationTransition(
          turns: _controller,
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
              strokeWidth: 4.0, // Fixed stroke width
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Fixed indicator color
            ),
          ),
        ),
      ),
    );
  }
}