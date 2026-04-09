import 'package:flutter/material.dart';
import 'package:cityfix/screens/language_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedIndex;

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I submit a report?'.tr(),
      'answer':
          'Tap the "+" button in the bottom navigation bar. Fill in the issue category, description, and location. You can also attach a photo. Once submitted, your report will be visible to other citizens and the city team.'.tr(),
    },
    {
      'question': 'How long does it take to resolve an issue?'.tr(),
      'answer':
          'Resolution time depends on the severity and type of issue. Most reports are reviewed within 48 hours. You\'ll receive a notification when the status of your report changes to "In Progress" or "Resolved".'.tr(),
    },
    {
      'question': 'Can I edit or delete my report after submitting?'.tr(),
      'answer':
          'Currently, reports cannot be edited after submission. If you need to remove a report, please contact our support team and provide your report ID.'.tr(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Frequently Asked Questions'.tr()),
                  const SizedBox(height: 14),
                  ..._faqs
                      .asMap()
                      .entries
                      .map((e) => _buildFaqItem(e.key, e.value))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2962FF), Color(0xFF448AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'We\'re here for you'.tr(),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Help & Support'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildFaqItem(int index, Map<String, dynamic> faq) {
    final isExpanded = _expandedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isExpanded
                ? const Color(0xFF2B58E4).withOpacity(0.3)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? const Color(0xFFEFF6FF)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      Icons.help_outline,
                      color: isExpanded
                          ? const Color(0xFF2B58E4)
                          : Colors.grey[500],
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      faq['question'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isExpanded
                            ? const Color(0xFF2B58E4)
                            : const Color(0xFF1A1D1E),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isExpanded
                        ? const Color(0xFF2B58E4)
                        : Colors.grey[400],
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    faq['answer'],
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}