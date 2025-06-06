+import 'dart:convert';
+import 'package:shared_preferences/shared_preferences.dart';
+import 'models.dart';
+
+class StorageService {
+  static const _transactionsKey = 'transactions';
+  static const _goalsKey = 'goals';
+  static const _profileKey = 'profile';
+  static const _categoriesKey = 'categories';
+
+  Future<void> saveTransactions(List<Transaction> transactions) async {
+    final prefs = await SharedPreferences.getInstance();
+    final data = transactions.map((t) => jsonEncode(t.toJson())).toList();
+    await prefs.setStringList(_transactionsKey, data);
+  }
+
+  Future<List<Transaction>> loadTransactions() async {
+    final prefs = await SharedPreferences.getInstance();
+    final data = prefs.getStringList(_transactionsKey) ?? [];
+    return data
+        .map((e) => Transaction.fromJson(jsonDecode(e) as Map<String, dynamic>))
+        .toList();
+  }
+
+  Future<void> saveGoals(List<SavingsGoal> goals) async {
+    final prefs = await SharedPreferences.getInstance();
+    final data = goals.map((g) => jsonEncode(g.toJson())).toList();
+    await prefs.setStringList(_goalsKey, data);
+  }
+
+  Future<List<SavingsGoal>> loadGoals() async {
+    final prefs = await SharedPreferences.getInstance();
+    final data = prefs.getStringList(_goalsKey) ?? [];
+    return data
+        .map((e) => SavingsGoal.fromJson(jsonDecode(e) as Map<String, dynamic>))
+        .toList();
+  }
+
+  Future<void> saveUserProfile(UserProfile profile) async {
+    final prefs = await SharedPreferences.getInstance();
+    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
+  }
+
+  Future<UserProfile> loadUserProfile() async {
+    final prefs = await SharedPreferences.getInstance();
+    final json = prefs.getString(_profileKey);
+    if (json == null) return UserProfile();
+    return UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
+  }
+
+  Future<void> saveCategories(List<String> categories) async {
+    final prefs = await SharedPreferences.getInstance();
+    await prefs.setStringList(_categoriesKey, categories);
+  }
+
+  Future<List<String>> loadCategories() async {
+    final prefs = await SharedPreferences.getInstance();
+    return prefs.getStringList(_categoriesKey) ?? [];
+  }
+}
 
EOF
)
