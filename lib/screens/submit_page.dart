import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({Key? key}) : super(key: key);

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  int step = 1;
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {"id": "roads", "label": "Roads", "icon": "🕳️"},
    {"id": "lighting", "label": "Lighting", "icon": "💡"},
    {"id": "water", "label": "Water", "icon": "💧"},
    {"id": "waste", "label": "Waste", "icon": "🗑️"},
    {"id": "parks", "label": "Parks", "icon": "🌿"},
    {"id": "other", "label": "Other", "icon": "📋"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              color: const Color(0xFF2563EB),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New",
                    style: GoogleFonts.sora(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Submit a Report",
                    style: GoogleFonts.sora(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildProgressIndicator("Category", step >= 1),
                      const SizedBox(width: 12),
                      _buildProgressIndicator("Details", step >= 2),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: step == 1 ? _buildStepOne() : _buildStepTwo(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String label, bool isActive) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.sora(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's the issue?",
          style: GoogleFonts.sora(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Select the category that best describes the problem.",
          style: GoogleFonts.sora(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = selectedCategory == cat['id'];
            return GestureDetector(
              onTap: () => setState(() => selectedCategory = cat['id']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE0EAFF) : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cat['icon'], style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 10),
                    Text(
                      cat['label'],
                      style: GoogleFonts.sora(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                selectedCategory != null ? () => setState(() => step = 2) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              disabledBackgroundColor: const Color(0xFFCBD5E1),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              "Continue →",
              style: GoogleFonts.sora(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Photo & Location",
          style: GoogleFonts.sora(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("📷", style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                "Tap to take a photo",
                style: GoogleFonts.sora(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "or upload from gallery",
                style: GoogleFonts.sora(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text("📍", style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "GPS Location Detected",
                      style: GoogleFonts.sora(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Oran, Algeria",
                      style: GoogleFonts.sora(
                        color: const Color(0xFF10B981),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check, color: Color(0xFF10B981), size: 24),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          maxLines: 4,
          style: GoogleFonts.sora(
            fontSize: 14,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: "Describe the problem in detail...",
            hintStyle: GoogleFonts.sora(color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            InkWell(
              onTap: () => setState(() => step = 1),
              child: Container(
                width: 60,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                    child: Icon(Icons.arrow_back, color: Color(0xFF64748B))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  "Submit Report",
                  style: GoogleFonts.sora(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
