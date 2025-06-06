+import 'package:flutter/material.dart';
+import 'models.dart';
+import 'storage_service.dart';
+import 'financial_tips.dart';
+
+void main() {
+  runApp(const BudgetTrackerApp());
+}
+
+class BudgetTrackerApp extends StatelessWidget {
+  const BudgetTrackerApp({super.key});
+
+  @override
+  Widget build(BuildContext context) {
+    return MaterialApp(
+      title: 'Budget Tracker',
+      theme: ThemeData(primarySwatch: Colors.green),
+      home: const DashboardPage(),
+    );
+  }
+}
+
+class DashboardPage extends StatefulWidget {
+  const DashboardPage({super.key});
+
+  @override
+  State<DashboardPage> createState() => _DashboardPageState();
+}
+
+class _DashboardPageState extends State<DashboardPage> {
+  int _currentIndex = 0;
+  final List<Widget> _pages = [
+    const OverviewPage(),
+    const TransactionsPage(),
+    const SavingsGoalsPage(),
+    const TipsPage(),
+    const SettingsPage(),
+  ];
+
+  @override
+  Widget build(BuildContext context) {
+    return Scaffold(
+      appBar: AppBar(title: const Text('Budget Tracker')),
+      body: _pages[_currentIndex],
+      bottomNavigationBar: BottomNavigationBar(
+        currentIndex: _currentIndex,
+        onTap: (index) => setState(() => _currentIndex = index),
+        items: const [
+          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Overview'),
+          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transactions'),
+          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Savings'),
+          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Tips'),
+          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
+        ],
+      ),
+    );
+  }
+}
+
+class OverviewPage extends StatelessWidget {
+  const OverviewPage({super.key});
+
+  @override
+  Widget build(BuildContext context) {
+    return Center(
+      child: Column(
+        mainAxisAlignment: MainAxisAlignment.center,
+        children: const [
+          Text('Monthly Spending Charts'),
+          SizedBox(height: 20),
+          Text('Budget Alerts will appear here'),
+        ],
+      ),
+    );
+  }
+}
+
+class TransactionsPage extends StatefulWidget {
+  const TransactionsPage({super.key});
+
+  @override
+  State<TransactionsPage> createState() => _TransactionsPageState();
+}
+
+class _TransactionsPageState extends State<TransactionsPage> {
+  final _storage = StorageService();
+  List<Transaction> _transactions = [];
+
+  @override
+  void initState() {
+    super.initState();
+    _load();
+  }
+
+  Future<void> _load() async {
+    final data = await _storage.loadTransactions();
+    setState(() => _transactions = data);
+  }
+
+  Future<void> _addTransaction() async {
+    final amountController = TextEditingController();
+    final noteController = TextEditingController();
+    String category = 'General';
+    final categories = await _storage.loadCategories();
+    await showDialog(
+      context: context,
+      builder: (context) => AlertDialog(
+        title: const Text('Add Transaction'),
+        content: Column(
+          mainAxisSize: MainAxisSize.min,
+          children: [
+            TextField(
+              controller: amountController,
+              decoration: const InputDecoration(labelText: 'Amount'),
+              keyboardType: TextInputType.number,
+            ),
+            DropdownButton<String>(
+              value: category,
+              onChanged: (v) => setState(() => category = v!),
+              items: [
+                const DropdownMenuItem(value: 'General', child: Text('General')),
+                ...categories
+                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
+                    .toList(),
+              ],
+            ),
+            TextField(
+              controller: noteController,
+              decoration: const InputDecoration(labelText: 'Note'),
+            ),
+          ],
+        ),
+        actions: [
+          TextButton(
+            onPressed: () => Navigator.pop(context),
+            child: const Text('Cancel'),
+          ),
+          ElevatedButton(
+            onPressed: () {
+              final tx = Transaction(
+                id: DateTime.now().millisecondsSinceEpoch.toString(),
+                category: category,
+                amount: double.tryParse(amountController.text) ?? 0,
+                date: DateTime.now(),
+                note: noteController.text,
+              );
+              setState(() => _transactions.add(tx));
+              _storage.saveTransactions(_transactions);
+              Navigator.pop(context);
+            },
+            child: const Text('Add'),
+          )
+        ],
+      ),
+    );
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    return Scaffold(
+      body: ListView(
+        children: _transactions
+            .map((t) => ListTile(
+                  title: Text('${t.amount.toStringAsFixed(2)} - ${t.category}'),
+                  subtitle: Text(t.note),
+                ))
+            .toList(),
+      ),
+      floatingActionButton: FloatingActionButton(
+        onPressed: _addTransaction,
+        child: const Icon(Icons.add),
+      ),
+    );
+  }
+}
+
+class SavingsGoalsPage extends StatefulWidget {
+  const SavingsGoalsPage({super.key});
+
+  @override
+  State<SavingsGoalsPage> createState() => _SavingsGoalsPageState();
+}
+
+class _SavingsGoalsPageState extends State<SavingsGoalsPage> {
+  final _storage = StorageService();
+  List<SavingsGoal> _goals = [];
+
+  @override
+  void initState() {
+    super.initState();
+    _load();
+  }
+
+  Future<void> _load() async {
+    final data = await _storage.loadGoals();
+    setState(() => _goals = data);
+  }
+
+  Future<void> _addGoal() async {
+    final nameController = TextEditingController();
+    final targetController = TextEditingController();
+    await showDialog(
+      context: context,
+      builder: (context) => AlertDialog(
+        title: const Text('Add Savings Goal'),
+        content: Column(
+          mainAxisSize: MainAxisSize.min,
+          children: [
+            TextField(
+              controller: nameController,
+              decoration: const InputDecoration(labelText: 'Name'),
+            ),
+            TextField(
+              controller: targetController,
+              decoration: const InputDecoration(labelText: 'Target Amount'),
+              keyboardType: TextInputType.number,
+            ),
+          ],
+        ),
+        actions: [
+          TextButton(
+            onPressed: () => Navigator.pop(context),
+            child: const Text('Cancel'),
+          ),
+          ElevatedButton(
+            onPressed: () {
+              final goal = SavingsGoal(
+                id: DateTime.now().millisecondsSinceEpoch.toString(),
+                name: nameController.text,
+                targetAmount: double.tryParse(targetController.text) ?? 0,
+              );
+              setState(() => _goals.add(goal));
+              _storage.saveGoals(_goals);
+              Navigator.pop(context);
+            },
+            child: const Text('Add'),
+          ),
+        ],
+      ),
+    );
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    return Scaffold(
+      body: ListView(
+        children: _goals
+            .map((g) => ListTile(
+                  title: Text(g.name),
+                  subtitle: Text('Target: ${g.targetAmount.toStringAsFixed(2)}'),
+                ))
+            .toList(),
+      ),
+      floatingActionButton: FloatingActionButton(
+        onPressed: _addGoal,
+        child: const Icon(Icons.add),
+      ),
+    );
+  }
+}
+
+class SettingsPage extends StatefulWidget {
+  const SettingsPage({super.key});
+
+  @override
+  State<SettingsPage> createState() => _SettingsPageState();
+}
+
+class _SettingsPageState extends State<SettingsPage> {
+  final _formKey = GlobalKey<FormState>();
+  final _storage = StorageService();
+  UserProfile _profile = UserProfile();
+  final TextEditingController _nameController = TextEditingController();
+  final TextEditingController _currencyController = TextEditingController();
+  final TextEditingController _newCategoryController = TextEditingController();
+  List<String> _categories = [];
+
+  @override
+  void initState() {
+    super.initState();
+    _loadProfile();
+  }
+
+  Future<void> _loadProfile() async {
+    final profile = await _storage.loadUserProfile();
+    final categories = await _storage.loadCategories();
+    setState(() {
+      _profile = profile;
+      _nameController.text = profile.name;
+      _currencyController.text = profile.currency;
+      _categories = categories;
+    });
+  }
+
+  Future<void> _saveProfile() async {
+    if (_formKey.currentState!.validate()) {
+      final profile = UserProfile(
+        name: _nameController.text,
+        currency: _currencyController.text,
+      );
+      await _storage.saveUserProfile(profile);
+      await _storage.saveCategories(_categories);
+      ScaffoldMessenger.of(context)
+          .showSnackBar(const SnackBar(content: Text('Profile saved')));
+    }
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    return Scaffold(
+      body: Padding(
+        padding: const EdgeInsets.all(16.0),
+        child: Form(
+          key: _formKey,
+          child: Column(
+            children: [
+              TextFormField(
+                controller: _nameController,
+                decoration: const InputDecoration(labelText: 'Name'),
+              ),
+              TextFormField(
+                controller: _currencyController,
+                decoration: const InputDecoration(labelText: 'Preferred Currency'),
+              ),
+              const SizedBox(height: 20),
+              Row(
+                children: [
+                  Expanded(
+                    child: TextFormField(
+                      controller: _newCategoryController,
+                      decoration: const InputDecoration(labelText: 'Add Category'),
+                    ),
+                  ),
+                  IconButton(
+                    icon: const Icon(Icons.add),
+                    onPressed: () {
+                      setState(() {
+                        if (_newCategoryController.text.isNotEmpty) {
+                          _categories.add(_newCategoryController.text);
+                          _newCategoryController.clear();
+                        }
+                      });
+                    },
+                  )
+                ],
+              ),
+              Wrap(
+                spacing: 8,
+                children: _categories
+                    .map(
+                      (c) => Chip(
+                        label: Text(c),
+                        onDeleted: () => setState(() => _categories.remove(c)),
+                      ),
+                    )
+                    .toList(),
+              ),
+              const SizedBox(height: 20),
+              ElevatedButton(
+                onPressed: _saveProfile,
+                child: const Text('Save'),
+              ),
+            ],
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+class TipsPage extends StatelessWidget {
+  const TipsPage({super.key});
+
+  @override
+  Widget build(BuildContext context) {
+    return Scaffold(
+      body: ListView(
+        padding: const EdgeInsets.all(16),
+        children: financialTips
+            .map((tip) => ListTile(leading: const Icon(Icons.check), title: Text(tip)))
+            .toList(),
+      ),
+    );
+  }
+}
 
