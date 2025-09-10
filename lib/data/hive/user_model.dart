import 'package:hive/hive.dart';

part 'user_model.g.dart'; // will be generated

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
  });
}
