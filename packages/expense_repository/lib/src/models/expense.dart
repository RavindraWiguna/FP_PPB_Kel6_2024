class ExpenseFields {
  static final List<String> values = [
    /// Add all fields
    userId,
    expenseId,
    category,
    date,
    amount,
    created,
    lastModified
  ];

  static final String userId = 'userId';
  static final String expenseId = 'expenseId';
  static final String category = 'category';
  static final String date = 'date';
  static final String amount = 'amount';
  static final String created = 'created'; // when is added/last modified
  static final String lastModified = 'lastModified';
}

class Expense {

  String userId;
  String expenseId;
  String category;
  DateTime date;
  int amount; // 2^63 ish ~10^18 ish should be aman
  DateTime created;
  DateTime lastModified;


  Expense({
    required this.userId,
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
    required this.created,
    required this.lastModified,
  });

  Expense copy({
    String? userId,
    String? expenseId,
    String? category,
    DateTime? date,
    int? amount,
    DateTime? created,
    DateTime? lastModified,
  }) =>
      Expense(
        userId: userId?? this.userId,
        expenseId: expenseId ?? this.expenseId,
        category: category ?? this.category,
        date: date ?? this.date,
        amount: amount?? this.amount,
        created: created?? this.created,
        lastModified: lastModified?? this.lastModified
      );

  static final empty = Expense(
    userId: '',
    expenseId: '',
    category: '',
    date: DateTime.now(),
    amount: 0,
    created: DateTime.now(),
    lastModified: DateTime.now()
  );

  // so all is string
  Map<String, Object?> toJson(bool includeId){
    Map<String, Object?> myJson = {
      ExpenseFields.userId: userId,
      ExpenseFields.category: category,
      ExpenseFields.date: date.toIso8601String(),
      ExpenseFields.amount: amount,
      ExpenseFields.created: created.toIso8601String(),
      ExpenseFields.lastModified: lastModified.toIso8601String(),
    };
    if(includeId){
      myJson[ExpenseFields.expenseId]=expenseId;// i think i don't need to return this no?
    }
    return myJson;
  }

  static Expense fromJson(Map<String, Object?> json) => Expense(
    userId: json[ExpenseFields.userId] as String,
    expenseId: json[ExpenseFields.expenseId] as String, // i guess u still need it
    category: json[ExpenseFields.category] as String,
    date: DateTime.parse(json[ExpenseFields.date] as String),
    amount: json[ExpenseFields.amount] as int,
    created: DateTime.parse(json[ExpenseFields.created] as String),
    lastModified: DateTime.parse(json[ExpenseFields.lastModified] as String),
  );


}