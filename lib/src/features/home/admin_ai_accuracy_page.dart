import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminAiAccuracyPage extends StatelessWidget {
  const AdminAiAccuracyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text("AI Accuracy Dashboard"),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📊 METRICS + CHART
            _metricsSection(),

            const SizedBox(height: 30),

            /// 📋 RECENT AI PREDICTIONS
            const Text(
              "Recent AI Predictions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _predictionList(),
          ],
        ),
      ),
    );
  }

  /// ================= METRICS + CHART =================
  Widget _metricsSection() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ai_metrics')
          .doc('summary')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null) {
          return const Text("No AI metrics available yet");
        }

        final accuracy = (data['accuracy'] ?? 0).toDouble();

        return Column(
          children: [
            Row(
              children: [
                _metricCard("Accuracy", "$accuracy%", Colors.green),
                const SizedBox(width: 12),
                _metricCard(
                  "Total",
                  "${data['totalPredictions'] ?? 0}",
                  Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 📈 AI ACCURACY CHART
            AiAccuracyChart(accuracy: accuracy),

            const SizedBox(height: 20),

            Row(
              children: [
                _metricCard(
                  "Correct",
                  "${data['correct'] ?? 0}",
                  Colors.teal,
                ),
                const SizedBox(width: 12),
                _metricCard(
                  "Incorrect",
                  "${data['incorrect'] ?? 0}",
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _metricCard(
                  "False +",
                  "${data['falsePositive'] ?? 0}",
                  Colors.orange,
                ),
                const SizedBox(width: 12),
                _metricCard(
                  "False −",
                  "${data['falseNegative'] ?? 0}",
                  Colors.purple,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _metricCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= PREDICTION LIST =================
  Widget _predictionList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ai_predictions')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No predictions found"));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            final aiLabel = data['aiLabel'];
            final doctorLabel = data['doctorLabel'];
            final isCorrect = data['isCorrect'];

            final createdAt = data['createdAt'] != null
                ? DateFormat('dd MMM • hh:mm a')
                .format((data['createdAt'] as Timestamp).toDate())
                : '';

            return ListTile(
              leading: Icon(
                isCorrect == null
                    ? Icons.hourglass_top
                    : isCorrect
                    ? Icons.check_circle
                    : Icons.cancel,
                color: isCorrect == null
                    ? Colors.grey
                    : isCorrect
                    ? Colors.green
                    : Colors.red,
              ),
              title: Text(
                "AI: $aiLabel",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                doctorLabel == null
                    ? "Doctor review pending\n$createdAt"
                    : "Doctor: $doctorLabel\n$createdAt",
              ),
              isThreeLine: true,
            );
          },
        );
      },
    );
  }
}

/// ================= AI ACCURACY BAR CHART =================
class AiAccuracyChart extends StatelessWidget {
  final double accuracy;

  const AiAccuracyChart({super.key, required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: 100,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: accuracy,
                  width: 40,
                  borderRadius: BorderRadius.circular(8),
                  color: accuracy >= 80 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
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
                reservedSize: 32,
                getTitlesWidget: (value, _) =>
                    Text("${value.toInt()}%"),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (_, __) =>
                const Text("AI Accuracy"),
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
