import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alert_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Consumer<AlertProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Text(
                      'Analytics',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13131F),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF222222),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [7, 30, 90].map((days) {
                          final isActive = provider.selectedDays == days;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => provider.setDays(days),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF7F77DD)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '$days days',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: isActive
                                          ? Colors.white
                                          : const Color(0xFF555555),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _miniStatCard(
                          provider.alerts.length.toString(),
                          'Total alerts',
                          const Color(0xFFE24B4A),
                        ),
                        const SizedBox(width: 8),
                        _miniStatCard(
                          '${provider.todayAlerts.length}',
                          'Today',
                          const Color(0xFFEF9F27),
                        ),
                        const SizedBox(width: 8),
                        _miniStatCard(
                          '98%',
                          'Accuracy',
                          const Color(0xFF1D9E75),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _breakdownCard(provider),
                  const SizedBox(height: 8),
                  _heatmapCard(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _miniStatCard(String num, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF13131F),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF222222), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 4),
            Text(
              num,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _breakdownCard(AlertProvider provider) {
final types = [
  {'label': 'Gunshot', 'color': const Color(0xFF7F77DD), 'key': 'gunshot'},
  {'label': 'Explosion', 'color': const Color(0xFFE24B4A), 'key': 'explosion'},
  {'label': 'Scream', 'color': const Color(0xFFEF9F27), 'key': 'scream'},
  {'label': 'Break in', 'color': const Color(0xFF1D9E75), 'key': 'break_in'},
  {'label': 'Glass break', 'color': const Color(0xFF85B7EB), 'key': 'glass_break'},
  {'label': 'Fight', 'color': const Color(0xFFD85A30), 'key': 'fight'},
  {'label': 'Door forced', 'color': const Color(0xFFD4537E), 'key': 'door_forced'},
  {'label': 'Weapon', 'color': const Color(0xFF5DCAA5), 'key': 'weapon'},
];
    final total = provider.alerts.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF222222), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alert breakdown by type',
            style: TextStyle(fontSize: 10, color: Color(0xFF555555)),
          ),
          const SizedBox(height: 10),
          ...types.map((t) {
            final count = provider.countByType(t['key'] as String);
            final pct = total > 0 ? count / total : 0.0;
            final color = t['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t['label'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: color.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _heatmapCard() {
    final hours = [
      4, 3, 2, 3, 2, 3, 8, 14, 10, 4, 3, 3,
      18, 12, 4, 3, 2, 3, 2, 2, 3, 2, 3, 2
    ];
    final maxVal = hours.reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF222222), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Most active hours',
            style: TextStyle(fontSize: 10, color: Color(0xFF555555)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: hours.map((v) {
                final h = (v / maxVal * 36).clamp(2.0, 36.0);
                final isPeak = v == maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                      height: h,
                      decoration: BoxDecoration(
                        color: isPeak
                            ? const Color(0xFFE24B4A)
                            : const Color(0xFF7F77DD),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('12am',
                  style: TextStyle(fontSize: 8, color: Color(0xFF444444))),
              Text('6am',
                  style: TextStyle(fontSize: 8, color: Color(0xFF444444))),
              Text('12pm',
                  style: TextStyle(fontSize: 8, color: Color(0xFF444444))),
              Text('6pm',
                  style: TextStyle(fontSize: 8, color: Color(0xFF444444))),
              Text('12am',
                  style: TextStyle(fontSize: 8, color: Color(0xFF444444))),
            ],
          ),
        ],
      ),
    );
  }
}