+class Transaction {
+  final String id;
+  final String category;
+  final double amount;
+  final DateTime date;
+  final String note;
+
+  Transaction({
+    required this.id,
+    required this.category,
+    required this.amount,
+    required this.date,
+    this.note = '',
+  });
+
+  Map<String, dynamic> toJson() => {
+        'id': id,
+        'category': category,
+        'amount': amount,
+        'date': date.toIso8601String(),
+        'note': note,
+      };
+
+  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
+        id: json['id'] as String,
+        category: json['category'] as String,
+        amount: json['amount'] as double,
+        date: DateTime.parse(json['date'] as String),
+        note: json['note'] as String? ?? '',
+      );
+}
+
+class SavingsGoal {
+  final String id;
+  final String name;
+  final double targetAmount;
+  final double currentAmount;
+
+  SavingsGoal({
+    required this.id,
+    required this.name,
+    required this.targetAmount,
+    this.currentAmount = 0,
+  });
+
+  Map<String, dynamic> toJson() => {
+        'id': id,
+        'name': name,
+        'targetAmount': targetAmount,
+        'currentAmount': currentAmount,
+      };
+
+  factory SavingsGoal.fromJson(Map<String, dynamic> json) => SavingsGoal(
+        id: json['id'] as String,
+        name: json['name'] as String,
+        targetAmount: json['targetAmount'] as double,
+        currentAmount: json['currentAmount'] as double? ?? 0,
+      );
+}
+
+class UserProfile {
+  String name;
+  String currency;
+
+  UserProfile({this.name = '', this.currency = 'USD'});
+
+  Map<String, dynamic> toJson() => {
+        'name': name,
+        'currency': currency,
+      };
+
+  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
+        name: json['name'] as String? ?? '',
+        currency: json['currency'] as String? ?? 'USD',
+      );
+}
