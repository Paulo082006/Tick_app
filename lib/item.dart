// lib/item.dart
class Item {
  String name;
  double price;
  int quantity;
  bool isCompleted;

  Item({
    required this.name,
    required this.price,
    this.quantity = 1,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'isCompleted': isCompleted,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'] as double,
      quantity: json['quantity'] as int,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}