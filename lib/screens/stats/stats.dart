import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  int _getAmount(Map<String, dynamic> data) {
    final value = data['amount'];

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();

    return 0;
  }

  DateTime? _getDate(Map<String, dynamic> data) {
    final value = data['date'];

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  Map<int, int> _buildDailyTotal(List<QueryDocumentSnapshot> docs) {
    final Map<int, int> dailyTotal = {};

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final date = _getDate(data);
      final amount = _getAmount(data);

      if (date == null) continue;

      dailyTotal[date.day] = (dailyTotal[date.day] ?? 0) + amount;
    }

    return dailyTotal;
  }

  int _getTotalExpense(List<QueryDocumentSnapshot> docs) {
    int total = 0;

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += _getAmount(data);
    }

    return total;
  }

  String _formatMoney(int value) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 0,
  ).format(value);
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Không thể tải dữ liệu thống kê'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          final dailyTotal = _buildDailyTotal(docs);
          final totalExpense = _getTotalExpense(docs);

          final days = dailyTotal.keys.toList()..sort();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thống kê chi tiêu",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổng chi tiêu',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatMoney(totalExpense),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${docs.length} giao dịch',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  height: 360,
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: docs.isEmpty
                      ? const Center(
                          child: Text('Chưa có dữ liệu chi tiêu'),
                        )
                      : BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: dailyTotal.values.isEmpty
                                ? 100000
                                : dailyTotal.values
                                        .reduce((a, b) => a > b ? a : b)
                                        .toDouble() *
                                    1.25,
                            minY: 0,
                            gridData: const FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 55,
                                  getTitlesWidget: (value, meta) {
                                    if (value == 0) {
                                      return const SizedBox.shrink();
                                    }

                                    return Text(
                                      '${(value / 1000).round()}K',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();

                                    if (index < 0 || index >= days.length) {
                                      return const SizedBox.shrink();
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        days[index].toString().padLeft(2, '0'),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            barGroups: List.generate(days.length, (index) {
                              final day = days[index];
                              final amount = dailyTotal[day] ?? 0;

                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: amount.toDouble(),
                                    width: 18,
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xFFFF8A65),
                                        Color(0xFFE040FB),
                                        Color(0xFF00BCD4),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Giao dịch gần đây',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ...docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final amount = _getAmount(data);
                  final date = _getDate(data);
                  final category =
                      data['category'] as Map<String, dynamic>? ?? {};

                  final categoryName =
                      category['name']?.toString() ?? 'Không có danh mục';
                  final icon = category['icon']?.toString() ?? 'food';
                  final color = category['color'] is int
                      ? category['color'] as int
                      : 0xFFFFFFFF;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Color(color),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/$icon.png',
                        width: 34,
                        height: 34,
                      ),
                      title: Text(
                        categoryName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        date == null
                            ? 'Không có ngày'
                            : DateFormat('dd/MM/yyyy').format(date),
                      ),
                      trailing: Text(
                        _formatMoney(amount),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}