import 'package:cityfix/controllers/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({Key? key}) : super(key: key);

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  int step = 1;
  String? selectedCategory;
  final TextEditingController descriptionController = TextEditingController();
  final ReportController _reportController = ReportController();

  final List<Map<String, dynamic>> categories = [
    {"id": "roads", "label": "Roads".tr(), "icon": "🕳️"},
    {"id": "lighting", "label": "Lighting".tr(), "icon": "💡"},
    {"id": "water", "label": "Water".tr(), "icon": "💧"},
    {"id": "waste", "label": "Waste".tr(), "icon": "🗑️"},
    {"id": "parks", "label": "Parks".tr(), "icon": "🌿"},
    {"id": "other", "label": "Other".tr(), "icon": "📋"},
  ];

  @override
  void initState() {
    super.initState();
    _reportController.getLocation().then((_) {
      setState(() {});
    });
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => const _ImagePickerSheet(),
        )
        .then((source) {
          if (source != null) {
            _reportController.pickImage(source).then((_) {
              setState(() {}); // refresh UI to show picked image
            });
          }
        })
        .catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not access camera or gallery.'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFF1D4ED8),
            ),
          );
        });
  }

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
                    "New".tr(),
                    style: GoogleFonts.sora(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Submit a Report".tr(),
                    style: GoogleFonts.sora(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildProgressIndicator("Category".tr(), step >= 1),
                      const SizedBox(width: 12),
                      _buildProgressIndicator("Details".tr(), step >= 2),
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
          "What's the issue?".tr(),
          style: GoogleFonts.sora(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Select the category that best describes the problem.".tr(),
          style: GoogleFonts.sora(fontSize: 13, color: const Color(0xFF64748B)),
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
                    ),
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
            onPressed: selectedCategory != null
                ? () => setState(() => step = 2)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              disabledBackgroundColor: const Color(0xFFCBD5E1),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Continue →".tr(),
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
          "Add Photo & Location".tr(),
          style: GoogleFonts.sora(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 20),

        // ── Photo Card ─────────────────────────────────────────────────────
        GestureDetector(
          onTap: _showImageSourceSheet,
          child: Container(
            height: _reportController.selectedImage != null ? 220 : 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: _reportController.selectedImage != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        _reportController.selectedImage!,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _reportController.clearImage()),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("📷", style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to take a photo".tr(),
                        style: GoogleFonts.sora(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "or upload from gallery".tr(),
                        style: GoogleFonts.sora(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 16),

        // ── Location Card ───────────────────────────────────────────────────
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
                  child: Text("📍", style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "GPS Location ".tr(),
                      style: GoogleFonts.sora(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _reportController.currentAddress ??
                          "Fetching location...".tr(),
                      style: GoogleFonts.sora(
                        color: _reportController.currentAddress == null
                            ? Colors.orange
                            : const Color(0xFF10B981),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (_reportController.currentAddress != null)
                const Icon(Icons.check, color: Color(0xFF10B981), size: 24),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Description Field ───────────────────────────────────────────────
        TextField(
          controller: descriptionController,
          maxLines: 4,
          style: GoogleFonts.sora(fontSize: 14, color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: "Describe the problem in detail...".tr(),
            hintStyle: GoogleFonts.sora(color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── Bottom Buttons ──────────────────────────────────────────────────
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
                  child: Icon(Icons.arrow_back, color: Color(0xFF64748B)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  try {
                    await _reportController.submitReport(
                      selectedCategory!,
                      descriptionController.text,
                    );
                    setState(() {});
                    // Navigate to the success page after a successful submission
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ReportSuccessPage(),
                      ),
                    );
                  } catch (e) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to submit report: ${e.toString().replaceAll('Exception: ', '')}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF1D4ED8),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _reportController.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Submit Report".tr(),
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

// ─── Report Success Page ──────────────────────────────────────────────────────

class ReportSuccessPage extends StatelessWidget {
  const ReportSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Green check icon ──────────────────────────────────────
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: Color(0xFF16A34A),
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Title ─────────────────────────────────────────────────
                Text(
                  "Report Submitted!".tr(),
                  style: GoogleFonts.sora(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your report has been received.".tr(),
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Home button ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Done".tr(),
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
          ),
        ),
      ),
    );
  }
}

// ─── Image Picker Bottom Sheet ───────────────────────────────────────────────

class _ImagePickerSheet extends StatelessWidget {
  const _ImagePickerSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            "Add a Photo".tr(),
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Choose how you'd like to attach an image".tr(),
            style: GoogleFonts.sora(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 28),

          Row(
            children: [
              // Camera
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF2563EB).withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Camera".tr(),
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Take a new photo".tr(),
                          style: GoogleFonts.sora(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Gallery
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF64748B),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.photo_library_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Gallery".tr(),
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Pick from library".tr(),
                          style: GoogleFonts.sora(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Cancel".tr(),
                style: GoogleFonts.sora(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
