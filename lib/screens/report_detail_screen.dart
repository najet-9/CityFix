import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cityfix/screens/language_screen.dart';

class ReportDetailScreen extends StatefulWidget {
  final String reportId;

  const ReportDetailScreen({super.key, required this.reportId});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  File? _selectedImage;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadToCloudinary() async {
    if (_selectedImage == null) return null;

    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dpfk22rwm/image/upload',
      );
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'cityfix_reports'
        ..files.add(
          await http.MultipartFile.fromPath('file', _selectedImage!.path),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonRes = jsonDecode(responseString);
        return jsonRes['secure_url'];
      }
    } catch (e) {
      debugPrint("Cloudinary Upload Error: $e");
    }
    return null;
  }

  Future<void> _submitConfirmation(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please take a photo to confirm the issue.".tr()),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    String? imageUrl = await _uploadToCloudinary();

    if (imageUrl != null) {
      try {
        String currentReportId = widget.reportId;

        await FirebaseFirestore.instance
            .collection('reports')
            .doc(currentReportId)
            .collection('confirmations')
            .add({
              'confirmationImg': imageUrl,
              'description': _descriptionController.text,
              'createdAt': FieldValue.serverTimestamp(),
            });

        await FirebaseFirestore.instance
            .collection('reports')
            .doc(currentReportId)
            .update({'confirmationCount': FieldValue.increment(1)});

        //notifs :(R)===========================================================
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': data['userId'],
          'reportId': currentReportId,
          'message': 'Someone confirmed your report!',
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
          'type': 'confirmation',
        });

        // fetch report owner's oneSignalId
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(data['userId'])
            .get();
        String? oneSignalId = userDoc.data()?['oneSignalId'];

        // send push notification directly
        if (oneSignalId != null) {
          final response = await http.post(
            Uri.parse('https://onesignal.com/api/v1/notifications'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Basic ${dotenv.env['ONESIGNAL_API_KEY']}',
            },
            body: jsonEncode({
              'app_id': 'a20c368d-e7a7-420b-8cdf-e6266b6e82ed',
              'include_aliases': {
                'onesignal_id': [oneSignalId],
              },
              'target_channel': 'push',
              'contents': {'en': 'Someone confirmed your report!'},
            }),
          );
        }
        //========================================================================
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Confirmation submitted successfully!".tr()),
            ),
          );
        }
      } catch (e) {
        debugPrint("Firestore Error: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Database error. Please try again.".tr())),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload image. Check your connection.".tr()),
          ),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _showConfirmationSheet(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 25,
            right: 25,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Confirm this issue".tr(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Help us verify this by adding a photo or description.".tr(),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 25),

                Text(
                  "Add a Photo".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () async {
                    await _pickImage();
                    setSheetState(() {});
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade100, width: 2),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_a_photo_outlined,
                                color: Color(0xFF2B58E4),
                                size: 35,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Take a picture".tr(),
                                style: const TextStyle(
                                  color: Color(0xFF2B58E4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  "Description (Optional)".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Add more details about the problem...".tr(),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B58E4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () => _submitConfirmation(context, data),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Submit Confirmation".tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    // --- DYNAMIC DATA FETCHING ---
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.reportId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(body: Center(child: Text("Report not found".tr())));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;

        // Extracting data fields
        String imageUrl = data['imageUrl'] ?? 'https://via.placeholder.com/400';
        String category = data['category'] ?? 'Issue';
        String location = data['location']?.toString() ?? 'Unknown Location';
        if (data['location'] is GeoPoint) {
          GeoPoint gp = data['location'];
          location =
              "${gp.latitude.toStringAsFixed(4)}, ${gp.longitude.toStringAsFixed(4)}";
        }
        int count = data['confirmationCount'] ?? 0;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl), // Dynamic Image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.tr(), // Traduit la catégorie si elle est en clé
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1D1E),
                        ),
                      ), // Dynamic Category
                      const SizedBox(height: 5),
                      Text(
                        "Recent Report".tr(),
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFF2B58E4),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "LOCATION".tr(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    location,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ), // Dynamic Location
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () => _showConfirmationSheet(context, data),
                        child: Container(
                          width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4267F2), Color(0xFF2B58E4)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2B58E4).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Confirm Issue".tr() + " ($count)",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ), // Dynamic Count
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}