class UserModel{
  String id;
  String email;
  String name;
  String image;

  UserModel({this.id, this.email, this.name, this.image});

  factory UserModel.fromMap(Map<String, dynamic> json) =>
    UserModel(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      image: json["image"],
    );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "image": image,
  };
}