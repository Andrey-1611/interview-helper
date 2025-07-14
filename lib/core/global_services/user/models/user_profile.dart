class UserProfile {
  final String? id;
  final String? name;
  final String email;

  UserProfile({this.id, this.name, required this.email});

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }
}
