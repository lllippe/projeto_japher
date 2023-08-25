
class User {
  int id;
  String email;

  User({
    required this.id,
    required this.email,
  });

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        email = map['email'];

  @override
  String toString() {
    return "id:$id\nemail:$email";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }
}
