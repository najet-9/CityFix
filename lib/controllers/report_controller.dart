import 'dart:convert';
import 'dart:io';

import 'package:cityfix/controllers/auth_controller.dart';
import 'package:cityfix/models/notification_model.dart';
import 'package:cityfix/models/report_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      //here we extract the wilaya from the address of the report
      String wilaya = currentAddress!
          .split(',')[1]
          .trim()
          .replaceAll(' Province', '');

      print('currentAddress: $currentAddress');
      print('wilaya: $wilaya');
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

      //send notif (nearby users in the same wilaya)=========================================================
      // fetch nearby users
      // notify each nearby user except the one who submitted
      QuerySnapshot users = await _db
          .collection('users')
          .where('wilaya', isEqualTo: wilaya)
          .get();
      // notify each nearby user except the one who submitted
      for (var user in users.docs) {
        if (user.id != FirebaseAuth.instance.currentUser!.uid) {
          await _db.collection('notifications').add({
            'userId': user.id,
            'type': 'urgent',
            'message': 'Urgent incident detected near you!',
            'isRead': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
          // send push notification
          String? oneSignalId =
              (user.data() as Map<String, dynamic>)['oneSignalId'];
          if (oneSignalId != null) {
            await sendPushNotification(
              oneSignalId,
              'Urgent incident detected near you!',
            );
          }
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //[5]=========MyReports (in profile ) display=========
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

  //[7]=========Notifs=========
  Stream<List<NotificationModel>> fetchNotifications() {
    return _db
        .collection("notifications")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList(),
        );
  }

  //[8]=========Mark notification as read=========
  Future<void> markNotificationAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  //[9]=========Send push notification (OneSignal)=========
  Future<void> sendPushNotification(String oneSignalId, String message) async {
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
        'contents': {'en': message},
      }),
    );
  }

  //calculations===============================

  //=========for HomeScreen=========
  // in_progress count + resolved count across ALL users.
  Stream<Map<String, int>> fetchGlobalStats() {
    return _db.collection('reports').snapshots().map((snapshot) {
      //in progress
      final inProgress = snapshot.docs.where((doc) {
        return (doc.data() as Map<String, dynamic>)['status'] == 'in_progress';
      }).length;
      //resolved
      final resolved = snapshot.docs.where((doc) {
        return (doc.data() as Map<String, dynamic>)['status'] == 'resolved';
      }).length;
      return {'inProgress': inProgress, 'resolved': resolved};
    });
  }

  //=========User stats for ProfileScreen=========
  // resolved: my resolved reports , reports count: my reports count
  Stream<Map<String, int>> fetchUserStats() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value({'total': 0, 'resolved': 0});
    return _db
        .collection('reports')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          //total my reports count (regardless of status)
          final total = snapshot.docs.length;
          //my resolved reports count
          final resolved = snapshot.docs.where((doc) {
            return (doc.data() as Map<String, dynamic>)['status'] == 'resolved';
          }).length;
          return {'total': total, 'resolved': resolved};
        });
  }
}

//wrapper , main , auth controller , report controller , report detail screen
