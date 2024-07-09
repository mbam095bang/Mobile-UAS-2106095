class Stock {
  final String id;
  final String name;
  final num qty;
  final String attr;
  final num weight;
  final int createdAt;
  final int updatedAt;
  final dynamic issuer;

  Stock(
      {required this.id,
      required this.name,
      required this.attr,
      required this.qty,
      this.issuer,
      required this.createdAt,
      required this.updatedAt,
      required this.weight});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      name: json['name'],
      attr: json['attr'],
      qty: json['qty'],
      weight: json['weight'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      issuer: json['issuer'],
    );
  }
}
