class User {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String password;

  User(this.id, this.email, this.password, this.name, this.phoneNumber);
  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      email = json['email'],
      password = json['password'],
      name = json['name'],
      phoneNumber = json['phoneNumber'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
