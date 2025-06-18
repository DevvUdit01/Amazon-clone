import 'dart:convert';

import 'package:amazon_clone_flutter/models/rating.dart';

class Product {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final List<String> images;
  final String category;
  final String? id;
  final List<Rating>? rating;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.images,
    required this.category,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'images': images,
      'category': category,
      '_id': id, // match backend if it uses "_id"
      'rating': rating?.map((r) => r.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      id: map['_id'] ?? map['id'], // support both _id and id
      rating: map['rating'] != null
          ? List<Rating>.from(
              (map['rating'] as List).map((x) => Rating.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  Product copyWith({
  String? name,
  String? description,
  double? price,
  int? quantity,
  List<String>? images,
  String? category,
  String? id,
  List<Rating>? rating,
}) {
  return Product(
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    quantity: quantity ?? this.quantity,
    images: images ?? this.images,
    category: category ?? this.category,
    id: id ?? this.id,
    rating: rating ?? this.rating,
  );
}

}
