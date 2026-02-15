import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coding_test/presentation/stock/stock_provider.dart';
import 'package:provider/provider.dart';

class StockView extends StatelessWidget {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StockProvider>();
    return DefaultTabController(
      length: provider.sectionTitles.length,
      child: Scaffold(
        appBar: const StockAppBarView(),
        body: ListView(
          children: const [
            StockPriceView(),
          ],
        ),
      ),
    );
  }
}

class StockAppBarView extends StatelessWidget implements PreferredSizeWidget {
  const StockAppBarView({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StockProvider>();
    return AppBar(
      title: const Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue,
            child: Text('삼', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('삼성전자', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('005930', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
      bottom: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: provider.sectionTitles.map((title) => Tab(text: title)).toList(),
        onTap: (index) {
          // TODO(youngjin.kim): 해당 섹션으로 스크롤 이동
        },
      ),
    );
  }
}

class StockPriceView extends StatelessWidget {
  const StockPriceView();

  static const _mockSpots = [
    FlSpot(0, 71000),
    FlSpot(1, 71500),
    FlSpot(2, 70800),
    FlSpot(3, 72000),
    FlSpot(4, 71200),
    FlSpot(5, 72500),
    FlSpot(6, 73000),
    FlSpot(7, 72800),
    FlSpot(8, 73500),
    FlSpot(9, 72500),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '가격',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '72,500',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              Text(
                '원',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(width: 12),
              Text(
                '+1.25%',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _mockSpots,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withAlpha(30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
