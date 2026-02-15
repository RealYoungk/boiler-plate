import 'package:flutter/material.dart';

class StockView extends StatelessWidget {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
      body: const Center(
        child: Text('Stock'),
      ),
    );
  }
}
