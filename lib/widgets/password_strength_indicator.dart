import 'dart:math';
import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    int strength = min(4, password.length ~/ 3);
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
    ];
    final labels = ['Weak', 'Fair', 'Good', 'Strong'];

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: index < 3 ? 5 : 0),
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: index < strength
                        ? colors[strength - 1]
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            strength > 0 ? '${labels[strength - 1]} password' : '',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: strength > 0
                  ? colors[strength - 1]
                  : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
