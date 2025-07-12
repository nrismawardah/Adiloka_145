class UserModel {
  final int idUser;
  final String nama;
  final String role;

  UserModel({required this.idUser, required this.nama, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'],
      nama: json['nama'],
      role: json['role'],
    );
  }
}

class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}
