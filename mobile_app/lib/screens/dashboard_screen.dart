import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alert_provider.dart';
import '../widgets/alert_card.dart';
import '../widgets/stat_card.dart';
import 'alert_detail_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AlertProvider>().loadAlerts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Consumer<AlertProvider>(
          builder: (context, provider, _) {
            return RefreshIndicator(
              onRefresh: provider.loadAlerts,
              color: const Color(0xFF7F77DD),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              _SensorStatusBadge(
                                audioOnline: provider.audioOnline,
                                visualOnline: provider.visualOnline,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          StatCard(
                            number: provider.todayAlerts.length.toString(),
                            label: 'Today',
                            dotColor: const Color(0xFFE24B4A),
                          ),
                          const SizedBox(width: 8),
                          StatCard(
                            number: provider.alerts.length.toString(),
                            label: 'This week',
                            dotColor: const Color(0xFFEF9F27),
                          ),
                          const SizedBox(width: 8),
                          const StatCard(
                            number: '98%',
                            label: 'Accuracy',
                            dotColor: Color(0xFF1D9E75),
                          ),
                        ],
                      ),
                    ),
                    if (!provider.audioOnline || !provider.visualOnline)
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1800),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFEF9F27),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFEF9F27),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                !provider.audioOnline &&
                                        !provider.visualOnline
                                    ? 'All sensors offline — system not monitoring'
                                    : !provider.audioOnline
                                        ? 'Audio sensor offline — visual only mode (~70% accuracy)'
                                        : 'Visual sensor offline — audio only mode (~70% accuracy)',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFEF9F27),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Text(
                        'Recent alerts',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                    if (provider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(
                            color: Color(0xFF7F77DD),
                          ),
                        ),
                      )
                    else if (provider.alerts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No alerts yet',
                            style: TextStyle(color: Color(0xFF555555)),
                          ),
                        ),
                      )
                    else
                      ...provider.alerts.take(5).map(
                            (alert) => AlertCard(
                              alert: alert,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AlertDetailScreen(alert: alert),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SensorStatusBadge extends StatelessWidget {
  final bool audioOnline;
  final bool visualOnline;

  const _SensorStatusBadge({
    required this.audioOnline,
    required this.visualOnline,
  });

  @override
  Widget build(BuildContext context) {
    final bothOnline = audioOnline && visualOnline;
    final bothOffline = !audioOnline && !visualOnline;

    final color = bothOnline
        ? const Color(0xFF1D9E75)
        : bothOffline
            ? const Color(0xFFE24B4A)
            : const Color(0xFFEF9F27);

    final bgColor = bothOnline
        ? const Color(0xFF0A1F14)
        : bothOffline
            ? const Color(0xFF1A0A0A)
            : const Color(0xFF1F1800);

    final label = bothOnline
        ? 'All sensors online'
        : bothOffline
            ? 'All sensors offline'
            : 'Sensor degraded';

    return GestureDetector(
      onTap: () => _showSensorDetails(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: color, width: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 9, color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _showSensorDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF13131F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sensor status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _sensorRow(
              'Audio sensor',
              'Microphone input',
              audioOnline,
              Icons.mic,
            ),
            const SizedBox(height: 12),
            _sensorRow(
              'Visual sensor',
              'Camera input',
              visualOnline,
              Icons.videocam,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimated reliability',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    audioOnline && visualOnline
                        ? '~91% — fully operational'
                        : audioOnline || visualOnline
                            ? '~70% — degraded mode'
                            : '0% — system offline',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: audioOnline && visualOnline
                          ? const Color(0xFF1D9E75)
                          : audioOnline || visualOnline
                              ? const Color(0xFFEF9F27)
                              : const Color(0xFFE24B4A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sensorRow(
    String title,
    String subtitle,
    bool online,
    IconData icon,
  ) {
    final color =
        online ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A);
    final bgColor =
        online ? const Color(0xFF0A1F14) : const Color(0xFF1A0A0A);
    final statusText = online ? 'Online' : 'Offline';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF222222),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color, width: 0.5),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}