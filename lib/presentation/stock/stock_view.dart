import 'package:flutter/material.dart';
import 'package:flutter_coding_test/presentation/stock/stock_provider.dart';
import 'package:provider/provider.dart';

class StockView extends StatefulWidget {
  const StockView({super.key});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<StockProvider>();
    _tabController = TabController(length: provider.sectionTitles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StockProvider>();
    return Scaffold(
      appBar: AppBar(
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
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: provider.sectionTitles.map((title) => Tab(text: title)).toList(),
          onTap: (index) {
            // TODO(youngjin.kim): 해당 섹션으로 스크롤 이동
          },
        ),
      ),
      body: const Center(
        child: Text('Stock'),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
