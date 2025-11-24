// * Dibantu oleh https://quicktype.io/

// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  int itemId;
  String name;
  String description;
  String supplier;
  int weight;
  int stock;
  String receivedAt;

  Item({
    required this.itemId,
    required this.name,
    required this.description,
    required this.supplier,
    required this.weight,
    required this.stock,
    required this.receivedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemId: json["item_id"],
    name: json["name"],
    description: json["description"],
    supplier: json["supplier"],
    weight: json["weight"],
    stock: json["stock"],
    receivedAt: json["received_at"],
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "name": name,
    "description": description,
    "supplier": supplier,
    "weight": weight,
    "stock": stock,
    "received_at": receivedAt,
  };
}
