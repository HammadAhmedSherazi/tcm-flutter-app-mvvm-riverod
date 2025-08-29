class CardDataModel {
  late final String id;
  late final String brand;
  late final String expMonth;
  late final String expYear;
  late final String last4;
  late final String fingerPrint;

  CardDataModel({
    required this.id,
    required this.brand,
    required this.expMonth,
    required this.expYear,
    required this.last4,
    required this.fingerPrint
  });

  // Factory constructor to create an instance from JSON
  factory CardDataModel.fromJson(Map<String, dynamic> json) {
    return CardDataModel(
      id: json['id'] ?? "", // Default value of 0 if null
      brand: json['brand'] ?? '',
      expMonth: json['exp_month']?.toString() ?? '',
      expYear: json['exp_year']?.toString() ?? '',
      last4: json['last4'] ?? '',
      fingerPrint: json['fingerprint'] ?? ''
    );
  }
}