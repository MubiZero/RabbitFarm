import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/rabbit_weight_model.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/l10n/l10n_context.dart';

class WeightChart extends StatelessWidget {
  final List<RabbitWeight> weights;

  const WeightChart({super.key, required this.weights});

  @override
  Widget build(BuildContext context) {
    if (weights.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text(
            context.l10n.chartNoData,
            style: AppTypography.bodyLg
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
        ),
      );
    }

    // Sort weights by date (oldest first for chart)
    final sortedWeights = List<RabbitWeight>.from(weights)
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));

    final spots = sortedWeights.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();

    final minWeight = sortedWeights.map((w) => w.weight).reduce((a, b) => a < b ? a : b);
    final maxWeight = sortedWeights.map((w) => w.weight).reduce((a, b) => a > b ? a : b);
    final weightRange = maxWeight - minWeight;
    final minY = (minWeight - weightRange * 0.2).clamp(0.0, double.infinity);
    final maxY = maxWeight + weightRange * 0.2;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.chartWeight,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: weightRange > 0 ? weightRange / 4 : 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: context.colors.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toStringAsFixed(1)} кг',
                            style: AppTypography.labelSm
                                .copyWith(color: context.colors.onSurfaceVariant),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= sortedWeights.length) {
                            return const Text('');
                          }
                          final date = sortedWeights[index].measuredAt;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('dd.MM').format(date),
                              style: AppTypography.labelSm
                                .copyWith(color: context.colors.onSurfaceVariant),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: context.colors.outline,
                    ),
                  ),
                  minX: 0,
                  maxX: (sortedWeights.length - 1).toDouble(),
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          if (index < 0 || index >= sortedWeights.length) {
                            return null;
                          }
                          final weight = sortedWeights[index];
                          return LineTooltipItem(
                            '${weight.weight.toStringAsFixed(2)} кг\n${DateFormat('dd.MM.yyyy').format(weight.measuredAt)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
