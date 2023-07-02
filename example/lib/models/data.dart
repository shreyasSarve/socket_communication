import 'package:socket_com/socket_com.dart' show DTO;

class User extends DTO {
  final String username;
  User(this.username);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['username']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'username': username};
  }
}
