class UserProfile {
  final String? name;
  final String email;

  UserProfile({this.name, required this.email});

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email};
  }
}
