class Product {
  final String id;
  final String name;
  final num price;
  final String attr;
  final num qty;
  final num weight;
  final int createdAt;
  final int updatedAt;
  final dynamic issuer;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.attr,
      required this.qty,
      this.issuer,
      required this.createdAt,
      required this.updatedAt,
      required this.weight});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      attr: json['attr'],
      qty: json['qty'],
      weight: json['weight'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      issuer: json['issuer'],
    );
  }
}
