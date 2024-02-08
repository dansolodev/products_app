import 'dart:convert';

class Product {
  String? id;
  bool available;
  String? image;
  String name;
  double price;

  Product({
    this.id,
    required this.available,
    this.image,
    required this.name,
    required this.price,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        available: json["available"],
        image: json["image"],
        name: json["name"],
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "available": available,
        "image": image,
        "name": name,
        "price": price,
      };

  Product copy() => Product(
        available: available,
        name: name,
        price: price,
        image: image,
        id: id,
      );
}
