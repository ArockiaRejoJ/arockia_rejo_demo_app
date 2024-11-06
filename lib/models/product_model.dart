import 'dart:convert';
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  int id;
  String title;
  int price;
  String description;
  List<String> images;
  DateTime creationAt;
  DateTime updatedAt;
  Category category;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Check if the "images" field is a String and contains extra characters
    var imagesData = json["images"];
    List<String> imagesList = [];

    if (imagesData is String) {
      // Remove unwanted characters like "[" "]" and "\" from the string
      String cleanedImages = imagesData.replaceAll(RegExp(r'[\\\[\]"]'), '');
      imagesList = List<String>.from(cleanedImages.split(','));
    } else if (imagesData is List) {
      // If images data is already in list format
      imagesList = List<String>.from(imagesData.map((x) => x));
    }

    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"],
      description: json["description"],
      images: imagesList, // Use the cleaned images list
      creationAt: DateTime.parse(json["creationAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      category: Category.fromJson(json["category"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "images": List<dynamic>.from(images.map((x) => x)),
    "creationAt": creationAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "category": category.toJson(),
  };
}

class Category {
  int id;
  Name name;
  String image;
  DateTime creationAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: nameValues.map[json["name"]]!,
    image: json["image"],
    creationAt: DateTime.parse(json["creationAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "image": image,
    "creationAt": creationAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

enum Name { CHANGE_TITLE, CLOTHES, ELECTRONICS, MISCELLANEOUS, SHOES }

final nameValues = EnumValues({
  "Change title": Name.CHANGE_TITLE,
  "Clothes": Name.CLOTHES,
  "Electronics": Name.ELECTRONICS,
  "Miscellaneous": Name.MISCELLANEOUS,
  "Shoes": Name.SHOES
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
