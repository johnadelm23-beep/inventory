class UserData {
  String? name;
  String? email;
  bool? isAdmin;

  UserData.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    isAdmin = json["isAdmin"];
  }
}
