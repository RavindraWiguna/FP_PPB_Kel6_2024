class WalletFields {
  static final List<String> values = [
    /// Add all fields
    userId,
    walletId,
    currentBalance,
    totalIncome,
    created,
    lastModified
  ];

  static final String userId = 'userId';
  static final String walletId = 'walletId';
  static final String currentBalance = 'currentBalance';
  static final String totalIncome = 'totalIncome';
  static final String created = 'created';
  static final String lastModified = 'lastModified';
}

class Wallet {

  String userId;
  String walletId;
  int currentBalance; // Assuming total balance is stored as an integer for consistency with 'amount' in 'Expense'
  int totalIncome;
  DateTime created;
  DateTime lastModified;

  Wallet({
    required this.userId,
    required this.walletId,
    required this.currentBalance,
    required this.totalIncome,
    required this.created,
    required this.lastModified,
  });

  Wallet copy({
    String? userId,
    String? walletId,
    int? currentBalance,
    int? totalIncome,
    DateTime? created,
    DateTime? lastModified,
  }) =>
      Wallet(
        userId: userId ?? this.userId,
        walletId: walletId ?? this.walletId,
        currentBalance: currentBalance ?? this.currentBalance,
        totalIncome: totalIncome ?? this.totalIncome,
        created: created ?? this.created,
        lastModified: lastModified ?? this.lastModified,
      );

  static final empty = Wallet(
    userId: '',
    walletId: '',
    currentBalance: 0,
    totalIncome: 0,
    created: DateTime.now(),
    lastModified: DateTime.now(),
  );

  Map<String, Object?> toJson(bool includeId) {
    Map<String, Object?> myJson = {
      WalletFields.userId: userId,
      WalletFields.currentBalance: currentBalance,
      WalletFields.totalIncome: totalIncome,
      WalletFields.created: created.toIso8601String(),
      WalletFields.lastModified: lastModified.toIso8601String(),
    };
    if (includeId) {
      myJson[WalletFields.walletId] = walletId;
    }
    return myJson;
  }

  static Wallet fromDynamic(dynamic json) => Wallet(
    userId: json[WalletFields.userId] as String,
    walletId: json[WalletFields.walletId] as String,
    currentBalance: json[WalletFields.currentBalance] as int,
    totalIncome: json[WalletFields.totalIncome] as int,
    // totalIncome: int.parse(json[WalletFields.totalIncome] ?? "0"),
    created: DateTime.parse(json[WalletFields.created] as String),
    lastModified: DateTime.parse(json[WalletFields.lastModified] as String),
  );
}
