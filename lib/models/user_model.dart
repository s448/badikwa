class User {
  final String id;
  final String name;
  final String email;
  final String password;

  User(this.id, this.email, this.password, this.name);
  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      email = json['email'],
      password = json['password'],
      name = json['name'];
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'password': password, 'name': name};
  }
}
