class UserModel {
  final int idUser;
  final String nama;
  final String email;
  final String role;

  UserModel({
    required this.idUser,
    required this.nama,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'],
      nama: json['nama'],
      email: json['email'],
      role: json['role'],
    );
  }
}
