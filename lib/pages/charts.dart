import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class IssuePieChart extends StatelessWidget {
  final int issuesCompleted;
  final int issuesRemaining;

  IssuePieChart({
    required this.issuesCompleted,
    required this.issuesRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Issues", style:
                  TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,)),
                  _buildLegendItem(
                    color: Colors.green,
                    label: "Completed",
                  ),
                  const SizedBox(height: 8),
                  _buildLegendItem(
                    color: Colors.red,
                    label: "Remaining",
                  ),
                ],
              ),
            ),
            SizedBox(width: 0),

            Card(
              color: Colors.green.shade100,
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: PieChart(
                    PieChartData(
                      sections: _buildPieChartSections(),
                      centerSpaceRadius: 30,
                      sectionsSpace: 2,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
            ),
            //const SizedBox(width: 16),

          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final totalIssues = issuesCompleted + issuesRemaining;

    final completedPercentage = (issuesCompleted / totalIssues) * 100;
    final remainingPercentage = (issuesRemaining / totalIssues) * 100;

    return [
      PieChartSectionData(
        color: Colors.green,
        value: completedPercentage,
        title: '${completedPercentage.toStringAsFixed(1)}%',
        radius: 35,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: remainingPercentage,
        title: '${remainingPercentage.toStringAsFixed(1)}%',
        radius: 35,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}