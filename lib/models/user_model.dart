class User {
  final String name;
  final String email;
  final String address;
  final String profilePictureUrl;

  User({
    required this.name,
    required this.email,
    required this.address,
    required this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      profilePictureUrl: json['profile_picture'] ?? '',
    );
  }
}
