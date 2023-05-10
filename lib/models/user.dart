class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.lastActive,
    required this.createdAt,
    required this.about,
    required this.isOnline,
    required this.image,
    required this.pushToken,
    required this.email,
    required this.gender,
    required this.profession,
  });
  late String id;
  late String name;
  late int age;
  late String lastActive;
  late String createdAt;
  late String about;
  late bool isOnline;
  late String image;
  late String pushToken;
  late String email;
  late String gender;
  late String profession;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    age = json['age'] ?? 0;
    lastActive = json['last_active'] ?? '';
    createdAt = json['created_at'] ?? '';
    about = json['about'] ?? '';
    isOnline = json['is_online'] ?? false;
    image = json['image'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
    gender = json['gender'] ?? '';
    profession = json['profession'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['last_active'] = lastActive;
    data['created_at'] = createdAt;
    data['about'] = about;
    data['is_online'] = isOnline;
    data['image'] = image;
    data['push_token'] = pushToken;
    data['email'] = email;
    data['gender'] = gender;
    data['profession'] = profession;
    return data;
  }
}
