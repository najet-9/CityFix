import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final bool obscureText;
  final Widget? rightEl;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const InputField({
    super.key,
    required this.icon,
    required this.placeholder,
    this.obscureText = false,
    this.rightEl,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF94A3B8), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (rightEl != null) rightEl!,
        ],
      ),
    );
  }
}
