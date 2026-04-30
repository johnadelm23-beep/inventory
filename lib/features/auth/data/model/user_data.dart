class UserData {
  String? name;
  String? email;
  bool? isAdmin;
  bool? isBlocked;
  String? password;

  UserData.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    isAdmin = json["isAdmin"];
    isBlocked = json["isBlocked"];
    password = json["password"];
  }
}
