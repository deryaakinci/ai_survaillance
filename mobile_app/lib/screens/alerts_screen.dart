import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alert_provider.dart';
import '../models/alert_model.dart';
import 'alert_detail_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  /// Map an audio_label to a human-readable alert title.
  String _alertTitle(String audioLabel) {
    final titles = {
      'gunshot': '🚨 Gunshot detected',
      'explosion': '🚨 Explosion detected',
      'scream': '⚠️ Scream detected',
      'glass_break': '⚠️ Glass break detected',
      'forced_entry': '🚨 Forced entry detected',
      'crying_distress': '⚠️ Distress detected',
      'fight_sounds': '⚠️ Fight detected',
      'siren': '⚠️ Emergency siren nearby',
      'car_crash': '🚨 Car crash detected',
      'weapon': '🚨 Weapon detected',
      'fight': '⚠️ Fight detected',
      'assault': '🚨 Assault detected',
      'robbery': '🚨 Robbery detected',
      'abuse': '⚠️ Abuse detected',
    };
    return titles[audioLabel] ??
        '⚠️ ${audioLabel.replaceAll('_', ' ')}';
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'high':
        return const Color(0xFFE24B4A);
      case 'medium':
        return const Color(0xFFEF9F27);
      default:
        return const Color(0xFF1D9E75);
    }
  }

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
                'Alerts',
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
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7F77DD),
                      ),
                    );
                  }
                  if (provider.alerts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No alerts',
                        style: TextStyle(color: Color(0xFF555555)),
                      ),
                    );
                  }

                  // ── Deduplicate: group by audio_label, keep the latest ──
                  final Map<String, AlertModel> uniqueAlerts = {};
                  final Map<String, int> alertCounts = {};
                  for (final alert in provider.alerts) {
                    final key = alert.audioLabel;
                    alertCounts[key] = (alertCounts[key] ?? 0) + 1;
                    if (!uniqueAlerts.containsKey(key)) {
                      uniqueAlerts[key] = alert;
                    }
                  }
                  final deduped = uniqueAlerts.values.toList();

                  return ListView.builder(
                    itemCount: deduped.length,
                    itemBuilder: (ctx, i) {
                      final alert = deduped[i];
                      final count = alertCounts[alert.audioLabel] ?? 1;
                      final color = _severityColor(alert.severity);

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AlertDetailScreen(alert: alert),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161622),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              // Severity color dot
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Alert name only
                              Expanded(
                                child: Text(
                                  _alertTitle(alert.audioLabel),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Instance count badge (if > 1)
                              if (count > 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '×$count',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF444444),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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