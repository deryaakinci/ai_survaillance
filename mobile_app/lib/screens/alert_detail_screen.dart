import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class AlertDetailScreen extends StatelessWidget {
  final AlertModel alert;

  const AlertDetailScreen({super.key, required this.alert});

  Color get _severityColor {
    switch (alert.severity) {
      case 'high':
        return const Color(0xFFE24B4A);
      case 'medium':
        return const Color(0xFFEF9F27);
      default:
        return const Color(0xFF1D9E75);
    }
  }

  String get _severityLabel {
    switch (alert.severity) {
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      default:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF888888),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Alert detail',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _severityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_severityLabel risk',
                        style: TextStyle(
                          fontSize: 10,
                          color: _severityColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF13131F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF222222),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: _severityColor.withOpacity(0.08),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: _severityColor.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: _severityColor,
                              size: 32,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Snapshot captured',
                              style: TextStyle(
                                fontSize: 10,
                                color: _severityColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.audioLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${alert.timestamp.day}/${alert.timestamp.month}/${alert.timestamp.year} · ${alert.timestamp.hour}:${alert.timestamp.minute.toString().padLeft(2, '0')} · ${alert.zone}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF555555),
                            ),
                          ),
                          const Divider(
                            color: Color(0xFF1A1A1A),
                            height: 24,
                          ),
                          _detailRow('Sound type', alert.audioLabel,
                              const Color(0xFF7F77DD)),
                          const SizedBox(height: 8),
                          _detailRow('Activity', alert.visualLabel,
                              const Color(0xFF1D9E75)),
                          const SizedBox(height: 8),
                          _detailRow('Location', alert.zone,
                              const Color(0xFFE0E0E0)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        'Call police',
                        const Color(0xFF1D9E75),
                        const Color(0xFF0D1F17),
                        () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _actionButton(
                        'View clip',
                        const Color(0xFF7F77DD),
                        const Color(0xFF1A1A2E),
                        () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _actionButton(
                        'Dismiss',
                        const Color(0xFF555555),
                        const Color(0xFF1A1A1A),
                        () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            color: valueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
    String label,
    Color textColor,
    Color bgColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: textColor, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}