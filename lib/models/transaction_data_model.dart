class TransactionDataModel {
  final int id;
  final num amount;
  final String type;
  final String status;
  final DateTime createdAt;

  TransactionDataModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory TransactionDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionDataModel(
      id: json['id'] as int,
      amount: json['amount'] as num,
      type: json['type'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'type': type,
        'status': status,
        'created_at': createdAt.toIso8601String(),
      };
}
