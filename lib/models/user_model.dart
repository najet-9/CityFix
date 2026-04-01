class UserModel {
  final String? id; 
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber; 
  final String wilaya;     

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber, 
    required this.wilaya,      
  });

  // Convertit l'objet UserModel en Map pour Firestore
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber, 
      'wilaya': wilaya,           
    };
  }
}