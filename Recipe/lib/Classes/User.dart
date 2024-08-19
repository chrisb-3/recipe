
class User {
   int id;
   String emailAddress;
   String name;

  User({ //Constructor
    required this.id,
    required this.emailAddress,
    required this.name,
  });

  // Convert User object into a Map / Json
  Map<String, dynamic> toJson() => {
    'id': id,
    'email_address': emailAddress,
    'name': name,
  };

  // Create User object from a Map / Json
  static User fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    emailAddress: json['email_address'] as String,
    name: json['name'] as String,
  );
}
