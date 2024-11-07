class UserModel {
  final int id;
  final String userName;
  final String fullName;
  final String email;

  UserModel({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      userName: map['username'],
      fullName: map['fullName'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
    };
  }
}

class UserLoginResponse {
  final String jwt;
  final UserModel user;

  UserLoginResponse({
    required this.jwt,
    required this.user,
  });

  factory UserLoginResponse.fromMap(Map<String, dynamic> map) {
    return UserLoginResponse(
      jwt: map['jwt'],
      user: UserModel.fromMap(map['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jwt': jwt,
      'user': user.toMap(),
    };
  }
}
