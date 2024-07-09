class Sales {
  final String id;
  final String buyer;
  final String phone;
  final String date;
  final String status;
  final int createdAt;
  final int updatedAt;
  final dynamic issuer;

  Sales(
      {required this.id,
      required this.buyer,
      required this.phone,
      required this.date,
      this.issuer,
      required this.createdAt,
      required this.updatedAt,
      required this.status});

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      id: json['id'],
      buyer: json['buyer'],
      phone: json['phone'],
      date: json['date'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      issuer: json['issuer'],
    );
  }
}
