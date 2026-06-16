class Customer {
  int? id;
  String name;
  String email;
  String password;
  int points;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.points = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'points': points,
    };
  }
}