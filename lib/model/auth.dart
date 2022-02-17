import '../model/base.dart';

class Auth extends Base {
  int? id;
  String? name;
  String email;
  String password;

  Auth(this.email, this.password);

  Auth.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        password = json['password'];
}
