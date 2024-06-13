class ProfileResponseDto {
  final String id;
  final Role role;
  final String email;
  final String name;

  ProfileResponseDto({required this.id, required this.role, required this.email, required this.name});

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfileResponseDto(
      id: json["id"] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      role: _parseRole(json['role']),
    );
  }

   static Role _parseRole(String? role) {
    if (role == null) return Role.trainer;
    switch (role.toLowerCase()) {
      case 'trainer':
        return Role.trainer;
      case 'admin':
        return Role.admin;
      default:
        return Role.trainer;
    }
  }
}

enum Role { trainer, admin }