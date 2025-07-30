import 'package:expense_tracker/screens/dashboard/bloc/spending_chart_bloc/spending_bloc.dart';
import 'package:expense_tracker/screens/dashboard/bloc/spending_chart_bloc/spending_event.dart';
import 'package:expense_tracker/screens/dashboard/bloc/spending_chart_bloc/spending_state.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';
import '../models/expense_data.dart';

class SpendingTrendsChart extends StatelessWidget {
  const SpendingTrendsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpendingBloc()..add(SpendingChartDataEvent()),
      child: BlocBuilder<SpendingBloc, SpendingState>(
        builder: (context, state) {
          bool isLoading = state is SpendingLoadingState;
          if (state is SpendingLoadingState) {
            return Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Chart area placeholder
                  Expanded(
                    child:
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              // Simulate chart lines
                              Positioned(
                                left: 20,
                                top: 40,
                                right: 20,
                                child: Container(
                                  height: 2,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Positioned(
                                left: 20,
                                top: 80,
                                right: 20,
                                child: Container(
                                  height: 2,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Positioned(
                                left: 20,
                                top: 120,
                                right: 20,
                                child: Container(
                                  height: 2,
                                  color: Colors.grey[400],
                                ),
                              ),
                              // Simulate chart curve
                              Positioned(
                                left: 30,
                                bottom: 30,
                                child: Row(
                                  children: List.generate(
                                    6,
                                    (index) => Container(
                                      width: 8,
                                      height: 8,
                                      margin: EdgeInsets.only(right: 25),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[500],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).redacted(
                          context: context,
                          redact: isLoading,
                          configuration: RedactedConfiguration(
                            redactedColor: Colors.grey[60],
                            defaultBorderRadius: BorderRadius.circular(8),
                          ),
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Bottom labels placeholder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      6,
                      (index) =>
                          Container(
                            width: 30,
                            height: 12,
                            color: Colors.grey[300],
                          ).redacted(
                            context: context,
                            redact: isLoading,
                            configuration: RedactedConfiguration(
                              redactedColor: Colors.grey[60],
                              defaultBorderRadius: BorderRadius.circular(2),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is SpendingLoadedState) {
            final chartData = state.chartData;
            if (chartData.isEmpty) {
              return SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Data will not get to the ui. chartData will be empty.",
                  ),
                ),
              );
            }
            return BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, currencyState) {
                String currencySymbol = '₹';
                if (currencyState is CurrencyLoaded) {
                  currencySymbol = currencyState.currentCurrency.symbol;
                }
                
                return Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: _getChartWidth(chartData),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 500,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[300]!,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return _bottomTitleWidgets(value, chartData);
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: (chartData.length - 1).toDouble(),
                          minY: 0,
                          maxY: _getMaxY(chartData),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                return touchedBarSpots.map((barSpot) {
                                  final flSpot = barSpot;
                                  final index = flSpot.x.toInt();
                                  if (index >= 0 && index < chartData.length) {
                                    return LineTooltipItem(
                                      '${chartData[index].day}\n$currencySymbol${flSpot.y.toStringAsFixed(0)}',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                  return null;
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartData.asMap().entries.map((entry) {
                                return FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.amount,
                                );
                              }).toList(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.blue,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ).redacted(
            context: context,
            redact: isLoading,
            configuration: RedactedConfiguration(
              redactedColor: Colors.grey[60],
              defaultBorderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, List<MonthlyData> data) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    int index = value.toInt();
    if (index >= 0 && index < data.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(data[index].day, style: style),
      );
    }
    return const SizedBox.shrink();
  }

  double _getMaxY(List<MonthlyData> data) {
    if (data.isEmpty) return 1000;
    final max = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    return ((max / 500).ceil() + 1) * 500;
  }

  double _getChartWidth(List<MonthlyData> data) {
    // Calculate width based on data points
    // Minimum width to ensure chart is scrollable
    const double minWidth = 500;
    // Width per data point to ensure adequate spacing
    const double widthPerPoint = 50;

    double calculatedWidth = data.length * widthPerPoint;
    return calculatedWidth > minWidth ? calculatedWidth : minWidth;
  }
}
