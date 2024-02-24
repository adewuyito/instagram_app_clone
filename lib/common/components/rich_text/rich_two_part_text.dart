import 'package:flutter/material.dart';

class RichTwoPartText extends StatelessWidget {
  final String firstPart;
  final String secondPart;
  const RichTwoPartText({
    super.key,
    required this.firstPart,
    required this.secondPart,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white70,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: firstPart,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' $secondPart',
          )
        ],
      ),
    );
  }
}
