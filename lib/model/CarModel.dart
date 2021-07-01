class CarModel{
  List<String> images;
  List<String> like;
  List<String> disLike;
  List<String> favorite;
  String brand;
  String model;
  String price;
  String description;
  String uid;
  String id;

  CarModel({this.id, this.uid, this.images, this.brand, this.model, this.price, this.description,
    this.like, this.disLike, this.favorite});

  factory CarModel.fromMap(Map<String, dynamic> map, {String id}) => CarModel(
    id: id,
    uid: map["uid"],
    brand: map["brand"],
    model: map["model"],
    price: map["price"],
    description: map["description"],
    images: map["images"].map<String>((i) => i as String).toList(),
    like: map["like"] == null ? [] : map["like"].map<String>((i) => i as String).toList(),
    disLike:map["disLike"] == null ? [] : map["disLike"].map<String>((i) => i as String).toList(),
    favorite:map["favorite"] == null ? [] : map["favorite"].map<String>((i) => i as String).toList(),

  );

  Map<String, dynamic> toMap(){
  return {
    "images" : images,
    "brand" : brand,
    "model" : model,
    "price" : price,
    "description" : description,
    "uid" : uid,
    "like" : like,
    "disLike" : disLike,
    "favorite" : favorite,
    };
  }

}
