import 'dart:convert';
import 'dart:io';

import 'package:cityfix/models/report_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ReportController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isLoading = false;
  Position? currentPosition;
  String? currentAddress;

  //[1]================Pick Image================
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1080,
      );
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  //===clear image from state===
  void clearImage() {
    selectedImage = null;
    notifyListeners();
  }

  //[2]=========Location=========
  Future<void> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      // only fetch if permission is granted
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        //current position
        currentPosition = await Geolocator.getCurrentPosition();
        //converts
        List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition!.latitude,
          currentPosition!.longitude,
        );
        Placemark place = placemarks[0];
        currentAddress =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      rethrow;
    }
  }

  //[3]=========Upload Picture to cloudinary=========
  Future<String> uploadImageToCloudinary() async {
    // Implementation for uploading image to Cloudinary
    try {
      //make sure image exists
      if (selectedImage == null) {
        throw Exception("No image selected");
      }

      //create a box
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/dpfk22rwm/image/upload'),
      );

      //add the picture to the box
      request.files.add(
        await http.MultipartFile.fromPath('file', selectedImage!.path),
      );

      //add the preset to the box
      request.fields['upload_preset'] = 'cityfix_reports';

      //receive the response from cloudinary
      var response = await request.send();

      //convert the response to a readable format
      var responseData = await http.Response.fromStream(response);

      var json = jsonDecode(responseData.body);

      //check if upload was successful
      if (response.statusCode == 200) {
        //extract the secure url from the response and return it
        return json['secure_url'] as String; //this is the return
      } else {
        throw Exception(json['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  //[4]=========Submit Report=========
  Future<void> submitReport(String category, String description) async {
    try {
      if (selectedImage == null || description.isEmpty) {
        throw Exception('please fill in all fields and select an image');
      }
      if (currentPosition == null) {
        throw Exception(
          'Unable to get location. Please allow location access and try again.',
        );
      }
      isLoading = true;
      notifyListeners();
      String imageUrl = await uploadImageToCloudinary();
      ReportModel report = ReportModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        category: category,
        imageUrl: imageUrl,
        description: description,
        address: currentAddress,
        location: GeoPoint(
          currentPosition!.latitude,
          currentPosition!.longitude,
        ),
      );
      await _db.collection("reports").add(report.toMap());
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //[5]=========Reports display=========
  Stream<List<ReportModel>> fetchReports() {
    return _db
        .collection("reports")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReportModel.fromFirestore(doc))
              .toList(),
        );
  }
}
