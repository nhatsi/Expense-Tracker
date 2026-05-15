import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SeedFirebaseApp());
}

class SeedFirebaseApp extends StatefulWidget {
  const SeedFirebaseApp({super.key});

  @override
  State<SeedFirebaseApp> createState() => _SeedFirebaseAppState();
}

class _SeedFirebaseAppState extends State<SeedFirebaseApp> {
  String status = 'Đang seed dữ liệu lên Firebase...';

  @override
  void initState() {
    super.initState();
    seedFirebase();
  }

  Future<void> seedFirebase() async {
    try {
      final db = FirebaseFirestore.instance;

      final categories = [
        {
          'categoryId': 'cat_food',
          'name': 'Ăn uống',
          'totalExpenses': 0,
          'icon': 'food',
          'color': 0xFFFFE0B2,
        },
        {
          'categoryId': 'cat_shopping',
          'name': 'Mua sắm',
          'totalExpenses': 0,
          'icon': 'shopping',
          'color': 0xFFE1BEE7,
        },
        {
          'categoryId': 'cat_home',
          'name': 'Nhà cửa',
          'totalExpenses': 0,
          'icon': 'home',
          'color': 0xFFC8E6C9,
        },
        {
          'categoryId': 'cat_travel',
          'name': 'Di chuyển',
          'totalExpenses': 0,
          'icon': 'travel',
          'color': 0xFFBBDEFB,
        },
        {
          'categoryId': 'cat_entertainment',
          'name': 'Giải trí',
          'totalExpenses': 0,
          'icon': 'entertainment',
          'color': 0xFFFFCDD2,
        },
        {
          'categoryId': 'cat_pet',
          'name': 'Thú cưng',
          'totalExpenses': 0,
          'icon': 'pet',
          'color': 0xFFD7CCC8,
        },
        {
          'categoryId': 'cat_tech',
          'name': 'Công nghệ',
          'totalExpenses': 0,
          'icon': 'tech',
          'color': 0xFFCFD8DC,
        },
      ];

      final expenses = [
        {
          'expenseId': 'exp_001',
          'category': categories[0],
          'date': Timestamp.fromDate(DateTime(2026, 5, 1)),
          'amount': 45000,
        },
        {
          'expenseId': 'exp_002',
          'category': categories[0],
          'date': Timestamp.fromDate(DateTime(2026, 5, 2)),
          'amount': 75000,
        },
        {
          'expenseId': 'exp_003',
          'category': categories[1],
          'date': Timestamp.fromDate(DateTime(2026, 5, 3)),
          'amount': 250000,
        },
        {
          'expenseId': 'exp_004',
          'category': categories[2],
          'date': Timestamp.fromDate(DateTime(2026, 5, 4)),
          'amount': 120000,
        },
        {
          'expenseId': 'exp_005',
          'category': categories[3],
          'date': Timestamp.fromDate(DateTime(2026, 5, 5)),
          'amount': 30000,
        },
        {
          'expenseId': 'exp_006',
          'category': categories[4],
          'date': Timestamp.fromDate(DateTime(2026, 5, 6)),
          'amount': 90000,
        },
        {
          'expenseId': 'exp_007',
          'category': categories[6],
          'date': Timestamp.fromDate(DateTime(2026, 5, 7)),
          'amount': 350000,
        },
        {
          'expenseId': 'exp_008',
          'category': categories[5],
          'date': Timestamp.fromDate(DateTime(2026, 5, 8)),
          'amount': 60000,
        },
      ];

      final batch = db.batch();

      for (final category in categories) {
        final ref = db.collection('categories').doc(
              category['categoryId'] as String,
            );
        batch.set(ref, category);
      }

      for (final expense in expenses) {
        final ref = db.collection('expenses').doc(
              expense['expenseId'] as String,
            );
        batch.set(ref, expense);
      }

      await batch.commit();

      setState(() {
        status = 'Seed Firebase thành công. Đã tạo categories và expenses.';
      });
    } catch (e) {
      setState(() {
        status = 'Seed thất bại: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seed Firebase',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}