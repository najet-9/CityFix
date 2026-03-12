class UserModel {
  final String? id; // optional, Firebase generates this
  final String fullName;
  final String email;
  final String password;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });

  // converts UserModel object into a map for Firestore
  Map<String, dynamic> toJson() {
    return {'fullName': fullName, 'email': email, 'password': password};
  }
}
