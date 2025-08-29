class WalletDetailModel {
  final String attachBank;
  final Balance balance;
  final bool accountComplete;

  WalletDetailModel({
    required this.attachBank,
    required this.balance,
    required this.accountComplete,
  });

  factory WalletDetailModel.fromJson(Map<String, dynamic> json) {
    return WalletDetailModel(
      attachBank: json['attach_bank'] ?? '',
      balance: Balance.fromJson(json['balance'] ?? {}),
      accountComplete: json['account_complete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attach_bank': attachBank,
      'balance': balance.toJson(),
    };
  }
}

class Balance {
  final num available;
  final num locked;
  final num refund;

  Balance({
    required this.available,
    required this.locked,
    required this.refund,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      available: json['available'] ?? 0,
      locked: json['locked'] ?? 0,
      refund: json['refund'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'locked': locked,
      'refund': refund,
    };
  }
}
