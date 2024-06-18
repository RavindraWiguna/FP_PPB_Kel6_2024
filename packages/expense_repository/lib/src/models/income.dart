import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeFields {
  static final List<String> values = [
    /// Add all fields
    userId,
    // expenseId, // probably ga ke pake tho
    // category,
    description,
    date,
    amount,
    created,
    lastModified
  ];

  static final String userId = 'userId';
  // static final String expenseId = 'expenseId';
  static final String description = 'description';
  // static final String category = 'category';
  static final String date = 'date';
  static final String amount = 'amount';
  static final String created = 'created'; // when is added/last modified
  static final String lastModified = 'lastModified';
}

class Income {

  String userId;
  // String expenseId;
  //String category;
  String description;
  DateTime date;
  int amount; // 2^63 ish ~10^18 ish should be aman
  DateTime created;
  DateTime lastModified;


  Income({
    required this.userId,
    // required this.expenseId,
    //required this.category,
    required this.description,
    required this.date,
    required this.amount,
    required this.created,
    required this.lastModified,
  });

  Income copy({
    String? userId,
    // String? expenseId,
    String? category,
    String? description,
    DateTime? date,
    int? amount,
    DateTime? created,
    DateTime? lastModified,
  }) =>
      Income(
          userId: userId?? this.userId,
          // expenseId: expenseId ?? this.expenseId,
          //category: category ?? this.category,
          description: description?? this.description,
          date: date ?? this.date,
          amount: amount?? this.amount,
          created: created?? this.created,
          lastModified: lastModified?? this.lastModified
      );

  static final empty = Income(
      userId: '',
      // expenseId: '',
      //category: '',
      description: '',
      date: DateTime.now(),
      amount: 0,
      created: DateTime.now(),
      lastModified: DateTime.now()
  );

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      userId: json['userId'],
      description: json['description'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      created: DateTime.parse(json['created']),
      lastModified: DateTime.parse(json['LastModified']),
    );
  }

  // so all is string
  Map<String, Object?> toJson(){
    Map<String, Object?> myJson = {
      IncomeFields.userId: userId,
      // ExpenseFields.category: category,
      IncomeFields.description: description,
      IncomeFields.date: date.toIso8601String(),
      IncomeFields.amount: amount,
      IncomeFields.created: created.toIso8601String(),
      IncomeFields.lastModified: lastModified.toIso8601String(),
    };
    // if(includeId){
      // myJson[IncomeFields.expenseId]=expenseId;// i think i don't need to return this no?
    // }
    return myJson;
  }

  static Income fromDynamic(dynamic json) => Income(
    userId: json[IncomeFields.userId] as String,
    // expenseId: json[IncomeFields.expenseId] as String, // i guess u still need it
    // category: json[IncomeFields.category] as String,
    description: json[IncomeFields.description] as String,
    date: DateTime.parse(json[IncomeFields.date] as String),
    amount: json[IncomeFields.amount] as int,
    created: DateTime.parse(json[IncomeFields.created] as String),
    lastModified: DateTime.parse(json[IncomeFields.lastModified] as String),
  );


}