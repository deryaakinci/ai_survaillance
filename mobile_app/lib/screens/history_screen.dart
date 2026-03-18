import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alert_provider.dart';
import '../widgets/alert_card.dart';
import 'alert_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Consumer<AlertProvider>(
                builder: (context, provider, _) {
                  if (provider.alerts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No history yet',
                        style: TextStyle(color: Color(0xFF555555)),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: provider.alerts.length,
                    itemBuilder: (ctx, i) => AlertCard(
                      alert: provider.alerts[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlertDetailScreen(
                            alert: provider.alerts[i],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}